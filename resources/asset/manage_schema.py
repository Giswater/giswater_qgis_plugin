"""
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
"""
# -*- coding: utf-8 -*-

import psycopg2
import logging
from pathlib import Path


def run_sql_scripts():
    # Connection parameters
    DBNAME = "postgres"
    USER = "postgres"
    PASSWORD = "postgres"
    HOST = "localhost"
    PORT = "5432"

    # Giswater schema parameters
    PARENT_SCHEMA = "ws_40_01_local"
    SCHEMA_SRID = "25831"
    LANGUAGE = "en_US"

    required_constants = [
        DBNAME,
        USER,
        PASSWORD,
        HOST,
        PORT,
        PARENT_SCHEMA,
        SCHEMA_SRID,
        LANGUAGE,
    ]

    if not all(required_constants):
        logging.error("There are some constants that have not been defined.")
        exit()

    sql_folder = Path(__file__).parent
    files = [
        "ddl.sql",
        "tablect.sql",
        "dml.sql",
        f"i18n/{LANGUAGE}.sql",
        "sample.sql",
        "updates/2023-05/ddl.sql",
        "updates/2023-05/dcl.sql",
        "updates/2024-01/ddl.sql",
        "updates/2024-01/dml.sql",
        "updates/2024-01/gw_trg_asset_cat_mat_arc.sql",
        "updates/2024-01/gw_trg_asset_cat_mat_arc.sql",
        f"updates/2024-01/i18n/{LANGUAGE}.sql",
    ]

    try:
        with psycopg2.connect(
            dbname=DBNAME, user=USER, password=PASSWORD, host=HOST, port=PORT
        ) as conn, conn.cursor() as cur:
            for file in files:
                with open(sql_folder / file, encoding="utf8") as f:
                    sql = f.read()
                    sql = sql.replace("PARENT_SCHEMA", PARENT_SCHEMA)
                    sql = sql.replace("SCHEMA_SRID", SCHEMA_SRID)
                cur.execute(sql)
            conn.commit()
            logging.info("Success!")
    except Exception as e:
        logging.error(e)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    run_sql_scripts()
