FROM debian:bullseye

RUN apt update && apt install -y git python3 python3-pip
RUN apt update && apt install -y msitools python3-simplejson python3-six ca-certificates winbind
RUN dpkg --add-architecture i386
RUN apt update && apt install -y gnupg2 software-properties-common wget
RUN apt-add-repository https://dl.winehq.org/wine-builds/debian/
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key -O - | apt-key add -
RUN apt update && apt install -y --install-recommends winehq-stable
RUN apt update && apt install -y procps # pgrep
RUN apt update && apt install -y strace # for debugging
ENV WINEPREFIX=/opt/wine/
# Initialize the wine environment. Wait until the wineserver process has
# exited before closing the session, to avoid corrupting the wine prefix.
RUN wine64 wineboot --init && \
    while pgrep wineserver > /dev/null; do sleep 1; done
RUN wine --version
ENV WINEDEBUG=-all
ENV WINEPATH=

RUN apt update && apt install -y wget unzip
RUN cd ${WINEPREFIX}/drive_c/ && mkdir cmake && cd cmake && \
wget -q https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2-windows-x86_64.zip &&\
unzip *.zip && mv cmake*/* . && rm *.zip
ENV WINEPATH=C:/cmake/bin;${WINEPATH}
RUN wine cmake --version

RUN cd ${WINEPREFIX}/drive_c/ && mkdir python && cd python &&\
wget -q https://www.nuget.org/api/v2/package/python/3.8.0 -O p.zip &&\
unzip p.zip
ENV WINEPATH=C:/python/tools;${WINEPATH}
RUN wine python --version
RUN wine python -c 'print("hello world")'

RUN cd ${WINEPREFIX}/drive_c/ && mkdir ninja && cd ninja && \
wget -q https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-win.zip &&\
unzip ninja-win.zip && rm *.zip
ENV WINEPATH=C:/ninja;${WINEPATH}
RUN wine ninja --version

RUN cd /tmp && \
git clone https://github.com/mstorsjo/msvc-wine &&\
cd msvc-wine &&\
python3 ./vsdownload.py --accept-license --dest ${WINEPREFIX}/drive_c/vs/ &&\
./install.sh ${WINEPREFIX}/drive_c/vs/ &&\
rm -rf /tmp/*

# allow anyone to write in temp and users directory
RUN chmod 777 -R ${WINEPREFIX}/drive_c/users ${WINEPREFIX}/drive_c/windows/temp
ADD vs_prompt.sh /usr/bin
