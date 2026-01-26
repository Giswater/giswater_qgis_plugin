ARG PG_MAJOR=16
ARG POSTGIS_VERSION=3.4
FROM postgis/postgis:${PG_MAJOR}-${POSTGIS_VERSION}

ARG GW_DUMP=gw_ws.dump
ARG GW_GLOBALS=gw_ws.globals.sql
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       postgresql-${PG_MAJOR}-pgrouting \
       postgresql-${PG_MAJOR}-pgtap \
    && rm -rf /var/lib/apt/lists/*
COPY ${GW_GLOBALS} /docker-entrypoint-initdb.d/00-gw_globals.sql
COPY ${GW_DUMP} /docker-entrypoint-initdb.d/10-gw_ws.dump
COPY docker/gw-db/restore.sh /docker-entrypoint-initdb.d/20-restore.sh
