import xml.etree.ElementTree as ET
from datetime import date
from datetime import datetime
from datetime import timedelta

import itertools


DATASET_PATH = '../../Dataset/Instance24.ros'
#tree = ET.parse(DATASET_PATH)
#root = tree.getroot()
#minRestTime = tree.find('.//MinRestTime').text
#print(minRestTime)

class Shift:
  def __init__(self, shiftID, startTime, duration):
    self.shiftID = shiftID
    self.startTime = startTime
    self.duration = duration
    self.shiftsIDCantFollow = [] # Shifts which cannot follow this shift

  def addShiftThatCantFollow(self,shiftID):
    self.shiftsIDCantFollow.append(shiftID)

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

class Parser:
  def __init__(self, filepath):
    self.filepath = filepath
    self.tree = ET.parse(DATASET_PATH)
    self.root = self.tree.getroot()

    self.numberOfDays = 0
    self.minRestTime = 0
    self.shifts = []

  def parseXML(self): 
    self.parseNumberOfDays()  
    self.parseShifts()
    self.parseRestTimeShifts()
    self.parseStaff()
    self.parseDaysOff()
    self.parseShiftOnRequests()
    self.parseShiftOffRequests()
    self.parseCover()


  def parseNumberOfDays(self):
    startDateStr = self.root.find('StartDate').text
    endDateStr = self.root.find('EndDate').text
    startDate = date.fromisoformat(startDateStr)
    endDate = date.fromisoformat(endDateStr)
    delta = (endDate - startDate)
    self.numberOfDays = delta.days
    #print(self.numberOfDays)


  def parseShifts(self):
    for shift in self.root.findall('./ShiftTypes/Shift'):
      shiftID = shift.attrib['ID']
      startTimeStr = shift.find('./StartTime').text
      startTime = datetime.strptime(startTimeStr, '%H:%M')
      duration = int(shift.find('./Duration').text)
      self.shifts.append(Shift(shiftID, startTime, duration))
      #print(shiftID, startTime, duration)
    
    return 

    
  def parseRestTimeShifts(self):
    self.minRestTime = int(self.root.find('.//MinRestTime').text)
    for shift in self.shifts:
      for nextShift in self.shifts:
        shiftEndTime = shift.startTime + timedelta(minutes=shift.duration)
        shiftEndPlusRest = shiftEndTime + timedelta(minutes=self.minRestTime)
        shiftStartTimeNextDay = nextShift.startTime + timedelta(days=1)
        if(shiftEndPlusRest > shiftStartTimeNextDay):
          shift.shiftsIDCantFollow.append(nextShift.shiftID)
      
      #print(shift.shiftsIDCantFollow)     

  def parseStaff(self):
    # nurseID, maxShifts, 
    # maxTotalMinutes, minTotalMinutes, , 
    # , , maxWeekends

    for nurse in root.findall('./Contracts/Contract'):
      nurseID = nurse.attrib['ID']
      if(nurseID!='All'):
        nurseID = int(nurseID)
        maxConsecutiveShifts = int(nurse.find('.//MaxSeq').text)
        minConsecutiveShifts = int(nurse.find('.//MinSeq').text)
        minConsecutiveDaysOff = int(nurse.find('.//Min/Count').text)


        minTotalMinutes = int(nurse.find('.//Min/Count').text)
        maxTotalMinutes = int(nurse.find('.//Max/Count').text)
        self.employees.append(Employee(employeeID,minTotalMinutes,maxTotalMinutes))    
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



p1 = Parser(DATASET_PATH)
p1.parseXML()