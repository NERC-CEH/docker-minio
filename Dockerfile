FROM minio/minio:RELEASE.2021-04-27T23-46-03Z.release.0033eb96

LABEL maintainer="joshua.foster@stfc.ac.uk"

RUN apk --no-cache add shadow su-exec

ENV MINIO_USER datalab
ENV MINIO_UID 1000

RUN adduser -D -s /bin/sh -u $MINIO_UID -S $MINIO_USER

COPY start.sh /usr/bin/

RUN chmod +x /usr/bin/start.sh

ENTRYPOINT ["/usr/bin/start.sh"]

USER $MINIO_USER
