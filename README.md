## docker-pgbouncer

Bundles [pgbouncer](https://www.pgbouncer.org) into a lightweight Alpine Linux container

## Build
```
docker build --build-arg PGBOUNCER_VERSION=<version> --no-cache -t pgbouncer:<version> .
```

## Run
```
docker run --name pgbouncer -d -v $(pwd)/pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini pgbouncer:<version>
```

## Configure
To configure pgbouncer, copy `/etc/pgbouncer/pgbouncer.ini` from inside the 