% Autogenerated data file from text file: 'Dataset/Instance2.txt'

% SECTION_HORIZON
% The horizon length in days
number_of_days(14).

% SECTION_SHIFTS
% ShiftID, Length in mins, List of Shifts which cannot follow this shift
shift(1,480,[]).
shift(2,480,[1]).


% SECTION_STAFF
% NurseID, List of (ShiftID,MaxShifts), MaxTotalMinutes, MinTotalMinutes, MaxConsecutiveShifts, MinConsecutiveShifts, MinConsecutiveDaysOff, MaxWeekends
nurse(1,[(1, 14), (2, 14)],4320,3360,5,2,2,1).
nurse(2,[(1, 14), (2, 14)],4320,3360,5,2,2,1).
nurse(3,[(1, 14), (2, 14)],4320,3360,5,2,2,1).
nurse(4,[(1, 14), (2, 0)],4320,3360,5,2,2,1).
nurse(5,[(1, 0), (2, 14)],4320,3360,5,2,2,1).
nurse(6,[(1, 14), (2, 14)],4320,3360,5,2,2,1).
nurse(7,[(1, 14), (2, 14)],4320,3360,5,2,2,1).
nurse(8,[(1, 14), (2, 14)],4320,3360,5,2,2,1).
nurse(9,[(1, 14), (2, 14)],4320,3360,5,2,2,1).
nurse(10,[(1, 14), (2, 14)],4320,3360,5,2,2,1).
nurse(11,[(1, 0), (2, 14)],2160,1200,5,1,1,1).
nurse(12,[(1, 0), (2, 14)],2160,1200,5,1,1,1).
nurse(13,[(1, 14), (2, 14)],2160,1200,5,1,1,1).
nurse(14,[(1, 14), (2, 14)],2160,1200,5,1,1,1).


% SECTION_DAYS_OFF
% NurseID, List of DayIndexes (start at zero)
days_off(1,[3]).
days_off(2,[1]).
days_off(3,[2]).
days_off(4,[12]).
days_off(5,[1]).
days_off(6,[13]).
days_off(7,[9]).
days_off(8,[3]).
days_off(9,[0]).
days_off(10,[8]).
days_off(11,[5]).
days_off(12,[2]).
days_off(13,[8]).
days_off(14,[6]).


% SECTION_SHIFT_ON_REQUESTS
% NurseID, Day, ShiftID, Weight
shift_on_request(1,5,2,1).
shift_on_request(1,6,2,1).
shift_on_request(1,7,2,1).
shift_on_request(1,8,2,1).
shift_on_request(1,9,2,1).
shift_on_request(2,7,1,1).
shift_on_request(2,8,1,1).
shift_on_request(2,9,1,1).
shift_on_request(2,10,1,1).
shift_on_request(3,8,1,1).
shift_on_request(3,9,1,1).
shift_on_request(3,10,1,1).
shift_on_request(3,11,1,1).
shift_on_request(4,1,1,1).
shift_on_request(4,2,1,1).
shift_on_request(4,3,1,1).
shift_on_request(5,3,2,1).
shift_on_request(5,4,2,1).
shift_on_request(5,5,2,1).
shift_on_request(5,6,2,1).
shift_on_request(5,7,2,1).
shift_on_request(5,12,2,2).
shift_on_request(5,13,2,2).
shift_on_request(6,3,2,3).
shift_on_request(6,4,2,3).
shift_on_request(6,5,2,3).
shift_on_request(9,2,2,3).
shift_on_request(9,3,2,3).
shift_on_request(9,12,1,2).
shift_on_request(10,11,2,3).
shift_on_request(11,7,2,1).
shift_on_request(11,8,2,1).
shift_on_request(11,9,2,1).
shift_on_request(12,3,2,1).
shift_on_request(12,4,2,1).
shift_on_request(12,10,2,3).
shift_on_request(12,11,2,3).
shift_on_request(12,12,2,3).
shift_on_request(12,13,2,3).
shift_on_request(13,3,2,1).
shift_on_request(13,4,2,1).
shift_on_request(13,5,2,1).
shift_on_request(13,6,2,1).
shift_on_request(13,7,2,1).
shift_on_request(14,0,1,2).
shift_on_request(14,1,1,2).
shift_on_request(14,2,1,2).
shift_on_request(14,8,1,3).
shift_on_request(14,9,1,3).
shift_on_request(14,10,1,3).


% SECTION_SHIFT_OFF_REQUESTS
% NurseID, Day, ShiftID, Weight
shift_off_request(7,3,1,2).
shift_off_request(7,4,1,2).
shift_off_request(7,5,1,2).
shift_off_request(7,6,1,2).
shift_off_request(7,7,1,2).
shift_off_request(8,1,2,2).
shift_off_request(10,1,1,1).
shift_off_request(10,2,1,1).
shift_off_request(10,3,1,1).
shift_off_request(10,4,1,1).
shift_off_request(10,5,1,1).
shift_off_request(13,11,2,1).


% SECTION_COVER
%  Day, ShiftID, Requirement, Weight for under, Weight for over
cover(0,1,4,100,1).
cover(0,2,4,100,1).
cover(1,1,4,100,1).
cover(1,2,3,100,1).
cover(2,1,3,100,1).
cover(2,2,6,100,1).
cover(3,1,5,100,1).
cover(3,2,4,100,1).
cover(4,1,3,100,1).
cover(4,2,4,100,1).
cover(5,1,5,100,1).
cover(5,2,5,100,1).
cover(6,1,5,100,1).
cover(6,2,5,100,1).
cover(7,1,3,100,1).
cover(7,2,2,100,1).
cover(8,1,4,100,1).
cover(8,2,4,100,1).
cover(9,1,4,100,1).
cover(9,2,4,100,1).
cover(10,1,4,100,1).
cover(10,2,3,100,1).
cover(11,1,2,100,1).
cover(11,2,3,100,1).
cover(12,1,4,100,1).
cover(12,2,3,100,1).
cover(13,1,3,100,1).
cover(13,2,5,100,1).

