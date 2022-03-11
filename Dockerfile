ARG PGBOUNCER_VERSION
FROM alpine:3.15

ARG PGBOUNCER_VERSION
ENV PGBOUNCER_VERSION=$PGBOUNCER_VERSION

## Install Deps
RUN apk add --no-cache \
    curl \
    libevent-dev \
    pkgconfig \
    openssl-dev \
    linux-pam-dev \
    tar \
    gzip \
    gcc \
    binutils \
    musl-dev \
    make

RUN mkdir /build
WORKDIR /build

RUN curl -L -o pgbouncer-${PGBOUNCER_VERSION}.tar.gz "https://www.pgbouncer.org/downloads/files/${PGBOUNCER_VERSION}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz" \
        && tar xvf pgbouncer-${PGBOUNCER_VERSION}.tar.gz \
        && cd pgbouncer-${PGBOUNCER_VERSION} \
        && ./configure --prefix=/usr --with-pam \
        && make

# Make sure the default config doesn't listen on localhost with IPv6
RUN sed -i 's/listen_addr.*./listen_addr \= 127.0.0.1/g' pgbouncer-${PGBOUNCER_VERSION}/etc/pgbouncer.ini

FROM alpine:3.15

ARG PGBOUNCER_VERSION
ENV PGBOUNCER_VERSION=$PGBOUNCER_VERSION

RUN apk add --no-cache \
    libevent \
    linux-pam
RUN addgroup -S pgbouncer \
    && adduser -S pgbouncer -G pgbouncer \
    && mkdir /etc/pgbouncer \
    && mkdir /var/log/pgbouncer /var/run/pgbouncer \
    && chown pgbouncer:pgbouncer /var/log/pgbouncer /var/run/pgbouncer \
    && ln -sf /dev/null /var/log/pgbouncer/pgbouncer.log

COPY --from=0 /build/pgbouncer-${PGBOUNCER_VERSION}/pgbouncer /usr/bin/pgbouncer
COPY --from=0 /build/pgbouncer-${PGBOUNCER_VERSION}/etc/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini
COPY --from=0 /build/pgbouncer-${PGBOUNCER_VERSION}/etc/userlist.txt /etc/pgbouncer/userlist.txt

USER pgbouncer

EXPOSE 6432

CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]