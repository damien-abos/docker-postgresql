# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:edge

ARG date=""
ARG revision=""
ARG version="HEAD"
ARG whoami="damien-abos"


LABEL build_version="${whoami} version:- ${version} Build-date:- ${date}"
LABEL maintainer="${whoami}"

LABEL org.opencontainers.image.authors="${whoami}"
LABEL org.opencontainers.image.created="${date}"
LABEL org.opencontainers.image.description="PostgreSQL using LinuxServer.io"
LABEL org.opencontainers.image.documentation="https://docs.linuxserver.io/images/docker-baseimage-alpine"
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.ref.name="${revision}"
LABEL org.opencontainers.image.revision="${revision}"
LABEL org.opencontainers.image.source="https://github.com/damien-abos/docker-postgresql"
LABEL org.opencontainers.image.title="postgresql"
LABEL org.opencontainers.image.url="https://github.com/damien-abos/docker-postgresql/packages"
LABEL org.opencontainers.image.vendor="${whoami}"
LABEL org.opencontainers.image.version="${version}"

ENV POSTGRESQL_VOLUME_DIR=/config/postgresql
ENV POSTGRESQL_DATA_DIR=${POSTGRESQL_VOLUME_DIR}/data
ENV POSTGRESQL_EXTRA_FLAGS=
ENV POSTGRESQL_DATABASE=postgres
ENV POSTGRESQL_INITDB_ARGS=
ENV POSTGRESQL_PORT_NUMBER=5432
ENV POSTGRESQL_USERNAME=postgres
ENV POSTGRESQL_INITSCRIPTS_USERNAME=${POSTGRESQL_USERNAME}
ENV POSTGRESQL_PASSWORD=
ENV POSTGRESQL_INITSCRIPTS_PASSWORD=${POSTGRESQL_PASSWORD}
ENV PGDATA=${POSTGRESQL_DATA_DIR}

RUN \ 
  echo "**** install runtime packages ****" && \
  apk add -U --upgrade --no-cache \
    postgresql17 \
    postgresql17-jit && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE ${POSTGRESQL_PORT_NUMBER}
VOLUME [ "/config" ]