import os
import sys


def replace_vars_in_file(file_path: str, replacements: dict) -> None:
    with open(file_path, 'r') as file:
        content = file.read()
    for old, new in replacements.items():
        content = content.replace(old, new)
    with open(file_path, 'w') as file:
        file.write(content)


def main(project_type: str):
    sql_dir = './'
    replacements = {
        'SCHEMA_NAME': f'{project_type}_40',
        'SRID_VALUE': '25831',
        # Add more replacements as needed
    }
    for root, dirs, files in os.walk(sql_dir):
        for file in files:
            if file.endswith('.sql'):
                replace_vars_in_file(os.path.join(root, file), replacements)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python replace_vars.py <project_type>")
        sys.exit(1)

    project_type = sys.argv[1]
    main(project_type)
