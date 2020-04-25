% Constrain 10
% HC10 : Requested days off
%set_nurses_days_off(Schedule):-
    %forall(days_off(NurseID,DaysOff), set_nurse_days_off(NurseID,DaysOff,Schedule)).

%set_nurse_days_off(NurseID, [], Schedule).
%set_nurse_days_off(NurseID, [DayOff|DaysOff], Schedule):-

    % TODO
%    set_nurse_days_off(NurseID, DaysOff, Schedule).


% Constrain 2
% HC2 : Shift rotations
set_shift_rotations(Schedule):-
    forall(shift(ShiftID,_,ImpossibleShifts), set_shift_rotation_schedule(ShiftID,ImpossibleShifts,Schedule)).

set_shift_rotation_schedule(_,_,[]).
set_shift_rotation_schedule(ShiftID,ImpossibleShifts,[ScheduleNurse|ScheduleRemain]):-
    set_shift_rotation_nurse(ShiftID,ImpossibleShifts,ScheduleNurse),
    set_shift_rotation_schedule(ShiftID,ImpossibleShifts,ScheduleRemain).


set_shift_rotation_nurse(_, _, [_]).
set_shift_rotation_nurse(ShiftID, ImpossibleShifts, [ScheduleDay,ScheduleNextDay|ScheduleNurseRemain]):-
    %write(ScheduleDay), nl,
    %write(ShiftID), nl,
    %write(ScheduleNextDay), nl,
    %write(ImpossibleShifts), nl,
    list_to_fdset(ImpossibleShifts,ImpossibleShiftsFDSet),
    (ScheduleDay #= ShiftID) #=> #\(ScheduleNextDay in_set ImpossibleShiftsFDSet),
    set_shift_rotation_nurse(ShiftID, ImpossibleShifts, [ScheduleNextDay|ScheduleNurseRemain]).
