#!/bin/bash
set -euxo pipefail

UPDATE_SUITE_DIR=$(mktemp -d)
OUTER_CAB_DIR=$(mktemp -d)
INNER_ZIP_DIR=$(mktemp -d)

function cleanup {
    rm -rf "$UPDATE_SUITE_DIR"
    rm -rf "$OUTER_CAB_DIR"
    rm -rf "$INNER_ZIP_DIR"
}

trap cleanup EXIT
# 2020_19.0_19.0.0.49153-0+f1
VERSION_TUPLE="$1"
YEAR=$(echo "$VERSION_TUPLE" | cut -d _ -f 1)
GAME_TOOLS_VERSION=$(echo "$VERSION_TUPLE" | cut -d _ -f 2)
UTILITIES_VERSION=$(echo "$VERSION_TUPLE" | cut -d _ -f 3)

FEED_URL="https://download.ni.com/support/nipkg/products/ni-f/ni-frc-$YEAR-game-tools/$GAME_TOOLS_VERSION/released"
UTILITIES_FILENAME=$(wget -q -O - "$FEED_URL/Packages" | grep "ni-frc-$YEAR-utilities_$UTILITIES_VERSION.*\.nipkg" | cut -d ' ' -f 2- | tr -d '\r')

wget -q -O - "$FEED_URL/$UTILITIES_FILENAME" |
    bsdtar -xOf - data.tar.gz |
    bsdtar -zxf - -C "$UPDATE_SUITE_DIR"

cabextract -q "$UPDATE_SUITE_DIR/FRC_U00/FRC_U00.cab" -d "$OUTER_CAB_DIR"

INNER_ZIP=$(du "$OUTER_CAB_DIR"/* | sort -nr | head -1 | cut -f2)
unzip -q "$INNER_ZIP" "roboRIO_*.zip"
unzip -q roboRIO_*.zip systemimage.tar.gz

basename roboRIO_*.zip .zip | cut -c 9- > DOCKER_TAG
