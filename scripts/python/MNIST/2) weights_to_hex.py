import numpy as np
import sys

data_width = 64

def print_array(A):
    for i in A:
        if (len(A.shape) > 1):
            for j in i:
                print(hex(j & 0xff)[2:].zfill(16), end=" ")
            print()
        else:
            print(hex(i & 0xff)[2:].zfill(16), end=" ")

# Пересохранение в hex формате
def read_save(name, transpose):
    f = open(name + "_full.txt", "r")
    a = np.array([line.split() for line in f], dtype=np.float64)
    #print(np.amax(a))
    #a = a*(2**(data_width-1))/14600
    #print(np.amax(a))
    a = a.astype(np.int64)

    old_stdout = sys.stdout
    with open(name + ".hex.", "w") as sys.stdout:
        if (transpose):
            print_array(a.T)
        else:
            print_array(a)
    sys.stdout = old_stdout

read_save("weight", True)
read_save("bias", False)


f = open("weight_full.txt", "r")
w = np.array([line.split() for line in f], dtype=np.float64).astype(np.int32)

f = open("bias_full.txt", "r")
b = np.array([line.split() for line in f], dtype=np.float64).astype(np.int32)

with open('images.hex', 'r') as f:
    # Читаем содержимое файла в виде байтов
    for i in range(10):
        img = f.readline()
        img = np.array([int(b, 16) for b in img.split()], dtype=np.float64).astype(np.int32)
        print(img.T.dot(w.T))
        res = img.T.dot(w.T)+b
        print(img[180])
        print(np.argmax(res))
    
    f.close()