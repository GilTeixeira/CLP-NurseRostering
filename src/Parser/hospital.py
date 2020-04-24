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
        self.shiftOnRequests = []
        self.shiftOffRequests = []

class Hospital:
     def __init__(self):
        self.numberOfDays = 0
        self.minRestTime = 0
        self.shifts = []
        self.nurses = []
        self.covers = []