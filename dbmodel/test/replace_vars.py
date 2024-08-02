import os

def replace_vars_in_file(file_path, replacements):
    with open(file_path, 'r') as file:
        content = file.read()
    for old, new in replacements.items():
        content = content.replace(old, new)
    with open(file_path, 'w') as file:
        file.write(content)

def main():
    sql_dir = './'
    replacements = {
        'SCHEMA_NAME': 'ws_36',
        'SRID_VALUE': '25831',
        # Add more replacements as needed
    }
    for root, dirs, files in os.walk(sql_dir):
        for file in files:
            if file.endswith('.sql'):
                replace_vars_in_file(os.path.join(root, file), replacements)

if __name__ == "__main__":
    main()
