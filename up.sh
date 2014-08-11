DIRS="
Effect
Hair
Hum
Items
Magic
Magic2
MagIcon
Mon1
Mon10
Mon11
Mon12
Mon13
Mon14
Mon15
Mon16
Mon17
Mon18
Mon2
Mon3
Mon4
Mon5
Mon6
Mon7
Mon8
Mon9
npc
Objects
Objects2
Objects3
Objects4
Objects5
Objects6
Objects7
Prguse
Prguse2
SmTiles
StateItem
Tiles
Weapon
"

for i in $DIRS; do
    git add $i
    git commit -m $i
    git push
done
