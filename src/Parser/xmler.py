import xml.etree.ElementTree as ET

class XMLer:
    def __init__(self, filepath, hospital, schedule):
        self.filepath = filepath
        self.hospital = hospital
        self.schedule = schedule

    def createXMLFile(self, schedProbPath): 
        data = ET.Element('Roster') # create the file structure

        schedFile = ET.SubElement(data, 'SchedulingPeriodFile')
        schedFile.text = schedProbPath

        for employeeHospital, employeeSchedule in zip(self.hospital.nurses, self.schedule):
            employee = ET.SubElement(data, 'Employee')
            employee.set('ID',employeeHospital.nurseID)
            for day, shift in enumerate(employeeSchedule):
                if shift == 0 : continue
                shiftID = self.hospital.getShiftID(shift)

                assign = ET.SubElement(employee, 'Assign')
                dayElem = ET.SubElement(assign, 'Day')
                shiftElem = ET.SubElement(assign, 'Shift')

                dayElem.text = str(day)
                shiftElem.text = str(shiftID)

        mydata = ET.tostring(data)
        myfile = open(self.filepath, "wb")
      
        myfile.write(mydata)

        print(self.schedule)
