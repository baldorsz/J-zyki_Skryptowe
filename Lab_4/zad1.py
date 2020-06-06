#! /usr/bin/python3

# Bartosz Narozniak
# 41458
# 31B
# Zadanie na ocene 5
# Zad1

import sys
import string

if(len(sys.argv) == 1):
    sys.stderr.write("Podaj nazwe pliku jako argument.")
    exit(1)

letters = dict()

for key in string.ascii_uppercase:
    letters[key] = 0

suma = 0

def Analiza(line):
    global suma
    suma += len(line)
    line = line.upper()
    for char in letters.keys():
        letters[char] += line.count(char)

try:
    with open(sys.argv[1]) as file:
        for line in file:
            Analiza(line)

    letters = sorted(letters.items(), key = lambda item : item[1], reverse=True)

    print("Znak\tWystapienia\tUdzial\n")
    for klucz, value in letters:
        if(value != 0):
            procent = round((value / suma)*100 , 2)
            print("{}\t{}\t{}%\n".format(klucz,value,procent))

except FileNotFoundError:
    sys.stderr.write("Nie znaleziono pliku")

