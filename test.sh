#!/bin/sh

## Next variable
# inst 2
python3 src/main.py -s -i 2 -stm 20 -o [leftmost]
python3 src/main.py -s -i 2 -stm 20 -o [min]
python3 src/main.py -s -i 2 -stm 20 -o [max]
python3 src/main.py -s -i 2 -stm 20 -o [ff]
python3 src/main.py -s -i 2 -stm 20 -o [ffc]

# inst 4
python3 src/main.py -s -i 4 -stm 20 -o [leftmost]
python3 src/main.py -s -i 4 -stm 20 -o [min]
python3 src/main.py -s -i 4 -stm 20 -o [max]
python3 src/main.py -s -i 4 -stm 20 -o [ff]
python3 src/main.py -s -i 4 -stm 20 -o [ffc]

# inst 8
python3 src/main.py -s -i 8 -stm 20 -o [leftmost]
python3 src/main.py -s -i 8 -stm 20 -o [min]
python3 src/main.py -s -i 8 -stm 20 -o [max]
python3 src/main.py -s -i 8 -stm 20 -o [ff]
python3 src/main.py -s -i 8 -stm 20 -o [ffc]

# inst 12
python3 src/main.py -s -i 12 -stm 20 -o [leftmost]
python3 src/main.py -s -i 12 -stm 20 -o [min]
python3 src/main.py -s -i 12 -stm 20 -o [max]
python3 src/main.py -s -i 12 -stm 20 -o [ff]
python3 src/main.py -s -i 12 -stm 20 -o [ffc]

##  for the selected variable X:
# inst 2
python3 src/main.py -s -i 2 -stm 20 -o [step]
python3 src/main.py -s -i 2 -stm 20 -o [enum]
python3 src/main.py -s -i 2 -stm 20 -o [bisect]

# inst 4
python3 src/main.py -s -i 4 -stm 20 -o [step]
python3 src/main.py -s -i 4 -stm 20 -o [enum]
python3 src/main.py -s -i 4 -stm 20 -o [bisect]

# inst 8
python3 src/main.py -s -i 8 -stm 20 -o [step]
python3 src/main.py -s -i 8 -stm 20 -o [enum]
python3 src/main.py -s -i 8 -stm 20 -o [bisect]

# inst 12
python3 src/main.py -s -i 12 -stm 20 -o [step]
python3 src/main.py -s -i 12 -stm 20 -o [enum]
python3 src/main.py -s -i 12 -stm 20 -o [bisect]

##  order in which the choices are made for the selected variable X.
python3 src/main.py -s -i 2 -stm 20 -o [up]
python3 src/main.py -s -i 2 -stm 20 -o [down]

python3 src/main.py -s -i 4 -stm 20 -o [up]
python3 src/main.py -s -i 4 -stm 20 -o [down]

python3 src/main.py -s -i 8 -stm 20 -o [up]
python3 src/main.py -s -i 8 -stm 20 -o [down]

python3 src/main.py -s -i 12 -stm 20 -o [up]
python3 src/main.py -s -i 12 -stm 20 -o [down]