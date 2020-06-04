import subprocess as sp
import time
import sys
from pathlib import Path
import json 
import time
import argparse
import csv
import os

from Parser.parser import Parser
from Parser.prologer import Prologer
from Parser.xmler import XMLer


# Variables
INSTANCE = 1
SEARCH_TIME = 5 # in seconds
SOL_PATH = 'sol/'
SOLVER_PATH = 'src/Solver/solver.pl'
SICSTUS_PATH = 'sicstus'
OPTIONS = []
CSV_FILE_PATH = SOL_PATH + 'sols.csv'

# Constants
INSTANCE_PATH = 'Dataset/Instance%d.txt'
GENERATED_PROLOG_DATA_PATH = 'src/Solver/settings/data.pl'
GENERATED_PROLOG_SETTINGS_PATH = 'src/Solver/settings/settings.pl'
XML_DATASET_RELATIVE_PATH = '../Dataset/Instance%d.ros'
SETTINGS_PATH = 'src/Solver/settings/settings.pl'


###

def createSettingsFile(solFilename, settingsPath, options):
	settingsFile = open(settingsPath, 'w', encoding="utf-8")
	settingsCode = ':- include(\'data.pl\').\n\n'
	settingsCode += 'search_time(%d). %%in seconds \n' % (SEARCH_TIME)
	settingsCode += 'sol_filename(\'%s\'). %% solution file \n' % (solFilename)
	settingsCode += 'labeling_options(%s). %% labeling options \n' % (options)
	settingsFile.write(settingsCode)
	settingsFile.close()



def runSolver(solverPath):

	start = time.time() #time measurement start
	goal = 'solver(S), halt.'
	cmd = "%s --nologo --noinfo -l %s --goal '%s'" % (SICSTUS_PATH, solverPath, goal)
	process = sp.Popen(cmd, shell=True, stdout=sys.stdout, stderr=sys.stdout)
	process.wait()
	processTime = (time.time() - start) * 1000 # miliseconds

	return processTime # time in miliseconds


def createSolDirectory():
	tempPath = "./sol"
	Path(tempPath).mkdir(exist_ok=True)

def writeCSVFile(sol):
    file_exists = os.path.isfile(CSV_FILE_PATH)

    with open(CSV_FILE_PATH, mode='w') as sols_file:
        headers = ['intance', 'timeToSearch', 'options', 'flag',
                   'penalty']
        writer = csv.DictWriter(sols_file, delimiter=',',
                                lineterminator='\n',
                                fieldnames=headers,
                                quoting=csv.QUOTE_MINIMAL)

        if not file_exists:
            writer.writeheader()  # file doesn't exist yet, write a header

        # writer.writerow([INSTANCE, SEARCH_TIME, OPTIONS, sol['flag'], sol['totalPenalty']])

        dictSol = {
            'intance': INSTANCE,
            'timeToSearch': SEARCH_TIME,
            'options': OPTIONS,
            'flag': sol['flag'],
            'penalty': sol['totalPenalty'],
            }

        writer.writerow(dictSol)


def run():


	# parser
	datasetPath = INSTANCE_PATH % (INSTANCE)
	p1 = Parser(datasetPath)
	p1.parseFile()

	# prologer
	createSolDirectory()
	solPrefix = 'Inst-%d_Time-%d_Timestamp-%f'%(INSTANCE,SEARCH_TIME,time.time())
	solFilename = solPrefix+ '.json'
	p2 = Prologer(p1.hospital,SEARCH_TIME,datasetPath)
	p2.generatePrologFiles(GENERATED_PROLOG_DATA_PATH,GENERATED_PROLOG_SETTINGS_PATH, solFilename)
	createSettingsFile(solFilename,SETTINGS_PATH,OPTIONS)


	# solver
	exec_time = runSolver(SOLVER_PATH)

	#xmler
	


	

	# Opening JSON file 
	solPath = SOL_PATH + solFilename
	f = open(solPath) 
	sol = json.load(f)

	# write to csv file
	writeCSVFile(sol)

	print(solPath)
	if (sol['flag'] == "time_out") : return # only create xml when succeds

	solXMLPath = SOL_PATH+ solPrefix+ '.xml'
	x1 = XMLer(solXMLPath, p1.hospital, sol['schedule'])
	x1.createXMLFile(XML_DATASET_RELATIVE_PATH % (INSTANCE))



#if __name__ == "__main__":
	#datasetPath = 'Dataset/Instance%d.txt'
	#print( datasetPath % (INSTANCE))
	#createSettingsFile()
    #main()





# parse the command line arguments
parser = argparse.ArgumentParser(description="Nurse rostering problem solver")

# actions
groupActions = parser.add_argument_group('actions')
groupActions.add_argument('-s','--solve', help='Solve a instance of the dataset', default=False, action='store_true')

#parser.add_argument_group('actions')
groupTimeArgs = parser.add_argument_group('time search arguments').add_mutually_exclusive_group()
groupTimeArgs.add_argument('-sts','--search-time-seconds', metavar="", help='Number of seconds to search', type=int)
groupTimeArgs.add_argument('-stm','--search-time-minutes', metavar="", help='Number of minutes to search', type=int)
groupTimeArgs.add_argument('-sth','--search-time-hours', metavar="", help='Number of hours to search',  type=int)

groupInstanceArgs = parser.add_argument_group('Instance search arguments')
groupInstanceArgs.add_argument('-i','--instance', metavar="", help='Instance to solve', default=1, type=int)

groupSearchOptionsArgs = parser.add_argument_group('Options search arguments')
groupSearchOptionsArgs.add_argument('-o','--options', metavar="", help='Labeling options', default='[]', type=str)

args = parser.parse_args()
#print(args.accumulate(args.integers))


if args.solve:
	#print(args)
	if args.search_time_seconds:
		SEARCH_TIME = args.search_time_seconds

	if args.search_time_minutes:
		SEARCH_TIME = args.search_time_minutes * 60 

	if args.search_time_hours:
		SEARCH_TIME = args.search_time_hours * 60 * 60 	
	INSTANCE = args.instance
	OPTIONS = args.options
	#print(SEARCH_TIME)
	#$print(INSTANCE)
	run()

else:
	parser.print_help()