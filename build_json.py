#!/usr/bin/env python3

import os
import os.path
import glob
import json

dirs = sorted(i for i in glob.glob('*') if os.path.isdir(i))
#print(dirs)

with open("dirs.json", "w") as f:
    json.dump(dirs, f, indent=0, separators=(',', ':'))

for dir in dirs:
    pics = sorted(int(i[:-4]) for i in os.listdir(dir) if i.endswith(".bmp"))
    with open(dir + ".json", "w") as f:
        json.dump(pics, f, indent=0, separators=(',', ':'))
