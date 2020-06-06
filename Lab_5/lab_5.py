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
        