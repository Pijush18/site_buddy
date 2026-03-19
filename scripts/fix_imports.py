import os
import re

def convert_to_package_import(file_path, base_dir, package_name):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex to find relative imports: import '...'; or import "...";
    # We look for imports starting with . or ..
    import_pattern = re.compile(r"import\s+(['\"])(?P<path>\.\.?/.*?)\1")

    def replace_match(match):
        relative_path = match.group('path')
        quote = match.group(1)
        
        # Calculate the absolute path of the imported file
        file_dir = os.path.dirname(file_path)
        abs_imported_path = os.path.normpath(os.path.join(file_dir, relative_path))
        
        # Convert to package path
        # Expected lib structure: lib/...
        if 'lib' in abs_imported_path:
            # Find the part after 'lib'
            parts = abs_imported_path.split(os.sep)
            try:
                lib_index = parts.index('lib')
                package_relative = '/'.join(parts[lib_index + 1:])
                return f"import {quote}package:{package_name}/{package_relative}{quote}"
            except ValueError:
                return match.group(0) # Fallback if something is weird
        
        return match.group(0)

    new_content = import_pattern.sub(replace_match, content)

    if new_content != content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

def main():
    base_dir = r"d:\Development\site_buddy\lib"
    package_name = "site_buddy"
    
    modified_count = 0
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                if convert_to_package_import(file_path, base_dir, package_name):
                    modified_count += 1
                    print(f"Modified: {file_path}")

    print(f"\nTotal files modified: {modified_count}")

if __name__ == "__main__":
    main()
