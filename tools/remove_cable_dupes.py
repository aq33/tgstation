import sys
import re

if len(sys.argv) != 2:
    print(f"usage: {sys.argv[0]} DMM_FILE_PATH")
    sys.exit(-1)

cable = "/obj/structure/cable,\n"
file = sys.argv[1]

data = ""
with open(file, "r") as fr:
    data = fr.read()    

turfs = re.split("\)", data)
final_count = 0
for i, x in enumerate(turfs):
    num = x.count(cable)
    if(num == 0):
        continue
    turfs[i] = x.replace(cable, "", num - 1)
    final_count += num - 1

print(f"removed {final_count} cables")

data = ')'.join(turfs)

with open(file, 'w', newline='') as f:
    f.write(data)
