#!/bin/bash
shopt -s -o nounset

readonly UBUNTU=( noble plucky )  # Adjust Ubuntu versions as needed
TAB="$(printf '\t')"

create_dockerfile () {
cat <<- EOF > Dockerfile
FROM ubuntu:${1}

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for building igt-gpu-tools
RUN apt-get update && apt-get install -y \
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
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

# Clone igt-gpu-tools repository
WORKDIR /root
RUN git clone https://gitlab.freedesktop.org/drm/igt-gpu-tools.git

# Set working directory
WORKDIR /root/igt-gpu-tools

# Copy the patch from the host
COPY *.patch .

# Apply the patch
RUN git config --global user.email "abc@xyz.com"
RUN git config --global user.name "ABC XYZ"
RUN git am *.patch
RUN git log --oneline -5

RUN meson setup build && ninja -C build

CMD ["/bin/bash"]
EOF
}

create_makefile () {
cat <<- EOF > Makefile
all: clean build

build:
${TAB}docker build -t igt-gpu-tools-${1} .
clean:
${TAB}-docker rmi igt-gpu-tools-${1}
${TAB}-docker rmi ubuntu:${1}
EOF
}

#if ! which docker > /dev/null ; then
#	echo "Installing docker..."
#	sudo apt-get -y install docker.io
#	sudo usermod -aG docker $USER
#	sudo service docker restart
#	exit
#fi

[ -d docker ] || mkdir docker
cd docker
for i in "${UBUNTU[@]}"
do
	[ -d ${i} ] || mkdir ${i}
	cd ${i}
	create_dockerfile ${i}
	create_makefile ${i}
	cd ..
	cd ${i}
	cp ../../*.patch .
	make && make clean
	cd ..
done

# if a build fails, the docker image will be available
docker images

