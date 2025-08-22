#!/bin/bash
shopt -s -o nounset

# install necessary packages
sudo apt-get update
sudo apt-get install -y \
	build-essential \
	bison \
	flex \
	git \
	meson \
	ninja-build \
	pkg-config \
	libdrm-dev \
	libdw-dev \
	libglib2.0-dev \
	libkmod-dev \
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


cd $HOME

[ -d src ] || mkdir src
cd src

git clone https://gitlab.freedesktop.org/drm/igt-gpu-tools.git
cd igt-gpu-tools && meson setup build && ninja -C build