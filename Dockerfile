FROM minio/minio

LABEL maintainer "joshua.foster@stfc.ac.uk"

RUN apk --no-cache add shadow su-exec

ENV MINIO_USER datalab
ENV MINIO_UID 1000

RUN adduser -D -s /bin/sh -u $MINIO_UID -S $MINIO_USER

COPY start.sh /usr/bin/

RUN chmod +x /usr/bin/start.sh

ENTRYPOINT ["/usr/bin/start.sh"]

USER $MINIO_USER
