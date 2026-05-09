#!/bin/bash

# Exit on any error
set -e

# Color Definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper Functions
msg() { echo -e "${GREEN}[*] $1${NC}"; }
warn() { echo -e "${RED}[!] $1${NC}"; }

# Error Trap
trap 'warn "Build failed! Check the output above for errors."' ERR

VERSION=$1

if [ -z "$VERSION" ]; then
    warn "No version specified."
    echo "Usage: ./build_openwrt.sh <version_number>"
    echo "Example: ./build_openwrt.sh 25.12.3"
    exit 1
fi

msg "Starting OpenWrt v$VERSION build for x86_64..."

# 1. Install Necessary Packages
msg "Installing build dependencies..."
sudo apt update
sudo apt install -y build-essential clang flex g++ gawk gcc-multilib gettext \
git libncurses-dev libssl-dev python3-dev rsync unzip zlib1g-dev swig \
libpython3-dev libelf-dev python3-full python3-setuptools wget ccache

# 2. Clone OpenWrt and Checkout Version
if [ ! -d "openwrt" ]; then
    msg "Cloning OpenWrt repository..."
    git clone https://github.com/openwrt/openwrt.git
fi

cd openwrt
msg "Checking out version v$VERSION..."
git fetch --tags
git checkout v$VERSION

# 3. Match Official Package Feeds
msg "Fetching official feeds for v$VERSION..."
FEED_URL="https://downloads.openwrt.org/releases/$VERSION/targets/x86/64/feeds.buildinfo"
if wget -q --method=HEAD "$FEED_URL"; then
    wget "$FEED_URL" -O feeds.conf
    msg "Using official feeds.buildinfo."
else
    warn "Official feeds.buildinfo not found. Using repository defaults."
fi

./scripts/feeds update -a
./scripts/feeds install -a

# 4. Import Official Build Configuration
msg "Importing official config.buildinfo seed..."
CONFIG_URL="https://downloads.openwrt.org/releases/$VERSION/targets/x86/64/config.buildinfo"
wget -q "$CONFIG_URL" -O .config

# 5. Set target to x86_64 and Partition Size
msg "Customizing partition size to 1024 MiB..."
sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' .config
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=1024" >> .config

# Ensure target is explicitly set for x86_64
sed -i 's/CONFIG_TARGET_x86=y/CONFIG_TARGET_x86=y/' .config
sed -i 's/CONFIG_TARGET_x86_64=y/CONFIG_TARGET_x86_64=y/' .config

# 6. Expand and Validate Configuration
msg "Expanding configuration (make defconfig)..."
make defconfig

# 7. Start Compile
msg "Starting compilation with $(nproc) cores..."
msg "Using V=s for detailed logging."

# Note: We use the internal ccache if you enabled it in menuconfig earlier
make -j$(nproc) V=s

msg "Build Complete! Your images are in bin/targets/x86/64/"