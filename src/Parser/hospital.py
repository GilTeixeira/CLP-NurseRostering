class Shift:
    lastID = 0
    def __init__(self, shiftID, duration, shiftsIDCantFollow):
        self.shiftID = shiftID
        self.shiftIntID = Shift.lastID
        self.duration = duration
        self.shiftsIDCantFollow = shiftsIDCantFollow # Shifts which cannot follow this shift

        Shift.lastID += 1

class Request:
    lastID = 0
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
    lastID = 0
    def __init__(self, nurseID, maxShifts,
    maxTotalMinutes, minTotalMinutes, maxConsecutiveShifts, 
    minConsecutiveShifts, minConsecutiveDaysOff, maxWeekends):
        self.nurseID = nurseID
        self.nurseIntID = Nurse.lastID
        self.maxShifts = maxShifts
        self.maxTotalMinutes = maxTotalMinutes
        self.minTotalMinutes = minTotalMinutes
        self.maxConsecutiveShifts = maxConsecutiveShifts
        self.minConsecutiveShifts = minConsecutiveShifts
        self.minConsecutiveDaysOff = minConsecutiveDaysOff
        self.maxWeekends = maxWeekends
        self.daysOff = []
        self.shiftOnRequests = []
        self.shiftOffRequests = []
        Nurse.lastID += 1

    def getMaxShiftsWithIntID(self):
        return


class Hospital:
    def __init__(self):
        self.numberOfDays = 0
        self.minRestTime = 0
        self.shifts = []
        self.nurses = []
        self.covers = []

    def getNurseIntID(self,nurseID):
        for nurse in self.nurses:
            if nurse.nurseID == nurseID:
                return nurse.nurseIntID

    def getShiftIntID(self,shiftID):
        for shift in self.shifts:
            if shift.shiftID == shiftID:
                return shift.shiftIntID

    def getShiftsIntID(self,shiftsID):
        return [self.getShiftIntID(shiftID) for shiftID in shiftsID]
