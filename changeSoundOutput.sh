#!/bin/bash

active=($(pactl list sinks short | grep RUNNING))
activeId=${active[0]}

pactl list sinks short | while read -r line; do
                           device=($line);
                           deviceId=${device[0]}

                           if ! [ "$deviceId" = "$activeId" ]; then
                              pactl set-default-sink "$deviceId"
                           fi

                         done;