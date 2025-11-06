FROM ubuntu:20.04

# 避免交互模式导致的安装中断
ENV DEBIAN_FRONTEND=noninteractive

# 更新系统并安装基础依赖
RUN apt-get update && apt-get upgrade -y && \
    # 安装第一组依赖
    apt-get install -y \
    gcc g++ binutils patch bzip2 flex make gettext \
    pkg-config unzip zlib1g-dev libc6-dev subversion libncurses5-dev gawk \
    sharutils curl libxml-parser-perl ocaml-nox ocaml ocaml-findlib \
    python-yaml libssl-dev libfdt-dev bison texi2html diffstat dos2unix \
    texinfo chrpath bc gcc-multilib git build-essential autoconf libtool \
    libncurses-dev gperf lib32z1 libc6-i386 g++-multilib python-git \
    coccinelle zstd liblz4-tool cproto && \
    # 安装第二组依赖
    apt-get install -y device-tree-compiler u-boot-tools && \
    # 清理缓存减小镜像体积
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 处理coccinelle的安装
RUN apt-get update && \
    # 卸载现有版本
    apt-get remove -y --purge libparmap-ocaml && \
    dpkg -r coccinelle || true && \
    # 克隆源码并切换版本
    git clone https://github.com/coccinelle/coccinelle.git && \
    cd coccinelle && \
    git checkout 1.1.1 && \
    # 安装autogen可能需要的依赖
    apt-get install -y automake && \
    # 编译安装
    ./autogen && \
    ./configure && \
    make && \
    make install && \
    # 清理源码和缓存
    cd .. && rm -rf coccinelle && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 处理可能的coccinelle编译错误（预安装依赖）
RUN apt-get update && \
    apt-get install -y libparmap-ocaml-dev libpcre-ocaml-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装指定版本的make
RUN wget http://launchpadlibrarian.net/366014597/make_4.1-9.1ubuntu1_amd64.deb && \
    dpkg -i make_4.1-9.1ubuntu1_amd64.deb && \
    rm make_4.1-9.1ubuntu1_amd64.deb

# 设置工作目录
WORKDIR /workspace

# 保持容器运行（可选）
CMD ["bash"]
