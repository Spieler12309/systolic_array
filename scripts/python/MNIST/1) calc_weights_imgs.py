# Импорт библиотек
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sys
from sklearn.datasets import fetch_openml
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report
import pickle

# Скачивание датасета
mnist = fetch_openml('mnist_784')

# Получение картинок и результата
X = mnist.data
Y = mnist.target

# Распределение данных на обучающие и тестовые
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size = 0.15, random_state = 0 )

# Создание модели для обучения
logit_model = LogisticRegression(multi_class = 'multinomial', max_iter = 1e3, C = 1, solver = 'sag')

# Обучение модели
#logit_model.fit(X_train, Y_train)

pkl_filename = "pickle_model.pkl"
#with open(pkl_filename, 'wb') as file:
#    pickle.dump(logit_model, file)

with open(pkl_filename, 'rb') as file:
    logit_model = pickle.load(file)

score = logit_model.score(X_test, Y_test)

# Перевод матрицы весов в целый формат
def save(a, name):
    a = np.array(a) * 1000000
    a = a.astype(np.int16)

    print('weight shape: ', a.shape)
    old_stdout = sys.stdout
    with open(name + ".txt", "w") as sys.stdout:
        for i in a:
            if (len(a.shape) > 1):
                for j in i:
                    print('{:f} '.format(j), end='')
                print()
            else:
                print('{:f} '.format(i), end='')
    sys.stdout = old_stdout

#save(logit_model.coef_, 'weight')
#save(logit_model.intercept_, 'bias')

nums = [52221, 66622, 52224, 65224, 52222, 52231, 62508, 21243, 24654, 32100]

imgs = X_train.loc[X_train.index.isin(nums)]
imgs_pred = logit_model.predict(imgs)
print(imgs_pred)

imgs = np.array(imgs, np.int16)

def print_array(A):
    for i in A:
            if (len(A.shape) > 1):
                for j in i:
                    print("{:x}".format(j & 0xffff), end=" ")
                print()
            else:
                print("{:x}".format(i & 0xffff), end=" ")

old_stdout = sys.stdout
#for i in range(10):
#  with open("image_{}.txt".format(i), "w") as sys.stdout:
#      print_array(imgs[i])
sys.stdout = old_stdout

old_stdout = sys.stdout
#with open("images.txt".format(i), "w") as sys.stdout:
#    print_array(imgs)
sys.stdout = old_stdout