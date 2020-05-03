% Constrain 1
% HC1 : Maximum one shift per day
% Already Defined in the domain 


% Constrain 2
% HC2 : Shift rotations
set_shift_rotations(Schedule):-
    findall([ShiftID, ImpossibleShifts], shift(ShiftID,_,ImpossibleShifts), Shifts),
    maplist(set_shift_rotation_schedule(Schedule),Shifts).
 
set_shift_rotation_schedule([],_).
set_shift_rotation_schedule(_,[_,[]]). % Otimization 4.2.2
set_shift_rotation_schedule([ScheduleNurse|ScheduleRemain], [ShiftID,ImpossibleShifts]):-
    set_shift_rotation_nurse(ScheduleNurse, [ShiftID,ImpossibleShifts]),
    set_shift_rotation_schedule(ScheduleRemain, [ShiftID,ImpossibleShifts]).

% TODO : Optimization FDSEt from prologer
set_shift_rotation_nurse([_],_).
set_shift_rotation_nurse([ScheduleDay,ScheduleNextDay|ScheduleNurseRemain], [ShiftID, ImpossibleShifts]):-
    list_to_fdset(ImpossibleShifts,ImpossibleShiftsFDSet),
    %write(ImpossibleShifts),write(ImpossibleShiftsFDSet),nl,
    (ScheduleDay #= ShiftID) #=> #\(ScheduleNextDay in_set ImpossibleShiftsFDSet),
    set_shift_rotation_nurse([ScheduleNextDay|ScheduleNurseRemain], [ShiftID, ImpossibleShifts]).



% TODO: Otimization when nurse can only do 1 shift
% ID, MaxShifts, MaxTotalMinutes, MinTotalMinutes, MaxConsecutiveShifts, MinConsecutiveShifts, MinConsecutiveDaysOff, MaxWeekends
% Constrain 3
% HC3: Maximum number of shifts
set_max_shifts(Schedule):-
    findall([NurseID, MaxShifts,MaxTotalMinutes, MinTotalMinutes], nurse(NurseID,MaxShifts,MaxTotalMinutes, MinTotalMinutes,_,_,_,_), Nurses),
    maplist(set_max_shifts_schedule(Schedule),Nurses).

set_max_shifts_schedule(Schedule, [NurseID,MaxShifts,MaxTotalMinutes, MinTotalMinutes]):-
    nth1(NurseID,Schedule,NurseSchedule),
    length(MaxShifts, NShifts),
    length(ShiftsCounter, NShifts),
    
    % Constrain 3
    create_global_cardinal_vals(MaxShifts,ShiftsCounter,Vals),
    global_cardinality(NurseSchedule, [0-_|Vals]), % nurses can have no shift _ times

    % Constrain 4 & 5
    get_shifts_duration(ShiftsDuration),
    scalar_product(ShiftsDuration, ShiftsCounter, #=<, MaxTotalMinutes),
    scalar_product(ShiftsDuration, ShiftsCounter, #>=, MinTotalMinutes).



create_global_cardinal_vals([],[],[]).
create_global_cardinal_vals([(ShiftID, MaxShift)|MaxShifts],[ShiftCounter|ShiftsCounter],[Val|Vals]):-
    Val = ShiftID-ShiftCounter,
    ShiftCounter #=< MaxShift,
    create_global_cardinal_vals(MaxShifts,ShiftsCounter,Vals).


% Constrain 6
% HC6: Maximum consecutive shifts
set_max_consec_shifts(Schedule):-
    findall([NurseID, MaxConsecutiveShifts], nurse(NurseID,_,_, _,MaxConsecutiveShifts,_,_,_), Nurses),
    maplist(set_max_consec_shifts_schedule(Schedule),Nurses).

set_max_consec_shifts_schedule(Schedule, [NurseID, MaxConsecutiveShifts]):-
    nth1(NurseID,Schedule,NurseSchedule),
    set_max_consec_shifts_nurse(NurseSchedule,MaxConsecutiveShifts).

exactly(_, [], 0).
exactly(X, [Y|L], N) :-
    X #= Y #<=> B,
    N #= M+B,
    exactly(X, L, M).

set_max_consec_shifts_nurse(NurseSchedule,MaxConsecutiveShifts):-
    length(NurseSchedule, MaxConsecutiveShifts).


set_max_consec_shifts_nurse(NurseSchedule,MaxConsecutiveShifts):-
    prefix_length(NurseSchedule, FirstDays, MaxConsecutiveShifts),
    nth0(MaxConsecutiveShifts,NurseSchedule,NextDay),
    exactly(0,FirstDays,NumberDaysOff),
    (NumberDaysOff #= 0) #=> (NextDay #=0),
    NurseSchedule = [_|ScheduleNurseRemain],
    set_max_consec_shifts_nurse(ScheduleNurseRemain,MaxConsecutiveShifts).





% Constrain 7
% HC6: Minimum consecutive shifts

set_min_consec_shifts(Schedule):-
    findall([NurseID, MinConsecutiveShifts], nurse(NurseID,_,_, _,_,MinConsecutiveShifts,_,_), Nurses),
    maplist(set_min_consec_shifts_schedule(Schedule),Nurses).

set_min_consec_shifts_schedule(Schedule, [NurseID, MinConsecutiveShifts]):-
    nth1(NurseID,Schedule,NurseSchedule),
    set_min_consec_shifts_nurse(NurseSchedule,MinConsecutiveShifts).

set_min_consec_shifts_nurse(NurseSchedule, MinConsecutiveShifts):-
    create_arcs_min_consec(MinConsecutiveShifts,Arcs),
    create_sources_sinks_min_consec(MinConsecutiveShifts,SourcesSinks),
    %!,
    automaton(NurseSchedule,SourcesSinks,Arcs).

create_sources_sinks_min_consec(MinConsecutiveShifts,SourcesSinks):-
    SourcesSinksAux = [source(w0),sink(w0),sink(nw)],
    findall(sink(ShiftDay),between(1,MinConsecutiveShifts,ShiftDay), Sinks),
    append(SourcesSinksAux,Sinks,SourcesSinks).

create_arcs_per_shift(Source,Sink,Arcs):-
    get_shifts_list(ShiftsList),
    findall(arc(Source,ShiftID,Sink),member(ShiftID,ShiftsList), Arcs).

create_arcs_min_consec(MinConsecutiveShifts,Arcs):-
    create_arcs_min_consec_aux(MinConsecutiveShifts,1,Arcs).

create_arcs_min_consec_aux(MinConsecutiveShifts,MinConsecutiveShifts,Arcs):-
    create_arcs_per_shift(w0,w0,ArcsW0), 
    create_arcs_per_shift(nw,1,ArcsNW),
    InitialArcs = [arc(w0,0,nw),arc(nw,0,nw),arc(MinConsecutiveShifts,0,nw)],
    append(ArcsW0,ArcsNW,ArcsAux),
    append(InitialArcs,ArcsAux,Arcs).
    %printBoardLine(Arcs).


create_arcs_min_consec_aux(MinConsecutiveShifts,Counter,Arcs):-
    CounterPlus1 is Counter+1,
    create_arcs_per_shift(Counter,CounterPlus1,ArcsW),
    append(ArcsW,ArcsRemain,Arcs),
    create_arcs_min_consec_aux(MinConsecutiveShifts,CounterPlus1,ArcsRemain).




/*
automaton is the answer
set_min_consec_shifts(Schedule):-
    findall([NurseID, MinConsecutiveShifts], nurse(NurseID,_,_, _,_,MinConsecutiveShifts,_,_), Nurses),
    maplist(set_min_consec_shifts_schedule(Schedule),Nurses).

set_min_consec_shifts_schedule(Schedule, [NurseID, MinConsecutiveShifts]):-
    nth1(NurseID,Schedule,NurseSchedule),
    set_min_consec_shifts_nurse(NurseSchedule,MinConsecutiveShifts).

set_min_consec_shifts_nurse(NurseSchedule,MinConsecutiveShifts):-
    length(NurseSchedule, MinConsecutiveShifts).


set_min_consec_shifts_nurse(NurseSchedule,MaxConsecutiveShifts):-
    prefix_length(NurseSchedule, FirstDays, MaxConsecutiveShifts),
    nth0(MaxConsecutiveShifts,NurseSchedule,NextDay),
    exactly(0,FirstDays,NumberDaysOff),
    (NumberDaysOff #= 0) #=> (NextDay #=0),
    NurseSchedule = [_|ScheduleNurseRemain],
    set_max_consec_shifts_nurse(ScheduleNurseRemain,MaxConsecutiveShifts).



*/

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



% Constrain 5
% HC5: Minimum total minutes
%set_min_minutes(Schedule):-
    % global cardinalityt of each type of shift
%    nl.



% Constrain 10
% HC10 : Requested days off
%set_nurses_days_off(Schedule):-
    %forall(days_off(NurseID,DaysOff), set_nurse_days_off(NurseID,DaysOff,Schedule)).

%set_nurse_days_off(NurseID, [], Schedule).
%set_nurse_days_off(NurseID, [DayOff|DaysOff], Schedule):-

    % TODO
%    set_nurse_days_off(NurseID, DaysOff, Schedule).
