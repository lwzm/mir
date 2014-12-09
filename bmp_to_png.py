#!/usr/bin/env python3
# ls */*.bmp | xargs -n 10 ./bmp_to_png.py


from PIL import Image

def conv(fn):
    t1 = (0, 0, 0, 255)
    t2 = (0, 0, 0, 0)
    b = Image.open(fn)
    a = b.convert("RGBA")
    dat = a.getdata()
    dat_new = [t2 if c == t1 else c for c in dat]
    a.putdata(dat_new)
    a.convert('P').save(fn[:-3] + "png")


if __name__ == "__main__":
    import sys
    import os
    print(os.getpid())
    for i in sys.argv[1:]:
        conv(i)
