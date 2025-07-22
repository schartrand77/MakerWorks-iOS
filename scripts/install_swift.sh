#!/usr/bin/env bash
# Install Swift toolchain on Ubuntu 20.04+
# Usage: sudo ./install_swift.sh
set -e
SWIFT_VERSION="5.9.2"
PLATFORM="ubuntu20.04"
TMPDIR=$(mktemp -d)
SWIFT_ARCHIVE="swift-${SWIFT_VERSION}-RELEASE-${PLATFORM}.tar.gz"
SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/${PLATFORM}/swift-${SWIFT_VERSION}-RELEASE/${SWIFT_ARCHIVE}"

# Install system dependencies
apt-get update
apt-get install -y clang libicu-dev libcurl4-openssl-dev libpython3.8 libedit2 libxml2

# Download and install Swift
curl -L "$SWIFT_URL" -o "$TMPDIR/$SWIFT_ARCHIVE"
mkdir -p /opt/swift
tar -xzf "$TMPDIR/$SWIFT_ARCHIVE" -C /opt/swift
ln -s /opt/swift/swift-${SWIFT_VERSION}-RELEASE-${PLATFORM}/usr/bin/swift /usr/local/bin/swift

rm -rf "$TMPDIR"

echo "Swift ${SWIFT_VERSION} installed. You can now run 'swift --version'."
