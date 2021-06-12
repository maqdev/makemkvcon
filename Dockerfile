FROM ubuntu:21.10

WORKDIR /root

RUN apt update -y
RUN DEBIAN_FRONTEND="noninteractive" TZ="Europe/Luxembourg" apt install -y build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev wget unzip less

RUN wget http://www.makemkv.com/download/makemkv-bin-1.16.3.tar.gz
RUN wget http://www.makemkv.com/download/makemkv-oss-1.16.3.tar.gz

RUN tar xvf makemkv-bin-1.16.3.tar.gz
RUN tar xvf makemkv-oss-1.16.3.tar.gz

WORKDIR /root/makemkv-oss-1.16.3
RUN ./configure 
RUN make 
RUN make install

WORKDIR /root/makemkv-bin-1.16.3
RUN echo 'yes' | make
RUN make install

FROM ubuntu:21.10

RUN apt update -y
RUN DEBIAN_FRONTEND="noninteractive" TZ="Europe/Luxembourg" apt install -y ffmpeg

WORKDIR /tmp
RUN mkdir -p /tmp/out && mkdir -p /tmp/out/bin && mkdir -p /usr/share/MakeMKV
COPY --from=0 /root/makemkv-oss-1.16.3/out /tmp/out/
COPY --from=0 /root/makemkv-bin-1.16.3/bin /tmp/out/bin/
COPY --from=0 /usr/share/MakeMKV /usr/share/MakeMKV

RUN /usr/bin/install -D -m 644 out/libdriveio.so.0 /usr/lib/libdriveio.so.0
RUN /usr/bin/install -D -m 644 out/libmakemkv.so.1 /usr/lib/libmakemkv.so.1
RUN /usr/bin/install -D -m 644 out/libmmbd.so.0 /usr/lib/libmmbd.so.0
RUN /usr/bin/install -D -m 755 out/mmccextr /usr/bin/mmccextr
RUN /usr/bin/install -t /usr/bin out/bin/amd64/makemkvcon
RUN cd /usr/bin && ln -s -f makemkvcon sdftool

RUN useradd -rm -d /home/appuser -s /bin/bash -u 1001 appuser
USER appuser
WORKDIR /home/appuser
ENTRYPOINT ["/usr/bin/makemkvcon"]
CMD ["info", "file:/data/VIDEO_TS"]
