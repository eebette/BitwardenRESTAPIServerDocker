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

echo 'Running `bw server` on port 8087'
bw serve --hostname 0.0.0.0
