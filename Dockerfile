FROM alpine:3.16 as downloader
ARG PACPARSER_VERSION=1.4.0
USER nobody
RUN wget -P /tmp https://github.com/manugarg/pacparser/releases/download/v$PACPARSER_VERSION/pacparser-v$PACPARSER_VERSION-linux-amd64.zip && \
  unzip -d /tmp /tmp/pacparser-v$PACPARSER_VERSION-linux-amd64.zip && \
  chmod 755 /tmp/pacparser-v$PACPARSER_VERSION-linux-amd64/bin/pactester

FROM gcr.io/distroless/base-debian11:nonroot
ARG PACPARSER_VERSION=1.4.0
USER nonroot
COPY --from=downloader /tmp/pacparser-v$PACPARSER_VERSION-linux-amd64/bin/* /usr/local/bin/
COPY --from=downloader /tmp/pacparser-v$PACPARSER_VERSION-linux-amd64/lib/* /usr/local/lib/
ENTRYPOINT ["/usr/local/bin/pactester"]
