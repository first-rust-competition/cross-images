#!/bin/bash
set -euxo pipefail

UPDATE_SUITE_TAR=data.tar.gz
UPDATE_SUITE_DIR=$(mktemp -d)
OUTER_CAB_DIR=$(mktemp -d)
INNER_ZIP_DIR=$(mktemp -d)

function cleanup {
    rm -f "$UPDATE_SUITE_TAR"
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
UTILITIES_FILENAME=$(wget -O - "$FEED_URL/Packages" | grep "ni-frc-$YEAR-utilities_$UTILITIES_VERSION.*\.nipkg" | cut -d ' ' -f 2- | tr -d '\r')

wget -O - "$FEED_URL/$UTILITIES_FILENAME" | tar -zxf - "$UPDATE_SUITE_TAR"

tar -zxf "$UPDATE_SUITE_TAR" -C "$UPDATE_SUITE_DIR"

OUTER_CAB=$(find "$UPDATE_SUITE_DIR" -path '*/FRC_U00/*.cab' -exec du {} + | sort -n | tail -n 1 | awk '{$1=""; print substr($0, 2)}')
cabextract -q "$OUTER_CAB" -d "$OUTER_CAB_DIR"

INNER_ZIP=$(find "$OUTER_CAB_DIR" -type f -exec du {} + | sort -n | tail -n 1 | awk '{$1=""; print substr($0, 2)}')
unzip -q "$INNER_ZIP" -d "$INNER_ZIP_DIR"
unzip -q "$INNER_ZIP_DIR/*.zip" -d "$INNER_ZIP_DIR"

cp "$INNER_ZIP_DIR/systemimage.tar.gz" .
