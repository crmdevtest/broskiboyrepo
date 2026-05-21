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
