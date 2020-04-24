'''
def parse_file(filepath):
    """
    Parse text at given filepath

    Parameters
    ----------
    filepath : str
        Filepath for file_object to be parsed

    Returns
    -------
    data : pd.DataFrame
        Parsed data

    """

    data = []  # create an empty list to collect the data
    # open the file and read through it line by line
    with open(filepath, 'r') as file_object:
        line = file_object.readline()
        while line:
            # at each line check for a match with a regex
            key, match = _parse_line(line)

            # extract school name
            if key == 'school':
                school = match.group('school')

            # extract grade
            if key == 'grade':
                grade = match.group('grade')
                grade = int(grade)

            # identify a table header 
            if key == 'name_score':
                # extract type of table, i.e., Name or Score
                value_type = match.group('name_score')
                line = file_object.readline()
                # read each line of the table until a blank line
                while line.strip():
                    # extract number and value
                    number, value = line.strip().split(',')
                    value = value.strip()
                    # create a dictionary containing this row of data
                    row = {
                        'School': school,
                        'Grade': grade,
                        'Student number': number,
                        value_type: value
                    }
                    # append the dictionary to the data list
                    data.append(row)
                    line = file_object.readline()

            line = file_object.readline()

        # create a pandas DataFrame from the list of dicts
        data = pd.DataFrame(data)
        # set the School, Grade, and Student number as the index
        data.set_index(['School', 'Grade', 'Student number'], inplace=True)
        # consolidate df to remove nans
        data = data.groupby(level=data.index.names).first()
        # upgrade Score from float to integer
        data = data.apply(pd.to_numeric, errors='ignore')
    return data


DATASET_PATH = '../../Dataset/Instance2.txt'
data = parse(DATASET_PATH)
print(data)
'''
'''
import re
import pandas as pd


def parse_line():
    return


def parse_file(filepath):
    data = []  # create an empty list to collect the data
    # open the file and read through it line by line
    with open(filepath, 'r') as file_object:
        line = file_object.readline()
        while line:
            parse_line()


DATASET_PATH = '../../Dataset/Instance2.txt'
data = parse_file(DATASET_PATH)
print(data)
'''
'''
logFile = '../../Dataset/Instance2.txt'

with open(logFile) as f:
    content = f.readlines()    
# you may also want to remove empty lines
content = [l.strip() for l in content if l.strip()]

'''


'''
logFile = '../../Dataset/Instance2.txt'

def parseNumberOfDays():
    found_type = False
    with open(logFile, 'r') as f:
        for line in f:
            if line.startswith('#') : #Ignore comments
                continue


            if 'SECTION_HORIZON' in line:
                found_type = True
                continue

         
            if found_type: # Found section
                #if line in ['\n', '\r\n']: # End Section
                #   return
                return int(line)
                #print(line)

                


print(parseNumberOfDays())

def parseShifts():
    found_type = False
    with open(logFile, 'r') as f:
        for line in f:
            if line.startswith('#') : #Ignore comments
                continue


            if 'SECTION_SHIFTS' in line:
                found_type = True
                continue

         
            if found_type: # Found section
                if line in ['\n', '\r\n']: # End Section
                   return
                return int(line)
                #print(line)

'''

class Shift:
  def __init__(self, shiftID, duration, shiftsIDCantFollow):
    self.shiftID = shiftID
    self.duration = duration
    self.shiftsIDCantFollow = shiftsIDCantFollow # Shifts which cannot follow this shift


class Parser:
    def __init__(self, filepath):
        self.filepath = filepath
        self.numberOfDays = 0
        self.minRestTime = 0
        self.shifts = []

    def parseFile(self): 
        self.parseNumberOfDays()  
        self.parseShifts()
        self.parseRestTimeShifts()
        self.parseStaff()
        self.parseDaysOff()
        self.parseShiftOnRequests()
        self.parseShiftOffRequests()
        self.parseCover()

    def parseNumberOfDays(self):
        foundSection = False
        sectionName = 'SECTION_HORIZON'
        with open(self.filepath, 'r') as f:
            for line in f:
                if sectionName in line: # Search Section
                    foundSection = True
                    continue

                if foundSection and (line in ['\n', '\r\n']): # End Section
                    # print(self.numberOfDays)
                    return

                if foundSection and not line.startswith('#'): # Found section
                    self.numberOfDays = int(line)



    def parseShifts(self):
        foundSection = False
        sectionName = 'SECTION_SHIFTS'
        with open(self.filepath, 'r') as f:
            for line in f:
                if sectionName in line: # Search Section
                    foundSection = True
                    continue

                if foundSection and (line in ['\n', '\r\n']): # End Section
                    return

                if foundSection and not line.startswith('#'): # Found section
                    lineList = line.rstrip().split(',')
                    shiftID = lineList[0]
                    duration = lineList[1]
                    shiftsIDCantFollow = [shift for shift in lineList[2].split('|') if shift]
                    self.shifts.append(Shift(shiftID,duration,shiftsIDCantFollow))
                    # print(shiftID, duration, shiftsIDCantFollow)
                    
                    
    def parseRestTimeShifts(self):
        return  

    def parseStaff(self):   
        return

    def parseDaysOff(self):
        return

    def parseShiftOnRequests(self):
        return

    def parseShiftOnRequests(self):
        return

    def parseShiftOffRequests(self):
        return

    def parseCover(self):    
        return

DATASET_PATH = '../../Dataset/Instance24.txt'
p1 = Parser(DATASET_PATH)
p1.parseFile()