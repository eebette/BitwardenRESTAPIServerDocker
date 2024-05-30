#!/bin/bash

set -e

if [[ -n "${BW_HOST}" ]]; then
	echo "Configuring CLI to utilize server ${BW_HOST}"
	bw config server "${BW_HOST}"
else
	echo "Env variable BW_HOST not detected."
fi

# Allow login to fail if already logged in
bw login --apikey || $TRUE

echo 'Running `bw serve` on port 8087'
bw serve --hostname 0.0.0.0 &

while true; do
  if [[ $( curl -s http://localhost:8087/status | jq .data.template.status ) == '"unauthenticated"' ]]; then
    echo "Unexpectedly logged out. Killing service..."
    kill -9 "$(pgrep -f 'bw serve')"

    if [[ $( { bw login --check | sed -n -e '';} 2>&1 ) == 'You are not logged in.' ]]; then
      echo "Logging back in..."
      bw login --apikey
    fi

    echo "Restarting service..."
    bw serve --hostname 0.0.0.0 &
  fi

  sleep 10

done