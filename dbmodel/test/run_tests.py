"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import argparse
from utils import connect_to_db, execute_sql_file
from custom_logger import logger


def main(project_type: str, test_type: str) -> None:
    logger.info(f"Project type: {project_type}")

    conn = connect_to_db(os.getenv('PGPASSWORD', 'postgres'))

    # Construct the root directory based on the project_type and test_type
    root_directory = os.path.join("test", test_type, project_type)

    # Execute SQL files in the root directory
    if os.path.exists(root_directory):
        logger.info(f"Processing root directory: {root_directory}")
        for root, _, files in os.walk(root_directory):
            for file in sorted(files):
                if file.endswith(".sql"):
                    file_path = os.path.join(root, file)
                    logger.info(f"Executing SQL file: {file_path}")
                    execute_sql_file(conn, file_path)
    else:
        logger.error(f"Directory {root_directory} does not exist.")


    # Close the database connection
    conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Execute SQL files of a certain project and test type.')
    parser.add_argument('project_type', type=str, help='Project type. Must be "ws" or "ud"')
    parser.add_argument('test_type', type=str, help='Test type. Must be "plsql" or "upsert"')
    args = parser.parse_args()
    main(args.project_type, args.test_type)
