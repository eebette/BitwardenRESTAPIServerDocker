#!/bin/bash

while true; do
  if [[ $( { bw login --check | sed -n -e '';} 2>&1 ) == 'You are not logged in.' ]]; then
    echo "Logging back in..."
    bw login --apikey
  fi
  sleep 10
done
