"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import argparse
from utils import connect_to_db, execute_sql_file
from custom_logger import logger


def main(project_type: str) -> None:
    logger.info(f"Project type: {project_type}")

    conn = connect_to_db(os.getenv('PGPASSWORD', 'postgres'), int(os.getenv('PORT', 55432)))

    # Define the root directories to process
    root_directories = ["utils/ddl", f"{project_type}/schema_model", "utils/fct", "utils/ftrg", f"{project_type}/fct", f"{project_type}/ftrg"]
    exclude_prefix = "ud_" if project_type == "ws" else "ws_"
    exculude_files = "trg_schema_model.sql"

    # Execute SQL files in the root directories
    for root_dir in root_directories:
        logger.info(f"Processing root directory: {root_dir}")
        for root, _, files in os.walk(root_dir):
            for file in sorted(files):
                if file.endswith(".sql") and not file.startswith(exclude_prefix) and exculude_files not in file:
                    file_path = os.path.join(root, file)
                    execute_sql_file(conn, file_path)

    # Execute the trg_schema_model.sql file after the utils/ftrg and ws/ftrg directories
    execute_sql_file(conn, f"{project_type}/schema_model/trg_schema_model.sql")

    i18n_dir = f"i18n/en_US"

    # Check if the i18n directory exists and process it
    if os.path.isdir(i18n_dir):
        logger.info(f"Processing root directory: {i18n_dir}")
        for root, _, files in os.walk(i18n_dir):
            for file in sorted(files, reverse=True):
                if file.endswith(".sql") and exclude_prefix not in file:
                    file_path = os.path.join(root, file)
                    execute_sql_file(conn, file_path)
    else:
        logger.warning(f"Directory {i18n_dir} does not exist")

    # Define the base updates directory
    updates_dir = ["updates/36", "updates/40"]

    order = ['utils', f"{project_type}"]

    for update_dir in updates_dir:
        logger.info(f"Processing update directory: {update_dir}")
        for subdir in sorted(os.listdir(update_dir)):
            subdir_path = os.path.join(update_dir, subdir)
            # Check if the updates subdirectory exists and process it
            if os.path.isdir(subdir_path):
                for root, dirs, files in os.walk(subdir_path):
                    dirs[:] = sorted([d for d in dirs if d in order], key=lambda x: order.index(x))
                    for file in sorted(files):
                        if file.endswith(".sql"):
                            file_path = os.path.join(root, file)
                            execute_sql_file(conn, file_path)

    logger.info(f"PERFORM lastprocess:")
    # Execute last process command
    with conn.cursor() as cursor:
        lastprocess_command = f"""
            SELECT {project_type}_40.gw_fct_admin_schema_lastprocess(
                '{{"client":{{"device":4, "lang":"en_US"}}, "data":{{"isNewProject":"TRUE", "gwVersion":"3.6.012", "projectType":"{project_type.upper()}", "epsg":25831, "descript":"{project_type}_36", "name":"{project_type}_36", "author":"postgres", "date":"29-07-2024"}}}}'
            );
        """
        cursor.execute(lastprocess_command)
        conn.commit()

    # Define the example directory
    example_dir = f"example/user/{project_type}"

    # Check if the example directory exists and process it
    if os.path.isdir(example_dir):
        logger.info(f"Processing root directory: {example_dir}")
        for root, _, files in os.walk(example_dir):
            for file in sorted(files):
                if file.endswith(".sql") and exclude_prefix not in file:
                    file_path = os.path.join(root, file)
                    execute_sql_file(conn, file_path)
    else:
        logger.warning(f"Directory {example_dir} does not exist")

    # Close the database connection
    conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Execute SQL files of a certain project type.')
    parser.add_argument('project_type', type=str, help='Project type. Must be "ws" or "ud"')
    args = parser.parse_args()
    main(args.project_type)
