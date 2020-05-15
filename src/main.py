import subprocess as sp
import time
import sys
from pathlib import Path
import json 
import time;


from Parser.parser import Parser
from Parser.prologer import Prologer
from Parser.xmler import XMLer


# Variables
INSTANCE = 2
SEARCH_TIME = 60 # in seconds
SOL_PATH = 'sol/'
SOLVER_PATH = 'src/Solver/solver.pl'



# Constants
INSTANCE_PATH = 'Dataset/Instance%d.txt'
GENERATED_PROLOG_DATA_PATH = 'src/Solver/settings/data.pl'
GENERATED_PROLOG_SETTINGS_PATH = 'src/Solver/settings/settings.pl'
XML_DATASET_RELATIVE_PATH = '../Dataset/Instance%d.ros'


###

def createSettingsFile(solFilename, settingsPath):
	settingsFile = open(settingsPath, 'w', encoding="utf-8")
	settingsCode = ':- include(\'data.pl\').\n\n'
	settingsCode += 'search_time(%d). %%in seconds \n' % (SEARCH_TIME)
	settingsCode += 'sol_filename(%d). %%in seconds \n' % (solFilename)
	settingsFile.write(settingsCode)
	settingsFile.close()



def runSolver(solverPath):

	start = time.time() #time measurement start
	goal = 'solver(S), halt.'
	cmd = "sicstus --nologo --noinfo -l %s --goal '%s'" % (solverPath, goal)
	process = sp.Popen(cmd, shell=True, stdout=sys.stdout, stderr=sys.stdout)
	process.wait()
	processTime = (time.time() - start) * 1000 # miliseconds

	return processTime # time in miliseconds


def createSolDirectory():
	tempPath = "./sol"
	Path(tempPath).mkdir(exist_ok=True)


def main():


	# parser
	datasetPath = INSTANCE_PATH % (INSTANCE)
	p1 = Parser(datasetPath)
	p1.parseFile()

	# prologer
	createSolDirectory()
	solPrefix = 'Inst-%d_Time-%d_Timestamp-%f'%(INSTANCE,SEARCH_TIME,time.time())
	solFilename = solPrefix+ '.json'
	p2 = Prologer(p1.hospital,SEARCH_TIME)
	p2.generatePrologFiles(GENERATED_PROLOG_DATA_PATH,GENERATED_PROLOG_SETTINGS_PATH, solFilename)


	# solver
	exec_time = runSolver(SOLVER_PATH)

	#xmler
	


	

	# Opening JSON file 
	solPath = SOL_PATH + solFilename
	f = open(solPath) 
	sol = json.load(f)

	solXMLPath = SOL_PATH+ solPrefix+ '.xml'
	x1 = XMLer(solXMLPath, p1.hospital, sol['schedule'])
	x1.createXMLFile(XML_DATASET_RELATIVE_PATH % (INSTANCE))



if __name__ == "__main__":
	#datasetPath = 'Dataset/Instance%d.txt'
	#print( datasetPath % (INSTANCE))
	#createSettingsFile()
    main()
	#print()

'''
import argparse

# parse the command line arguments
parser = argparse.ArgumentParser(description="Nurse rostering problem solver")

# actions
groupActions = parser.add_argument_group('actions')
groupActions.add_argument('-i','--instance', help='Solve a nth instance of the dataset', default=False, action='store_true')
g
args = parser.parse_args()
#print(args.accumulate(args.integers))
'''