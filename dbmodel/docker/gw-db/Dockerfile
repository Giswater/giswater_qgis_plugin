ARG PG_MAJOR=16
ARG POSTGIS_VERSION=3.4
FROM postgis/postgis:${PG_MAJOR}-${POSTGIS_VERSION}

ARG GW_DUMP=gw_ws.dump
COPY ${GW_DUMP} /docker-entrypoint-initdb.d/10-gw_ws.dump
COPY docker/gw-db/restore.sh /docker-entrypoint-initdb.d/20-restore.sh
