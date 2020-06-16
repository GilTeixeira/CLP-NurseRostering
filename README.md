# feup-mpe


### Requirements 
* SICStus 4.5
* Add SICStus to path or change SICStus path in main.py
* Python 3.8

### Usage 
#### To Run
```
python src/main.py 
```

#### Help message
```
usage: main.py [-h] [-s] [-sts  | -stm  | -sth ] [-i] [-o]

Nurse rostering problem solver

optional arguments:
  -h, --help            show this help message and exit

actions:
  -s, --solve           Solve a instance of the dataset

time search arguments:
  -sts , --search-time-seconds 
                        Number of seconds to search
  -stm , --search-time-minutes 
                        Number of minutes to search
  -sth , --search-time-hours 
                        Number of hours to search

Instance search arguments:
  -i , --instance       Instance to solve

Options search arguments:
  -o , --options        Labeling options
```

#### Example for Instance 1 for 10 minutes with options [enum,down]
```
python src/main.py -s -i 1 -stm 10 -o [enum,down]
```