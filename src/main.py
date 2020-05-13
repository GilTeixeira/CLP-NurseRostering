import subprocess as sp
import time
import sys
from pathlib import Path
import json 

from Parser.parser import Parser
from Parser.prologer import Prologer
from Parser.xmler import XMLer

# Main

DATASET_PATH = 'Dataset/Instance2.txt'
SEARCH_TIME = 60 # in seconds
SOL_PATH = 'temp/sol.json'



def runSolver(solverPath):

	start = time.time() #time measurement start
	goal = 'solver(S), halt.'
	cmd = "sicstus --nologo --noinfo -l %s --goal '%s'" % (solverPath, goal)
	process = sp.Popen(cmd, shell=True, stdout=sys.stdout, stderr=sys.stdout)
	process.wait()
	processTime = (time.time() - start) * 1000 # miliseconds

	return processTime # time in miliseconds





def main():
	tempPath = "./temp"
	Path(tempPath).mkdir(exist_ok=True)

	p1 = Parser(DATASET_PATH)
	p1.parseFile()
	PROLOG_GENERATED = 'temp/data.pl'
	p2 = Prologer(p1.hospital)
	p2.generatePrologFile(PROLOG_GENERATED)

	

	solverPath = './src/Solver/solver.pl'
	print(runSolver(solverPath))


	# Opening JSON file 
	f = open(SOL_PATH) 
	sol = json.load(f)

	x1 = XMLer('filepath', p1.hospital, sol['schedule'])
	x1.createXMLFile('../Dataset/Instance2.ros')



if __name__ == "__main__":
    main()
