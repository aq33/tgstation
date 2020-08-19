import sys
import re

if len(sys.argv) != 2:
    print(f"usage: {sys.argv[0]} DMM_FILE_PATH")
    sys.exit(-1)

cable = "/obj/structure/cable"
file = sys.argv[1]

data = ""
with open(file, "r") as fr:
    data = fr.read()

turfs = re.split("\)", data)
final_count = 0
for i, x in enumerate(turfs):
    turfs[i] = re.sub(r'/obj/structure/cable(/yellow)?(\{(.|\n)*?\})?', cable, x)

for i, x in enumerate(turfs):
    num = x.count(cable) - 1
    if(num <= 0):
        continue
    turfs[i] = re.sub(r',\n' + cable, "", x, count = num)
    final_count += num

print(f"removed {final_count} cables")

data = ')'.join(turfs)

with open(file, 'w', newline='') as f:
    f.write(data)
