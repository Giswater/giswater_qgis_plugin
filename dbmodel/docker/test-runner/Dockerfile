FROM python:3.11-slim-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       postgresql-client \
       libtap-parser-sourcehandler-pgtap-perl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
