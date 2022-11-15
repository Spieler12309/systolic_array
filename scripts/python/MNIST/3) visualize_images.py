import matplotlib.pyplot as plt
import numpy as np

f = open("images.hex", "r")
X = [line.split() for line in f]

to_hex = lambda x: int(x, 16)
applyall = np.vectorize(to_hex)
X = applyall(X)

X = X.astype(np.int8)
print(X.shape)

print(X)
fig = plt.figure()
axes = fig.subplots(nrows=2, ncols=5)
axes[0, 0].imshow(X[0].reshape((28, 28)), cmap='gray')
axes[0, 1].imshow(X[1].reshape((28, 28)), cmap='gray')
axes[0, 2].imshow(X[2].reshape((28, 28)), cmap='gray')
axes[0, 3].imshow(X[3].reshape((28, 28)), cmap='gray')
axes[0, 4].imshow(X[4].reshape((28, 28)), cmap='gray')
axes[1, 0].imshow(X[5].reshape((28, 28)), cmap='gray')
axes[1, 1].imshow(X[6].reshape((28, 28)), cmap='gray')
axes[1, 2].imshow(X[7].reshape((28, 28)), cmap='gray')
axes[1, 3].imshow(X[8].reshape((28, 28)), cmap='gray')
axes[1, 4].imshow(X[9].reshape((28, 28)), cmap='gray')

plt.show()