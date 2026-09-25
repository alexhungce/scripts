#!/bin/bash
set -euo pipefail

# install necessary packages
sudo apt-get update
sudo apt-get install -y \
	build-essential \
	bison \
	ccache \
	flex \
	git \
	meson \
	ninja-build \
	pkg-config \
	libdrm-dev \
	libdw-dev \
	libglib2.0-dev \
	libjson-c-dev \
	libkmod-dev \
	libpci-dev \
	libpciaccess-dev \
	libpixman-1-dev \
	libproc2-dev \
	libudev-dev \
	libv4l-dev \
	libcups2-dev \
	libcairo2-dev \
	libelf-dev \
	libconfig-dev \
	libprotobuf-dev \
	protobuf-compiler


cd "$HOME"

if [[ -d src/igt-gpu-tools ]]; then
	git -C src/igt-gpu-tools pull --ff-only
else
	mkdir -p src
	git clone https://gitlab.freedesktop.org/drm/igt-gpu-tools.git src/igt-gpu-tools
fi
cd src/igt-gpu-tools && CC='ccache gcc' meson setup build && ninja -C build
