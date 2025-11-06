# 基础镜像：Docker Hub 原版 Ubuntu 20.04
FROM ubuntu:20.04

# 避免交互模式（安装依赖时无需手动确认）
ENV DEBIAN_FRONTEND=noninteractive

# 第一步：安装基础依赖包（修复换行符，移除行尾多余空格）
RUN apt-get update && apt-get install -y \
    gcc g++ binutils patch bzip2 flex make gettext \
    pkg-config unzip zlib1g-dev libc6-dev subversion libncurses5-dev gawk \
    sharutils curl libxml-parser-perl ocaml-nox ocaml ocaml-findlib \
    python-yaml libssl-dev libfdt-dev bison texi2html diffstat dos2unix \
    texinfo chrpath bc gcc-multilib git build-essential autoconf libtool \
    libncurses-dev gperf lib32z1 libc6-i386 g++-multilib python-git \
    coccinelle zstd liblz4-tool cproto device-tree-compiler u-boot-tools \
    automake libparmap-ocaml-dev libpcre-ocaml-dev \
    && rm -rf /var/lib/apt/lists/*

# 第二步：卸载旧版 coccinelle 并从源码编译安装 1.1.1 版本
RUN apt-get remove --purge -y libparmap-ocaml coccinelle \
    && git clone https://github.com/coccinelle/coccinelle.git \
    && cd coccinelle \
    && git checkout 1.1.1 \
    && ./autogen \
    && ./configure \
    && make \
    && make install \
    && cd .. && rm -rf coccinelle \
    && rm -rf /var/lib/apt/lists/*

# 第三步：安装指定版本的 make
RUN curl -LO http://launchpadlibrarian.net/366014597/make_4.1-9.1ubuntu1_amd64.deb \
    && dpkg -i make_4.1-9.1ubuntu1_amd64.deb \
    && rm -f make_4.1-9.1ubuntu1_amd64.deb \
    && apt-get clean

# 验证关键工具版本
RUN gcc --version && make --version && spatch --version