"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import psycopg2
from psycopg2.extensions import connection
from typing import Optional, Any, List, Dict
from custom_logger import logger


def connect_to_db(password: str = 'postgres', port: int = 55432) -> connection:
    """
    Connects to the PostgreSQL database using provided credentials.

    :param password: The password for the PostgreSQL user.
    :param port: The port for the PostgreSQL connection.
    :return: A connection object to the PostgreSQL database.
    """
    db_params = {
        'dbname': 'gw_db',
        'user': 'postgres',
        'password': password,
        'host': 'localhost',
        'port': port
    }

    conn = psycopg2.connect(**db_params)
    return conn


def execute_sql_file(conn: connection, file_path: str) -> None:
    """
    Executes the SQL commands contained in the specified file.

    :param conn: The PostgreSQL connection object.
    :param file_path: The path to the SQL file.
    """
    with open(file_path, 'r') as file:
        sql_content = file.read()

    with conn.cursor() as cur:
        try:
            cur.execute(sql_content)
            conn.commit()
            logger.success(f"Executed {file_path} successfully.")
        except Exception as e:
            conn.rollback()
            logger.error(f"Error executing {file_path}: {e}")
            raise


def execute_query(conn: connection, query: str) -> Optional[Any]:
    """
    Executes a SQL query and returns the first result.

    :param conn: The PostgreSQL connection object.
    :param query: The SQL query to execute.
    :return: The first result of the query, or None if there was an error.
    """
    try:
        with conn.cursor() as cur:
            cur.execute(query)
            result = cur.fetchone()
            return result[0] if result else None
    except Exception as error:
        logger.error(f"Error executing query: {error}")
        return None


def table_exists(conn: connection, schema_name: str, table_name: str) -> bool:
    """
    Checks if a table exists in the database.

    :param conn: The PostgreSQL connection object.
    :param table_name: The name of the table to check.
    :return: True if the table exists, False otherwise.
    """
    query = """
    SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = %s
        AND table_name = %s
    );
    """
    try:
        with conn.cursor() as cur:
            cur.execute(query, (schema_name, table_name,))
            exists = cur.fetchone()[0]
            return exists
    except Exception as error:
        logger.error(f"Error checking if table {table_name} exists: {error}")
        return False


def fetch_all_rows(conn: connection, query: str) -> Optional[List[Dict[str, Any]]]:
    """
    Executes a query and returns all rows as a list of dictionaries.

    :param conn: The PostgreSQL connection object.
    :param query: The SQL query to execute.
    :return: A list of dictionaries representing the rows, or None if there was an error.
    """
    try:
        with conn.cursor() as cur:
            cur.execute(query)
            rows = cur.fetchall()
            columns = [desc[0] for desc in cur.description]
            result = [dict(zip(columns, row)) for row in rows]
            return result
    except Exception as error:
        logger.error(f"Error fetching rows: {error}")
        return None
