FROM arm64v8/debian:bullseye

RUN echo "deb-src http://deb.debian.org/debian/ bullseye main" >> /etc/apt/sources.list

RUN apt update && apt build-dep -y wine
# needs make, clang, dlltool (from llvm) and lld
RUN apt update && apt install -y clang build-essential llvm lld

RUN apt update && apt install -y wget

ENV WINE_VERSION=7.7
RUN cd /tmp && echo "Download wine-${WINE_VERSION}..." && \
    wget -q https://github.com/wine-mirror/wine/archive/refs/tags/wine-${WINE_VERSION}.tar.gz && \
    tar xf wine-${WINE_VERSION}.tar.gz && cd wine-wine-${WINE_VERSION} && \
    ./configure --prefix=/usr/ && \
    make -j$(nproc) &&\
    make -j$(nproc) install &&\
    rm -rf /tmp/*

# Initialize the wine environment. Wait until the wineserver process has
# exited before closing the session, to avoid corrupting the wine prefix.
RUN wine wineboot --init && \
    while pgrep wineserver > /dev/null; do sleep 1; done

# check it works
RUN wine cmd /c "echo Hello World! ($(wine --version))"
