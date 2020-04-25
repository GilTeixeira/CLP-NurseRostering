from parser import Parser
from prologer import Prologer

# Main

DATASET_PATH = '../../Dataset/Instance2.txt'
#DATASET_PATH = '../../Dataset/Instance2.txt'

p1 = Parser(DATASET_PATH)
p1.parseFile()

PROLOG_GENERATED = 'data.pl'
p2 = Prologer(p1.hospital)
p2.generatePrologFile(PROLOG_GENERATED)