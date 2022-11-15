import numpy as np
import sys

def print_array(A):
    for i in A:
        if (len(A.shape) > 1):
            for j in i:
                print("{:x}".format(j & 0xffff), end=" ")
            print()
        else:
            print("{:x}".format(i & 0xffff), end=" ")

# Пересохранение в hex формате
def read_save(name, transpose):
    f = open(name + "_full.txt", "r")
    a = np.array([line.split() for line in f], dtype=np.float64)
    a = a.astype(np.int16)

    old_stdout = sys.stdout
    with open(name + "_hex.txt", "w") as sys.stdout:
        if (transpose):
            print_array(a.T)
        else:
            print_array(a)
    sys.stdout = old_stdout

read_save("weight", True)
read_save("bias", False)