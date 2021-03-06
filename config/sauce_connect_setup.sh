#!/bin/bash

set -e

# Setup and start Sauce Connect for your TravisCI build
# This script requires your .travis.yml to include the following two private env variables:
# SAUCE_USERNAME
# SAUCE_ACCESS_KEY
# Follow the steps at https://saucelabs.com/opensource/travis to set that up.
#
# Curl and run this script as part of your .travis.yml before_script section:
# before_script:
#   - curl https://gist.github.com/santiycr/5139565/raw/sauce_connect_setup.sh -L | bash

CONNECT_URL="http://saucelabs.com/downloads/Sauce-Connect-latest.zip"
CONNECT_DIR="/tmp/sauce-connect-$RANDOM"
CONNECT_DOWNLOAD="Sauce_Connect.zip"

CONNECT_LOG="$LOGS_DIR/sauce-connect"
CONNECT_STDOUT="$LOGS_DIR/sauce-connect.stdout"
CONNECT_STDERR="$LOGS_DIR/sauce-connect.stderr"

READY_FILE="connect-ready-$RANDOM"

# Get Connect and start it
mkdir -p $CONNECT_DIR
cd $CONNECT_DIR
curl $CONNECT_URL -o $CONNECT_DOWNLOAD 2> /dev/null 1> /dev/null
unzip $CONNECT_DOWNLOAD > /dev/null
rm $CONNECT_DOWNLOAD

echo "Starting Sauce Connect in the background, logging into:"
echo "  $CONNECT_LOG"
echo "  $CONNECT_STDOUT"
echo "  $CONNECT_STDERR"

java -jar Sauce-Connect.jar --readyfile $READY_FILE \
    --tunnel-identifier $TRAVIS_JOB_NUMBER \
    $SAUCE_USERNAME $SAUCE_ACCESS_KEY &

# Wait for Connect to be ready before exiting
while [ ! -f $READY_FILE ]; do
  sleep .5
done
