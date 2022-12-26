#!/bin/bash
shopt -s extglob;

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure?} [Y/n] " response
    case $response in
        @([nN])*([oO]))
            false
            ;;
        *)
            true
            ;;
    esac
}

ACME=$HOME/.acme.sh/


ARED='\x1b[31;1m'
AURL='\x1b[39;49m'
resetOutput=$(tput sgr0)

# check acme.sh installed or aliases set
if ! "${ACME}/acme.sh" >/dev/null 2>&1; then
        echo -e "${ARED}acme not installed or aliases not set${resetOutput}"
        echo -e "checkout ${AURL}https://github.com/acmesh-official/acme.sh/wiki/How-to-install${resetOutput}"
        exit 1
fi

# Get from user
echo "1- Get New TLS (Default)"
echo "2- Renew Your TLS"
echo -n "Which do you want? (number): "
read -r WHAT

case $WHAT in
   1)
       WANT=new
	   ;;
   2)
       WANT=renew
       ;;
   *)
       WANT=new
       echo "set to default (1- new)"
       ;;
esac

# Get from user
echo "1- Cloudflare (Default)"
echo "2- ArvanCloud"
echo -n "Which do you use? (number): "
read -r SERVICE

case $SERVICE in
   1)
	   USING=cloud
	   ;;
   2)
	  USING=arvan
	   ;;
   *)
	   USING=cloud
       echo "set to default (1- cloudflare)"
	   ;;
esac

echo "/////////////////////////////////////"
echo " "

# Get Domain Name
echo -n "Enter your Domain: "
read -r domain
echo " "
echo " "


# //// Get new Cert ////
if [ $WANT = 'new' ]; then

    if [ $USING = 'cloud' ]; then
      cat "${ACME}/account.conf" | grep SAVED_CF_Account_ID && {
        cat "${ACME}/account.conf" | grep SAVED_CF_Token && {
          echo -n "Cloudflare Tokens ware Set: "

          # Issue a cert
          confirm "Are Their Correct?" && "${ACME}/acme.sh" --issue --dns dns_cf -d "$domain" --server letsencrypt --debug
        }
      }

      # Get Cloudflare API
      echo -n "Enter your Cloudflare API Token: "
      read -r capi
      echo -n "Enter your Cloudflare Account ID: "
      read -r cid

      # Set Api
      export CF_Token="$capi"
      export CF_Account_ID="$cid"

      echo " "
      echo " "

      # Issue a cert
      "${ACME}/acme.sh" --issue --dns dns_cf -d "$domain" --server letsencrypt --debug

    elif [ $USING = 'arvan' ]; then
        # Get Arvan API
        echo -n "Enter your Arvan API: "
        read -r aapi

        # Set API
        export Arvan_Token="$aapi"

        echo " "
        echo " "

        # Issue a cert
        "${ACME}/acme.sh" --issue --dns dns_arvan -d "$domain" --server letsencrypt

    else
        echo "new unknown"
    fi

# //// Renew The cert ////
elif [ $WANT = 'renew' ]; then

    if [ $USING = 'cloud' ]; then
        echo " "

        # Renew a cert from cloudflare
        "${ACME}/acme.sh" --issue --dns dns_cf -d "$domain" --server letsencrypt --renew --force

    elif [ $USING = 'arvan' ]; then
        echo " "

        # Renew a cert
        "${ACME}/acme.sh" --issue --dns dns_arvan -d "$domain" --server letsencrypt --renew --force

    else
        echo "renew unknown"
    fi

else
    echo "all unknown"

fi
shopt -u extglob;