ARRAY_W_W = 20
ARRAY_W_L = 10
ARRAY_A_W = 10
ARRAY_A_L = 10


def to_hex(a):
    t = hex(a).split('x')[-1]
    if len(t) == 1:
        t = '0' + t
    return t


print('A')
A=[]
for i in range(ARRAY_W_W):
    A.append(A)
    A[-1] = []
    for j in range(ARRAY_W_L):
        t = i*ARRAY_W_L + j
        if (t>255):
            t = t % 256
        A[-1].append(t)
        print(to_hex(t), end=' ')
    print()
print('\nB')
B=[]
for i in range(ARRAY_A_W):
    B.append(A)
    B[-1] = []
    for j in range(ARRAY_A_L):
        t = i*ARRAY_A_L + j
        if (t>255):
            t = t % 256
        B[-1].append(t)
        print(to_hex(t), end=' ')
    print()
    
import numpy as np
a = np.array(A)
b = np.array(B)
total = a.dot(b)
print(total)