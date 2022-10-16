FROM debian:bullseye

RUN apt update && apt install -y git python3 python3-pip
RUN apt update && apt install -y msitools python3-simplejson python3-six ca-certificates winbind
RUN cd /tmp && \
git clone https://github.com/mstorsjo/msvc-wine &&\
cd msvc-wine &&\
python3 ./vsdownload.py --accept-license --dest /opt/msvc/ &&\
./install.sh /opt/msvc &&\
rm -rf /tmp/*
RUN dpkg --add-architecture i386
RUN apt update && apt install -y gnupg2 software-properties-common wget
RUN apt-add-repository https://dl.winehq.org/wine-builds/debian/
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key -O - | apt-key add -
RUN apt update && apt install -y --install-recommends winehq-stable
RUN apt update && apt install -y procps # pgrep
ENV WINEPREFIX=/opt/wine/
# Initialize the wine environment. Wait until the wineserver process has
# exited before closing the session, to avoid corrupting the wine prefix.
RUN wine64 wineboot --init && \
    while pgrep wineserver > /dev/null; do sleep 1; done

RUN wine64 cmd /c "echo hello"
RUN apt update && apt install -y wget unzip
RUN cd ${WINEPREFIX}/drive_c/ && mkdir cmake && cd cmake && \
wget -q https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2-windows-x86_64.zip &&\
unzip *.zip && mv cmake*/* . && rm *.zip
RUN cd ${WINEPREFIX}/drive_c/ && mkdir python && cd python &&\
wget -q https://www.nuget.org/api/v2/package/python/3.8.0 -O p.zip &&\
unzip p.zip
ENV WINEPATH=C:/cmake/bin;C:/python/tools/;C:/windows/system32;C:/windows;C:/windows/system32/wbem;C:/windows/system32/WindowsPowershell/v1.0
ENV WINEDEBUG=-all
RUN wine --version
RUN wine64 cmake --version
RUN wine64 python -c 'print("hello world")'
RUN chmod 777 -Rv /opt/wine
