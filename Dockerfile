FROM debian:10

# ENV OPTIONS --allow 1.1.1.1 --allow 2.2.2.2

RUN echo "deb http://deb.debian.org/debian/ buster contrib non-free" | tee -a /etc/apt/sources.list.d/full.list
RUN echo "deb-src http://deb.debian.org/debian/ buster contrib non-free" | tee -a /etc/apt/sources.list.d/full.list



# Install the compilers
# Remove caches to keep layer size small
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    distcc \
    gcc-8 \
    g++-8 \
    gcc-8-aarch64-linux-gnu \
    gcc-8-arm-linux-gnueabi \
    gcc-8-arm-linux-gnueabihf \
    gcc-8-riscv64-linux-gnu \
    g++-8-aarch64-linux-gnu \
    g++-8-arm-linux-gnueabi \
    g++-8-arm-linux-gnueabihf \
    g++-8-riscv64-linux-gnu \
    clang && \
  rm -rf /var/lib/apt/lists/*

#set default
RUN ln /usr/bin/x86_64-linux-gnu-gcc-8 /usr/bin/x86_64-linux-gnu-gcc 
RUN ln /usr/bin/x86_64-linux-gnu-g++-8 /usr/bin/x86_64-linux-gnu-g++

RUN ln /usr/bin/distcc /usr/lib/distcc/x86_64-linux-gnu-g++
#RUN ln /usr/bin/distcc /usr/lib/distcc/x86_64-linux-gnu-g++-8
RUN ln /usr/bin/distcc /usr/lib/distcc/x86_64-linux-gnu-gcc
#RUN ln /usr/bin/distcc /usr/lib/distcc/x86_64-linux-gnu-gcc-8

RUN ln /usr/bin/distcc /usr/lib/distcc/aarch64-linux-gnu-gcc-8
RUN ln /usr/bin/distcc /usr/lib/distcc/aarch64-linux-gnu-gcc
RUN ln /usr/bin/distcc /usr/lib/distcc/aarch64-linux-gnu-g++-8
RUN ln /usr/bin/distcc /usr/lib/distcc/aarch64-linux-gnu-g++

RUN ln /usr/bin/distcc /usr/lib/distcc/arm-linux-gnueabihf-g++-8
RUN ln /usr/bin/distcc /usr/lib/distcc/arm-linux-gnueabihf-gcc-8
RUN ln /usr/bin/distcc /usr/lib/distcc/arm-linux-gnueabihf-g++
RUN ln /usr/bin/distcc /usr/lib/distcc/arm-linux-gnueabihf-gcc

RUN ln /usr/bin/distcc /usr/lib/distcc/arm-linux-gnueabi-g++-8
RUN ln /usr/bin/distcc /usr/lib/distcc/arm-linux-gnueabi-gcc-8
RUN ln /usr/bin/distcc /usr/lib/distcc/arm-linux-gnueabi-g++
RUN ln /usr/bin/distcc /usr/lib/distcc/arm-linux-gnueabi-gcc


RUN ln /usr/bin/distcc /usr/lib/distcc/riscv64-linux-gnu-g++-8
RUN ln /usr/bin/distcc /usr/lib/distcc/riscv64-linux-gnu-gcc-8
RUN ln /usr/bin/distcc /usr/lib/distcc/riscv64-linux-gnu-g++
RUN ln /usr/bin/distcc /usr/lib/distcc/riscv64-linux-gnu-gcc


RUN update-distcc-symlinks # has to be after


# This is the operations port
EXPOSE 3632
# This is the statistics port
EXPOSE 3633

USER distccd

ENTRYPOINT distccd -j64 --daemon --no-detach --listen 0.0.0.0 --port 3632 --stats --stats-port 3633  $OPTIONS
#--verbose --log-stderr

#pump make -j1 CC="distcc gcc"

#for debian i had to compile pump from source
#pump make -j1 ARCH=arm64 CC="distcc aarch64-linux-gnu-gcc"  CROSS_COMPILE="aarch64-linux-gnu-" 



