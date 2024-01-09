import numpy as np
import sys

path = "{}_data.hex"

def calc_array(A, B, ARRAY_W, ARRAY_L):
    res = np.zeros((ARRAY_W, ARRAY_W), dtype = np.int16)
    add = np.zeros((ARRAY_W, ARRAY_W + 2), dtype = np.int16)
    prop = np.zeros((ARRAY_W + 2, ARRAY_L), dtype = np.int16)
    inp = np.zeros((ARRAY_W, ARRAY_W+2), dtype = np.int16)
    FETCH_LENGTH = 2 * ARRAY_L + ARRAY_W + 1
      
    param_data = B
    for k in range(FETCH_LENGTH):
        u = min(ARRAY_W, k) - 1
        for j in range(u + 1, -1, -1):
            for i in range(j):
                print(i, u - i + 1)
                inp[i][u - i + 1] = inp[i][u - i]
        
        for i in range(ARRAY_W):
            if ((k - ARRAY_L <= i) and (i <= min(k, ARRAY_W - 1)) and (k - i < ARRAY_L)):
                inp[i][0] = A[i][k - i]
            else:
                inp[i][0] = 0
        #print(inp)
        print("-----")

        for i in range(ARRAY_W):
            for j in range(ARRAY_L):                
                if (i + j <= k):
                    res[i][j] = add[i][j] + B[i][j] * prop[i][j]
                    add[i][j + 1] = res[i][j]
        
    return res, add

def print_array1(A):
    for i in A:
        for j in i:
            print(hex(j & 0xff)[2:].zfill(2), end=" ")
        print();

def print_array2(A):
    for i in A:
        for j in i:
            print(hex(j & 0xffff)[2:].zfill(4), end=" ")
        print();

def simple_test():
    A = np.array([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
        [10, 11, 12]])
    W = np.array([
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12]])

    ARRAY_A_W = A.shape[1] # Кол-во столбцов
    ARRAY_A_L = A.shape[0] # Кол-во строк

    ARRAY_W_W = W.shape[1] # Кол-во столбцов
    ARRAY_W_L = W.shape[0] # Кол-во строк

    old_stdout = sys.stdout


    with open(path.format("a"), "w") as sys.stdout:
        print_array1(A)
    sys.stdout = old_stdout
    print("A {}:".format(A.shape))
    print_array1(A)

    with open(path.format("b"), "w") as sys.stdout:
        print_array1(W)
    sys.stdout = old_stdout
    print("\nW {}:".format(W.shape))
    print_array1(W)

    res = np.dot(A, W)
    with open(path.format("c"), "w") as sys.stdout:
        print_array2(res)
    sys.stdout = old_stdout
    print("\nres {}:".format(res.shape))
    print_array2(res)
    print("\n", res)

def global_test(n):
    for i in range(n):
        a_shape = (4, 3)#np.random.randint(1, 100, (2))
        w_shape = (3, 4) #[a_shape[1], np.random.randint(1, 100)]
        print(w_shape)
        A = np.random.randint(-63, 63, a_shape)
        W = np.random.randint(-63, 63, w_shape)

        ARRAY_A_W = A.shape[0] # Кол-во строк
        ARRAY_A_L = A.shape[1] # Кол-во столбцов

        ARRAY_W_W = W.shape[0] # Кол-во строк
        ARRAY_W_L = W.shape[1] # Кол-во столбцов

        old_stdout = sys.stdout


        with open(path.format("a"), "w") as sys.stdout:
            print_array1(A)
        sys.stdout = old_stdout
        print("A {}:".format(A.shape))
        print(A)

        with open(path.format("b"), "w") as sys.stdout:
            print_array1(W)
        sys.stdout = old_stdout
        print("\nW {}:".format(W.shape))
        print(W)

        res = np.dot(A, W)
        with open(path.format("c"), "w") as sys.stdout:
            print_array2(res)
        sys.stdout = old_stdout
        print("\nres {}:".format(res.shape))
        print(res)

        t = input()

simple_test()