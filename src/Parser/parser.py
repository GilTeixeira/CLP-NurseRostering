import xml.etree.ElementTree as ET
from datetime import date
from datetime import datetime


DATASET_PATH = '../Dataset/xml/5_7_10_2.ros'
tree = ET.parse(DATASET_PATH)
root = tree.getroot()





#SECTION_HORIZON
# All instances start at 06:00 on the first day and finish at 06:00 on the last day.
# The planning horizon length in days:


#SECTION_TASKS
# The number of different tasks


#SECTION_STAFF
# ID, MinTotalMinutes, MaxTotalMinutes



#SECTION_COVER
# Day, Time, TaskID, Min, Max

class Employee:
  def __init__(self, employeeID, minTotalMinutes, maxTotalMinutes):
      self.employeeID = employeeID
      self.minTotalMinutes = minTotalMinutes
      self.maxTotalMinutes = maxTotalMinutes

class Cover:
  def __init__(self, day, Time, TaskID, Min, Max):
      self.employeeID = employeeID
      self.minTotalMinutes = minTotalMinutes
      self.maxTotalMinutes = maxTotalMinutes

       # Day, Time, TaskID, Min, Max


class Parser:
  def __init__(self, filepath):
    self.filepath = filepath
    self.tree = ET.parse(DATASET_PATH)
    self.root = tree.getroot()

    self.numberOfDays = 0
    self.numberOfTasks = 0
    self.employees = []
    self.covers = []
    # parseXML()

  def parseXML(self):
    self.parseNumberOfDays()  
    self.parseNumberOfTasks()
    self.parseStaff()
    self.parseCover()


  def parseNumberOfDays(self):
    startDateStr = root.find('StartDate').text
    endDateStr = root.find('EndDate').text
    startDate = date.fromisoformat(startDateStr)
    endDate = date.fromisoformat(endDateStr)
    delta = (endDate - startDate)
    self.numberOfDays = delta.days

  def parseNumberOfTasks(self):
    tasksNode = root.find('Tasks')
    for task in tasksNode.findall('Task'):
        self.numberOfTasks += 1    

  def parseStaff(self):
    
    #employeesNode = root.find('Employees')
    
    #for employee in employeesNode.findall('Employee'):
        #self.employees.append(employee.attrib['ID'])
    
    #return

    #ID, MinTotalMinutes, MaxTotalMinutes
    for employee in root.findall('./Contracts/Contract'):
        employeeID = employee.attrib['ID']
        if(employeeID!='All'):
            employeeID = int(employeeID)
            minTotalMinutes = int(employee.find('.//Min/Count').text)
            maxTotalMinutes = int(employee.find('.//Max/Count').text)
            self.employees.append(Employee(employeeID,minTotalMinutes,maxTotalMinutes))
    #print(self.employees)


  def parseCover(self):
      # Day, Time, TaskID, Min, Max
      #1,06:00-06:15,1,1,1
    self.numberOfCovs = 0
    for cover in root.findall('./CoverRequirements/Cov'):
        dayStartStr = cover.attrib['start']
        datetimeStart = datetime.strptime(dayStartStr, '%Y-%m-%dT%H:%M:%S')

        dayEndStr = cover.attrib['end']
        datetimeEnd = datetime.strptime(dayStartStr, '%Y-%m-%dT%H:%M:%S')
        
        day = datetimeStart.day
    
        #print(x)
        timeStart = cover.attrib['start']
        timeStart = cover.attrib['end']
        taskID = int(cover.attrib['task'])
        minNrEmployees = int(cover.find('Min').text)
        maxNrEmployees = int(cover.find('Max').text)

        print(day)
        #print(time)
        print(taskID)
        print(minNrEmployees)
        print(maxNrEmployees)
        #print(cover)
        #print(cover.tag)
        #print(cover.attrib)
        #print(cover.text)
        self.numberOfCovs += 1
    #print(self.numberOfCovs)        
    return



p1 = Parser(DATASET_PATH)
p1.parseXML()