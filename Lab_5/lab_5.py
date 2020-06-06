#! /usr/bin/python3

# Bartosz Narozniak
# 41458
# 31B
# Zadanie na ocene 5

import sys
import string
import stat
import os

if(len(sys.argv) <= 1):
    sys.stderr.write("Błąd: Podaj katalog lub katalogi jako argument.")
    exit(1)

allFiles = dict()
duplicate = dict()

def Tree(path):
    for root, dirs, files in os.walk(path):
        for file in files:
            fullpath = root + "/" + file
            statistics = os.stat(fullpath)
            if (allFiles.get(statistics.st_size) == None):
                allFiles[statistics.st_size] = []
            allFiles[statistics.st_size].append(fullpath)

def SameSize():
    for key in allFiles.keys():
        Compare(allFiles[key])

def Compare(files):
    for f in files:
        for v in files:
            if (f == v):
                continue
            if (BytesComp(f, v)):
                if(duplicate.get(v) == None):
                    if(duplicate.get(f) == None):
                        duplicate[f] = []
                    duplicate[f].append(v)
                else:
                    if(not f in duplicate[v]):
                        duplicate[v].append(f)

def BytesComp(f1, f2):
    with open(f1, "r") as file1:
        with open(f2, "r") as file2:
            while True:
                if(file1.read(1) != file2.read(1)):
                    return False
                if(file1.read(1) == file2.read(1)):
                    break

    return True

argTable = sys.argv[1:len(sys.argv)]

for arg in argTable:
    f = os.stat(arg)
    if(f != None and stat.S_ISDIR(f.st_mode)):
        Tree(arg)
    else:
        sys.stderr.write("Nieprawidłowy argument")
        exit(1)

SameSize()
print("Duplikaty:")

for fileD in duplicate:
    print("Duplikaty dla pliku {}:".format(fileD))
    i=1
    for duplic in duplicate[fileD]:
        print("\t {}. {}".format(str(i), duplic))
        i+=1

