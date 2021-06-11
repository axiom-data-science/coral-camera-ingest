FROM aler9/rtsp-simple-server AS rtsp

FROM jrottenberg/ffmpeg:4.4-nvidia

RUN apt-get update && apt-get install -y curl inotify-tools

# Add docker compose
ENV DOCKER_COMPOSE_VERSION 1.29.1
ADD "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64" /usr/bin/docker-compose
RUN chmod +x /usr/bin/docker-compose

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

RUN mkdir -p /video/ && \
    mkdir -p /video/stream

COPY --from=rtsp /rtsp-simple-server /

COPY ./cameras /cameras

COPY ./sample /sample

COPY ./http /http

COPY ./rtsp/rtsp-simple-server.yml /rtsp-simple-server.yml

ENTRYPOINT [ "/sbin/tini", "-g", "--" ]

CMD [ "echo 'Please see documentation for specifying commands for this image.'" ]
