#!/bin/bash
set -euxo pipefail

UPDATE_SUITE_ZIP=$1
OUTPUT_DIR=$2

UPDATE_SUITE_DIR=$(mktemp -d)
OUTER_CAB_DIR=$(mktemp -d)
INNER_ZIP_DIR=$(mktemp -d)

function cleanup {
    rm -rf "$UPDATE_SUITE_DIR"
    rm -rf "$OUTER_CAB_DIR"
    rm -rf "$INNER_ZIP_DIR"
}

trap cleanup EXIT

unzip -q "$UPDATE_SUITE_ZIP" -d "$UPDATE_SUITE_DIR"

OUTER_CAB=$(find "$UPDATE_SUITE_DIR" -path '*/FRC_Utilities/*.cab' -exec du {} + | sort -n | tail -n 1 | awk '{$1=""; print substr($0, 2)}')
cabextract -q "$OUTER_CAB" -d "$OUTER_CAB_DIR"

INNER_ZIP=$(find "$OUTER_CAB_DIR" -type f -exec du {} + | sort -n | tail -n 1 | awk '{$1=""; print substr($0, 2)}')
unzip -q "$INNER_ZIP" -d "$INNER_ZIP_DIR"
unzip -q "$INNER_ZIP_DIR/*.zip" -d "$INNER_ZIP_DIR"

mkdir -p "$OUTPUT_DIR"

tar -xf "$INNER_ZIP_DIR/systemimage.tar.gz" -C "$OUTPUT_DIR"
