import os
import argparse
import psycopg2


def execute_sql_file(conn, file_path):
    with open(file_path, 'r') as file:
        sql_content = file.read()
    with conn.cursor() as cursor:
        try:
            cursor.execute(sql_content)
            conn.commit()
            print(f"Executed {file_path} successfully.")
        except Exception as e:
            conn.rollback()
            print(f"Error executing {file_path}: {e}")
            raise


def connect_to_db():
    # Database connection parameters
    db_params = {
        'dbname': 'giswater_test_db',
        'user': 'postgres',
        'password': os.getenv('PGPASSWORD', 'postgres'),
        'host': 'localhost',
        'port': 5432
    }

    # Connect to the PostgreSQL database
    conn = psycopg2.connect(**db_params)
    return conn


def main(project_type):
    print(f"Project type: {project_type}")
    
    conn = connect_to_db()

    # Define the root directories to process
    root_directories = ["utils", f"{project_type}", "i18n/en_US"]
    exclude_prefix = "ud_" if project_type == "ws" else "ws_"

    # Execute SQL files in the root directories
    for root_dir in root_directories:
        print(f"Processing root directory: {root_dir}")
        for root, _, files in os.walk(root_dir):
            for file in sorted(files):
                if file.endswith(".sql") and exclude_prefix not in file:
                    file_path = os.path.join(root, file)
                    execute_sql_file(conn, file_path)

    # Define the base updates directory
    updates_dir = "updates/36"

    # Check if the updates directory exists and process it
    if os.path.isdir(updates_dir):
        for root, _, files in os.walk(updates_dir):
            for file in sorted(files):
                if file.endswith(".sql") and exclude_prefix not in file:
                    file_path = os.path.join(root, file)
                    execute_sql_file(conn, file_path)
    else:
        print(f"Directory {updates_dir} does not exist")

    # Execute child views
    execute_sql_file(conn, f"childviews/en_US/{project_type}_schema_model.sql")

    # Execute last process command
    with conn.cursor() as cursor:
        lastprocess_command = f"""
            SELECT {project_type}_36.gw_fct_admin_schema_lastprocess(
                '{{"client":{{"device":4, "lang":"en_US"}}, "data":{{"isNewProject":"TRUE", "gwVersion":"3.6.012", "projectType":"{project_type.upper()}", "epsg":25831, "descript":"{project_type}_36", "name":"{project_type}_36", "author":"postgres", "date":"29-07-2024"}}}}'
            );
        """
        cursor.execute(lastprocess_command)
        conn.commit()

    # Define the example directory
    example_dir = f"example/user/{project_type}"

    # Check if the example directory exists and process it
    if os.path.isdir(example_dir):
        for root, _, files in os.walk(example_dir):
            for file in sorted(files):
                if file.endswith(".sql") and exclude_prefix not in file:
                    file_path = os.path.join(root, file)
                    execute_sql_file(conn, file_path)
    else:
        print(f"Directory {example_dir} does not exist")

    # Close the database connection
    conn.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Execute SQL files of a certain project type.')
    parser.add_argument('project_type', type=str, help='Project type. Must be "ws" or "ud"')
    args = parser.parse_args()
    main(args.project_type)
