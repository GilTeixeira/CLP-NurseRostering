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
    setof([ShiftID, ImpossibleShifts], shift(ShiftID,_,ImpossibleShifts), Shifts),
    %write(Shifts),nl,
    maplist(set_shift_rotation_schedule(Schedule),Shifts).
    %forall(shift(ShiftID,_,ImpossibleShifts), set_shift_rotation_schedule(ShiftID,ImpossibleShifts,Schedule)).

set_shift_rotation_schedule([],_).
set_shift_rotation_schedule(_,[_,[]]). % Otimization 4.2.2
set_shift_rotation_schedule([ScheduleNurse|ScheduleRemain], [ShiftID,ImpossibleShifts]):-
    %length([ScheduleNurse|ScheduleRemain], N),    
    %write(N),nl,
    %write([ShiftID,ImpossibleShifts]),nl,nl,nl,
    set_shift_rotation_nurse(ScheduleNurse, [ShiftID,ImpossibleShifts]),
    set_shift_rotation_schedule(ScheduleRemain, [ShiftID,ImpossibleShifts]).

% TODO : Optimization FDSEt from prologer
set_shift_rotation_nurse([_],_).
set_shift_rotation_nurse([ScheduleDay,ScheduleNextDay|ScheduleNurseRemain], [ShiftID, ImpossibleShifts]):-
    %write(ScheduleDay), nl,
    %write(ShiftID), nl,
    %write(ScheduleNextDay), nl,
    %write(ImpossibleShifts), nl,
    list_to_fdset(ImpossibleShifts,ImpossibleShiftsFDSet),
    (ScheduleDay #= ShiftID) #=> #\(ScheduleNextDay in_set ImpossibleShiftsFDSet),
    set_shift_rotation_nurse([ScheduleNextDay|ScheduleNurseRemain], [ShiftID, ImpossibleShifts]).



% TODO: Otimization when nurse can only do 1 shift
% ID, MaxShifts, MaxTotalMinutes, MinTotalMinutes, MaxConsecutiveShifts, MinConsecutiveShifts, MinConsecutiveDaysOff, MaxWeekends
% Constrain 3
% HC3: Maximum number of shifts
set_max_shifts(Schedule):-
    setof([NurseID, MaxShifts], nurse(NurseID,MaxShifts,_,_,_,_,_,_), Nurses),
    maplist(set_max_shifts_schedule(Schedule),Nurses).

set_max_shifts_schedule(Schedule, [NurseID,MaxShifts]):-
    nth1(NurseID,Schedule,NurseSchedule),
    %get_number_shifts(NShifts),
   %get_shifts_list(ShiftsList),
    create_global_cardinal_vals(MaxShifts,Vals),
    %write(Vals),
    global_cardinality(NurseSchedule, Vals).


create_global_cardinal_vals([],[]).
create_global_cardinal_vals([(ShiftID, MaxShift)|MaxShifts],[Val|Vals]):-
    Val = ShiftID-V,
    V #=< MaxShift,
    create_global_cardinal_vals(MaxShifts,Vals).



%%% old c3
/*
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

*/