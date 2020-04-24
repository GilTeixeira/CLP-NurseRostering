class Shift:
    def __init__(self, shiftID, duration, shiftsIDCantFollow):
        self.shiftID = shiftID
        self.duration = duration
        self.shiftsIDCantFollow = shiftsIDCantFollow # Shifts which cannot follow this shift

class Request:
    def __init__(self, day, shiftID, weight, OnRequest):
        self.day=day
        self.shiftID=shiftID
        self.weight=weight
        self.OnRequest=OnRequest

class Cover:
  def __init__(self, day, shiftID, required, weightUnder, weightOver):
      self.day = day
      self.shiftID = shiftID
      self.required = required
      self.weightUnder = weightUnder
      self.weightOver = weightOver

class Nurse:
    def __init__(self, nurseID, maxShifts,
    maxTotalMinutes, minTotalMinutes, maxConsecutiveShifts, 
    minConsecutiveShifts, minConsecutiveDaysOff, maxWeekends):
        self.nurseID = nurseID
        self.maxShifts = maxShifts
        self.maxTotalMinutes = maxTotalMinutes
        self.minTotalMinutes = minTotalMinutes
        self.maxConsecutiveShifts = maxConsecutiveShifts
        self.minConsecutiveShifts = minConsecutiveShifts
        self.minConsecutiveDaysOff = minConsecutiveDaysOff
        self.maxWeekends = maxWeekends
        self.daysOff = []
        self.shiftOnRequest = []
        self.shiftOffRequest = []
    
    def addDaysOff(self, daysOff):
        return
    
    def addShiftOnRequest(self, shiftOnRequest):
        return

    def addShiftOnRequest(self, shiftOnRequest):
        return



class Parser:
    def __init__(self, filepath):
        self.filepath = filepath
        self.numberOfDays = 0
        self.minRestTime = 0
        self.shifts = []
        self.covers = []

    def parseFile(self): 
        self.parseNumberOfDays()  
        self.parseShifts()
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
                    
                    
    def parseStaff(self):   
        return

    def parseDaysOff(self):
        foundSection = False
        sectionName = 'SECTION_DAYS_OFF'
        with open(self.filepath, 'r') as f:
            for line in f:
                if sectionName in line: # Search Section
                    foundSection = True
                    continue

                if foundSection and (line in ['\n', '\r\n']): # End Section
                    return

                if foundSection and not line.startswith('#'): # Found section
                    lineList = line.rstrip().split(',')
                    nurseID = lineList[0]
                    daysOff = [int(dayOff) for dayOff in lineList[1:]]                    
                    # print(nurseID, daysOff)
                    # TODO
                    # ADD to Nurse ARRAY


    def parseShiftOnRequests(self):
        foundSection = False
        sectionName = 'SECTION_SHIFT_ON_REQUESTS'
        with open(self.filepath, 'r') as f:
            for line in f:
                if sectionName in line: # Search Section
                    foundSection = True
                    continue

                if foundSection and (line in ['\n', '\r\n']): # End Section
                    return

                if foundSection and not line.startswith('#'): # Found section
                    lineList = line.rstrip().split(',')
                    nurseID = lineList[0]

                    day = int(lineList[1])
                    shiftID = lineList[2]
                    weight = int(lineList[3])
                    OnRequest = True
                    # Request(day, shiftID, weight, OnRequest)
                    # print(nurseID, day, shiftID, weight, OnRequest)
                    # TODO
                    # ADD to Nurse ARRAY



    def parseShiftOffRequests(self):
        foundSection = False
        sectionName = 'SECTION_SHIFT_OFF_REQUESTS'
        with open(self.filepath, 'r') as f:
            for line in f:
                if sectionName in line: # Search Section
                    foundSection = True
                    continue

                if foundSection and (line in ['\n', '\r\n']): # End Section
                    return

                if foundSection and not line.startswith('#'): # Found section
                    lineList = line.rstrip().split(',')
                    nurseID = lineList[0]

                    day = int(lineList[1])
                    shiftID = lineList[2]
                    weight = int(lineList[3])
                    OnRequest = False
                    # Request(day, shiftID, weight, OnRequest)
                    # print(nurseID, day, shiftID, weight, OnRequest)
                    # TODO
                    # ADD to Nurse ARRAY

    def parseCover(self):    
        foundSection = False
        sectionName = 'SECTION_COVER'
        with open(self.filepath, 'r') as f:
            for line in f:
                if sectionName in line: # Search Section
                    foundSection = True
                    continue

                if foundSection and (line in ['\n', '\r\n']): # End Section
                    return

                if foundSection and not line.startswith('#'): # Found section
                    lineList = line.rstrip().split(',')
                    day = int(lineList[0])
                    shiftID = lineList[1]
                    required = int(lineList[2])
                    weightUnder = int(lineList[3])
                    weightOver = int(lineList[4])
                    self.covers.append(Cover(day, shiftID, required, weightUnder, weightOver))
                    print(day, shiftID, required, weightUnder, weightOver)

DATASET_PATH = '../../Dataset/Instance24.txt'
p1 = Parser(DATASET_PATH)
p1.parseFile()