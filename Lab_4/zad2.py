#! /usr/bin/python3

# Bartosz Narozniak
# 41458
# 31B
# Zadanie na ocene 5
# Zad2

import sys
import string

fMap = dict()
fDict = dict()

for k in string.ascii_uppercase:
    fDict[k] = 0

def Analiza(line):
    line = line.upper()
    for char in fDict.keys():
        fDict[char] += line.count(char)

def MakeFMap(line):
    counter = 0
    for k in fDict:
        fMap[line[counter]] = k[0]
        counter +=1

def Decipher(line):
    Cline = ""
    for c in line:
        if (c in fMap):
            Cline += fMap[c]
        else:
            Cline += c

    print(Cline)

filename = "cipher.txt"

try:
    with open(filename) as file:
        linesCopy = []
        firstLine = file.readline()
        for line in file:
            Analiza(line)
            linesCopy.append(line)
        
        fDict = sorted(fDict.items(), key = lambda item:item[1], reverse=True)

        MakeFMap(firstLine)
        
        for line in linesCopy:
            Decipher(line)

except FileNotFoundError:
    sys.stderr.write("Nie znaleziono pliku")
    exit(1)