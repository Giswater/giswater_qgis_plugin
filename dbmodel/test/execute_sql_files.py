"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import argparse
from datetime import datetime
from utils import connect_to_db, execute_sql_file
from custom_logger import logger


def main(project_type: str) -> None:
    logger.info(f"Project type: {project_type}")

    conn = connect_to_db(os.getenv('PGPASSWORD', 'postgres'), int(os.getenv('PORT', 55432)))

    network = "schemas/network"
    root_directories = [
        f"{network}/common/ddl",
        f"{network}/{project_type}/schema_model",
        f"{network}/common/fct",
        f"{network}/common/ftrg",
        f"{network}/{project_type}/fct",
        f"{network}/{project_type}/ftrg",
    ]
    exclude_prefix = "ud_" if project_type == "ws" else "ws_"
    exculude_files = "07_trg_schema_model.sql"

    for root_dir in root_directories:
        logger.info(f"Processing root directory: {root_dir}")
        for root, _, files in os.walk(root_dir):
            for file in sorted(files):
                if file.endswith(".sql") and not file.startswith(exclude_prefix) and exculude_files not in file:
                    file_path = os.path.join(root, file)
                    execute_sql_file(conn, file_path)

    execute_sql_file(conn, f"{network}/{project_type}/schema_model/07_trg_schema_model.sql")

    # Updates: split into network/common/updates + network/<project_type>/updates.
    # Walk both, union versions, apply common-then-kind per version.
    update_roots = [
        ("common", f"{network}/common/updates"),
        (project_type, f"{network}/{project_type}/updates"),
    ]
    v_major, v_minor, v_patch = 4, 0, 0
    versions: dict[tuple[int, int, int], dict[str, str]] = {}
    for label, root_dir in update_roots:
        if not os.path.isdir(root_dir):
            logger.warning(f"Directory {root_dir} does not exist")
            continue
        for root, dirs, files in os.walk(root_dir):
            rel_path = os.path.relpath(root, root_dir)
            parts = rel_path.split(os.sep)
            if len(parts) == 3 and all(p.isdigit() for p in parts):
                key = (int(parts[0]), int(parts[1]), int(parts[2]))
                versions.setdefault(key, {})[label] = root

    for (major, minor, patch) in sorted(versions.keys()):
        logger.info(f"Processing update version: {major}.{minor}.{patch}")
        for label in ("common", project_type):
            sub_path = versions[(major, minor, patch)].get(label)
            if sub_path and os.path.isdir(sub_path):
                logger.info(f"Processing subdirectory: {sub_path}")
                for file in sorted(os.listdir(sub_path)):
                    if file.endswith(".sql"):
                        file_path = os.path.join(sub_path, file)
                        logger.info(f"Executing SQL file: {file_path}")
                        execute_sql_file(conn, file_path)
                        v_major, v_minor, v_patch = major, minor, patch


    logger.info(f"PERFORM lastprocess:")
    current_date = datetime.now().strftime("%d-%m-%Y")
    # Execute last process command
    with conn.cursor() as cursor:
        lastprocess_command = f"""
            SELECT {project_type}_40.gw_fct_admin_schema_lastprocess(
                '{{"client":{{"device":4, "lang":"en_US"}}, "data":{{"isNewProject":"TRUE", "gwVersion":"{v_major}.{v_minor}.{v_patch}", "projectType":"{project_type.upper()}", "epsg":25831, "descript":"{project_type}_40", "name":"{project_type}_40", "author":"postgres", "date":"{current_date}"}}}}'
            );
        """
        cursor.execute(lastprocess_command)
        conn.commit()

    example_dir = f"{network}/sample/user/{project_type}"

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

    final_pass_dir = f"{network}/{project_type}/final_pass/config_form_fields"
    final_pass_i18n_dir = f"{network}/{project_type}/final_pass/i18n/en_US"

    # Check if the final pass directory exists and process it
    if os.path.isdir(final_pass_dir):
        logger.info(f"Processing root directory: {final_pass_dir}")
        for root, _, files in os.walk(final_pass_dir):
            for file in sorted(files):
                if file.endswith(".sql") and exclude_prefix not in file:
                    file_path = os.path.join(root, file)
                    execute_sql_file(conn, file_path)
    else:
        logger.warning(f"Directory {final_pass_dir} does not exist")

    # Check if the final pass i18n directory exists and process it
    if os.path.isdir(final_pass_i18n_dir):
        logger.info(f"Processing root directory: {final_pass_i18n_dir}")
        for root, _, files in os.walk(final_pass_i18n_dir):
            for file in sorted(files):
                if file.endswith(".sql") and exclude_prefix not in file:
                    file_path = os.path.join(root, file)
                    execute_sql_file(conn, file_path)
    else:
        logger.warning(f"Directory {final_pass_i18n_dir} does not exist")

    # Close the database connection
    conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Execute SQL files of a certain project type.')
    parser.add_argument('project_type', type=str, help='Project type. Must be "ws" or "ud"')
    args = parser.parse_args()
    main(args.project_type)
