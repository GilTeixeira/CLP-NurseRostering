from .hospital import *

class Parser:
    def __init__(self, filepath):
        self.filepath = filepath
        self.hospital = Hospital()

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
                    # print(self.hospital.numberOfDays)
                    return

                if foundSection and not line.startswith('#'): # Found section
                    self.hospital.numberOfDays = int(line)



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
                    duration = int(lineList[1])
                    shiftsIDCantFollow = [shift for shift in lineList[2].split('|') if shift]
                    self.hospital.shifts.append(Shift(shiftID,duration,shiftsIDCantFollow))
                    # print(shiftID, duration, shiftsIDCantFollow)
                    
                    
    def parseStaff(self):   
        foundSection = False
        sectionName = 'SECTION_STAFF'
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
                    maxTotalMinutes = int(lineList[2])
                    minTotalMinutes = int(lineList[3])
                    maxConsecutiveShifts = int(lineList[4])
                    minConsecutiveShifts = int(lineList[5])
                    minConsecutiveDaysOff = int(lineList[6])
                    maxWeekends = int(lineList[7])
                    maxShifts = []

                    maxShiftsList = lineList[1].rstrip().split('|')
                    for maxShiftItem in maxShiftsList:
                        shiftID = maxShiftItem.split('=')[0]
                        maxShift = int(maxShiftItem.split('=')[1])
                        #maxShifts.append({'shiftID':shiftID,'maxShift':maxShift})
                        maxShifts.append((shiftID, maxShift))

                    self.hospital.nurses.append(Nurse(nurseID, maxShifts,
                    maxTotalMinutes, minTotalMinutes, maxConsecutiveShifts, 
                    minConsecutiveShifts, minConsecutiveDaysOff, maxWeekends))
                    # print(nurseID, maxShifts,
                    #maxTotalMinutes, minTotalMinutes, maxConsecutiveShifts, 
                    #minConsecutiveShifts, minConsecutiveDaysOff, maxWeekends)
                    

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
                    
                    for nurse in self.hospital.nurses:
                        if nurse.nurseID == nurseID:
                            nurse.daysOff = daysOff
                            # print(nurseID, nurse.daysOff)
                            break



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
                    onRequest = True
                    request = Request(day, shiftID, weight, onRequest)

                    for nurse in self.hospital.nurses:
                        if nurse.nurseID == nurseID:
                            nurse.shiftOnRequests.append(request)
                            break
                    # Request(day, shiftID, weight, OnRequest)
                    # print(nurseID, day, shiftID, weight, OnRequest)


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
                    onRequest = False
                    request = Request(day, shiftID, weight, onRequest)

                    for nurse in self.hospital.nurses:
                        if nurse.nurseID == nurseID:
                            nurse.shiftOffRequests.append(request)
                            break
                    # Request(day, shiftID, weight, OnRequest)
                    # print(nurseID, day, shiftID, weight, OnRequest)

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
                    self.hospital.covers.append(Cover(day, shiftID, required, weightUnder, weightOver))
                    #print(day, shiftID, required, weightUnder, weightOver)
