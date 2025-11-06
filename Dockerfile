FROM ubuntu:20.04  # 默认从 DockerHub 拉取 ubuntu 镜像

# 避免交互模式导致的安装中断
ENV DEBIAN_FRONTEND=noninteractive

# 以下步骤与之前一致，完整执行你的安装命令
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    gcc g++ binutils patch bzip2 flex make gettext \
    pkg-config unzip zlib1g-dev libc6-dev subversion libncurses5-dev gawk \
    sharutils curl libxml-parser-perl ocaml-nox ocaml ocaml-findlib \
    python-yaml libssl-dev libfdt-dev bison texi2html diffstat dos2unix \
    texinfo chrpath bc gcc-multilib git build-essential autoconf libtool \
    libncurses-dev gperf lib32z1 libc6-i386 g++-multilib python-git \
    coccinelle zstd liblz4-tool cproto && \
    apt-get install -y device-tree-compiler u-boot-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get remove -y --purge libparmap-ocaml && \
    dpkg -r coccinelle || true && \
    git clone https://github.com/coccinelle/coccinelle.git && \
    cd coccinelle && \
    git checkout 1.1.1 && \
    apt-get install -y automake && \
    ./autogen && \
    ./configure && \
    make && \
    make install && \
    cd .. && rm -rf coccinelle && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y libparmap-ocaml-dev libpcre-ocaml-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget http://launchpadlibrarian.net/366014597/make_4.1-9.1ubuntu1_amd64.deb && \
    dpkg -i make_4.1-9.1ubuntu1_amd64.deb && \
    rm make_4.1-9.1ubuntu1_amd64.deb

WORKDIR /workspace
CMD ["bash"]
