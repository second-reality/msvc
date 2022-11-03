FROM arm64v8/debian:bullseye

RUN echo "deb-src http://deb.debian.org/debian/ bullseye main" >> /etc/apt/sources.list

RUN apt update && apt build-dep -y wine
# needs make, clang, dlltool (from llvm) and lld
# it seems to be broken with vanilla clang for now (hangs on first wineboot)
# llvm-mingw is fine!
# TODO: investigate
#RUN apt update && apt install -y clang build-essential llvm lld

RUN apt update && apt install -y wget unzip

RUN cd /tmp && wget -q https://github.com/mstorsjo/llvm-mingw/releases/download/20220906/llvm-mingw-20220906-ucrt-ubuntu-18.04-aarch64.tar.xz && tar xvf *xz && rm *.xz
ENV PATH=/tmp/llvm-mingw-20220906-ucrt-ubuntu-18.04-aarch64/bin:$PATH

RUN which clang

ENV WINE_VERSION=7.20
RUN cd /tmp && echo "Download wine-${WINE_VERSION}..." && \
    wget -q https://github.com/wine-mirror/wine/archive/refs/tags/wine-${WINE_VERSION}.tar.gz && \
    tar xf wine-${WINE_VERSION}.tar.gz && cd wine-wine-${WINE_VERSION} && \
    CC=clang ./configure --with-mingw --prefix=/usr/ && \
    make -j$(nproc) &&\
    make -j$(nproc) install &&\
    rm -rf /tmp/*

ENV WINEPREFIX=/opt/wine/
ENV WINEPATH=
RUN apt update && apt install -y procps
# Initialize the wine environment. Wait until the wineserver process has
# exited before closing the session, to avoid corrupting the wine prefix.
RUN wine wineboot --init && echo lol &&\
    while pgrep wineserver > /dev/null; do sleep 1; done
RUN cp -r ${WINEPREFIX}/drive_c/windows/system32/ ${WINEPREFIX}/drive_c/windows/syswow64/
ENV WINEDEBUG=-all

RUN apt update && apt install -y git python3 python3-pip
RUN apt update && apt install -y msitools python3-simplejson python3-six ca-certificates winbind

RUN cd /tmp && \
git clone https://github.com/mstorsjo/msvc-wine &&\
cd msvc-wine &&\
python3 ./vsdownload.py --accept-license --dest ${WINEPREFIX}/drive_c/vs/ &&\
./install.sh ${WINEPREFIX}/drive_c/vs/ &&\
rm -rf /tmp/*

# allow anyone to write in temp and users directory
RUN chmod 777 -R ${WINEPREFIX}/drive_c/users ${WINEPREFIX}/drive_c/windows/temp

RUN apt update && apt install -y unzip
RUN cd ${WINEPREFIX}/drive_c/ && mkdir python && cd python &&\
wget -q https://www.nuget.org/api/v2/package/pythonarm64/3.10.8 -O p.zip &&\
unzip p.zip
ENV WINEPATH=C:/python/tools;${WINEPATH}
RUN wine python --version
RUN wine python -c 'print("hello world")'

# check it works
RUN wine cmd /c "echo Hello World! ($(wine --version))"

ADD vs_prompt.sh /usr/bin

RUN apt update && apt install -y strace

RUN cd ${WINEPREFIX}/drive_c && mkdir llvm && cd llvm &&\
wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/LLVM-14.0.6-woa64.zip &&\
unzip *zip && rm *zip && rm bin/ucrtbase.dll # bad dll: is x86_64
ENV WINEPATH=C:/llvm/bin;${WINEPATH}
RUN wine C:/llvm/bin/clang.exe --version

RUN cd ${WINEPREFIX}/drive_c/ && mkdir cmake && cd cmake && \
wget -q https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2-windows-arm64.zip &&\
unzip *.zip && mv cmake*/* . && rm *.zip
ENV WINEPATH=C:/cmake/bin;${WINEPATH}
RUN wine cmake --version

RUN cd ${WINEPREFIX}/drive_c/ && mkdir ninja && cd ninja && \
wget -q https://woastorage.blob.core.windows.net/packages/ninja/ninja_v1.11.1.zip &&\
unzip *zip && rm *zip
ENV WINEPATH=C:/ninja/;${WINEPATH}
RUN wine ninja.exe --version
