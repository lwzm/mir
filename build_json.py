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
    pics = sorted((i for i in os.listdir(dir) if i.endswith(".bmp")), key=lambda s: int(s[:-4]))
    with open(dir + ".json", "w") as f:
        json.dump(pics, f, indent=0, separators=(',', ':'))
