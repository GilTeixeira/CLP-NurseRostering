% Constrain 10
% HC10 : Requested days off
%set_nurses_days_off(Schedule):-
    %forall(days_off(NurseID,DaysOff), set_nurse_days_off(NurseID,DaysOff,Schedule)).

%set_nurse_days_off(NurseID, [], Schedule).
%set_nurse_days_off(NurseID, [DayOff|DaysOff], Schedule):-

    % TODO
%    set_nurse_days_off(NurseID, DaysOff, Schedule).

% BIG PROBLEM !!!
% TODO: Not sure if forall or foreach


% Constrain 2
% HC2 : Shift rotations
set_shift_rotations(Schedule):-
    forall(shift(ShiftID,_,ImpossibleShifts), set_shift_rotation_schedule(ShiftID,ImpossibleShifts,Schedule)).

set_shift_rotation_schedule(_,_,[]).
set_shift_rotation_schedule(ShiftID,ImpossibleShifts,[ScheduleNurse|ScheduleRemain]):-
    set_shift_rotation_nurse(ShiftID,ImpossibleShifts,ScheduleNurse),
    set_shift_rotation_schedule(ShiftID,ImpossibleShifts,ScheduleRemain).

% TODO : Optimization FDSEt from prologer
set_shift_rotation_nurse(_, _, [_]).
set_shift_rotation_nurse(ShiftID, ImpossibleShifts, [ScheduleDay,ScheduleNextDay|ScheduleNurseRemain]):-
    %write(ScheduleDay), nl,
    %write(ShiftID), nl,
    %write(ScheduleNextDay), nl,
    %write(ImpossibleShifts), nl,
    list_to_fdset(ImpossibleShifts,ImpossibleShiftsFDSet),
    (ScheduleDay #= ShiftID) #=> #\(ScheduleNextDay in_set ImpossibleShiftsFDSet),
    set_shift_rotation_nurse(ShiftID, ImpossibleShifts, [ScheduleNextDay|ScheduleNurseRemain]).


% TODO: Otimization when nurse can only do 1 shift
% ID, MaxShifts, MaxTotalMinutes, MinTotalMinutes, MaxConsecutiveShifts, MinConsecutiveShifts, MinConsecutiveDaysOff, MaxWeekends
% Constrain 3
	% HC3: Maximum number of shifts
set_max_shifts(Schedule):-
    forall(shift(NurseID,MaxShifts,_,_,_,_,_,_), set_max_shifts_schedule(NurseID,MaxShifts,Schedule)). 
% TODO OPTIMIZATION:- find nurse schedule every time
set_max_shifts_schedule(NurseID,MaxShifts,Schedule):-


%[(1, 14), (2, 14)]
createListDiff(0,[],_).
createListDiff(NShifts,[ShiftID|ShiftsList],[ListHead|List]):-
    NShiftsMinus1 is NShifts - 1,
    ListHead = ShiftID-NShifts.
    createListDiff(NShiftsMinus1, ShiftsList, List).


set_max_shifts_schedule(NurseID,MaxShifts,Schedule):-
    nth1(NurseID,Schedule,NurseSchedule),
    get_number_shifts(NShifts),
    get_shifts_list(ShiftsList),

    length(Length, NShifts),
    global_cardinality(NurseSchedule).

