#! /usr/bin/python3

# Bartosz Narozniak
# 41458
# 31B
# Zadanie na ocene 5, dla laboratorium numer 1

import sys
import pwd
import stat
import os
import datetime

rootDir = os.getcwd()

lFlaf = False
LFlag = False

for arg in sys.argv[1:len(sys.argv)]:
    if(arg == "-l"):
        lFlaf = True
    elif(arg == "-L"):
        LFlag = True
    elif(os.path.exists(arg)):
        rootDir = arg
    else:
        sys.stderr.write("Niepoprawny argument lub błędna ścieżka")
        exit(1)


for file in os.listdir(rootDir):
    line = ""
    path = rootDir + "/" + file
    stats = os.stat(path)

    if(lFlaf):
        line += file.ljust(30) + " "
        line += str(stats.st_size).ljust(10) + " "
        line += datetime.datetime.fromtimestamp(stats.st_mtime).strftime("%Y-%m-%d %H:%M:%S") + " "
        line += stat.filemode(stats.st_mode) + " "
    else:
        line += file + " "
    
    if(LFlag):
        line += pwd.getpwuid(stats.st_uid).pw_name + " "

    print(line)