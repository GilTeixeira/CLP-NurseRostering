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

    %write(SourcesSinks),nl,
    %write(Arcs),nl,
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
    create_arcs_per_shift(MinConsecutiveShifts,MinConsecutiveShifts,ArcsFinal),
    InitialArcs = [arc(w0,0,nw),arc(nw,0,nw),arc(MinConsecutiveShifts,0,nw)],
    append(ArcsW0,ArcsNW,ArcsAux),
    append(ArcsFinal,ArcsAux,ArcsAux2),
    append(InitialArcs,ArcsAux2,Arcs).
    %printBoardLine(Arcs).


create_arcs_min_consec_aux(MinConsecutiveShifts,Counter,Arcs):-
    CounterPlus1 is Counter+1,
    create_arcs_per_shift(Counter,CounterPlus1,ArcsW),
    append(ArcsW,ArcsRemain,Arcs),
    create_arcs_min_consec_aux(MinConsecutiveShifts,CounterPlus1,ArcsRemain).


% Constrain 8
% HC6: Minimum Consecutive Days Off

set_min_consec_days_off(Schedule):-
    findall([NurseID, MinConsecutiveDaysOff], nurse(NurseID,_,_, _,_,_,MinConsecutiveDaysOff,_), Nurses),
    maplist(set_min_consec_days_off_schedule(Schedule),Nurses).

set_min_consec_days_off_schedule(Schedule, [NurseID, MinConsecutiveDaysOff]):-
    nth1(NurseID,Schedule,NurseSchedule),
    set_min_consec_days_off_nurse(NurseSchedule,MinConsecutiveDaysOff).

set_min_consec_days_off_nurse(NurseSchedule, MinConsecutiveDaysOff):-
    create_arcs_min_consec_days_off(MinConsecutiveDaysOff,Arcs),
    create_sources_sinks_min_consec_days_off(MinConsecutiveDaysOff,SourcesSinks),
    %!,
    %write(SourcesSinks),nl,
    %write(Arcs),nl,
    automaton(NurseSchedule,SourcesSinks,Arcs).

create_sources_sinks_min_consec_days_off(MinConsecutiveDaysOff,SourcesSinks):-
    SourcesSinksAux = [source(nw),sink(nw),sink(w0)],
    findall(sink(ShiftDay),between(1,MinConsecutiveDaysOff,ShiftDay), Sinks),
    append(SourcesSinksAux,Sinks,SourcesSinks).


create_arcs_min_consec_days_off(MinConsecutiveDaysOff,Arcs):-
    create_arcs_min_consec_days_off_aux(MinConsecutiveDaysOff,1,Arcs).

create_arcs_min_consec_days_off_aux(MinConsecutiveDaysOff,MinConsecutiveDaysOff,Arcs):-
    create_arcs_per_shift(w0,w0,ArcsW0), 
    create_arcs_per_shift(nw,w0,ArcsNWToW0),
    create_arcs_per_shift(MinConsecutiveDaysOff,w0,ArcsLastDayToNW),
    InitialArcs = [arc(nw,0,nw),arc(w0,0,1),arc(MinConsecutiveDaysOff,0,MinConsecutiveDaysOff)],
    append(ArcsW0,ArcsNWToW0,ArcsAux),
    append(ArcsLastDayToNW,ArcsAux,ArcsAux2),
    append(InitialArcs,ArcsAux2,Arcs).
    %printBoardLine(Arcs).


create_arcs_min_consec_days_off_aux(MinConsecutiveShifts,Counter,Arcs):-
    CounterPlus1 is Counter+1,
    %ArcsW =  [arc(CounterPlus1,0,Counter+1)],
    %append(ArcsW,ArcsRemain,Arcs),
    Arcs = [arc(Counter,0,CounterPlus1)|ArcsRemain],
    create_arcs_min_consec_days_off_aux(MinConsecutiveShifts,CounterPlus1,ArcsRemain).



% Constrain 9
% HC9: Maximum Number of Weekends

create_arcs_per_shift_and_off(Source,Sink,Arcs):-
    get_shifts_list(ShiftsList),
    findall(arc(Source,ShiftID,Sink),member(ShiftID,[0|ShiftsList]), Arcs).

set_max_weekends(Schedule):-
    findall([NurseID, MaxWeekends], nurse(NurseID,_,_, _,_,_,_,MaxWeekends), Nurses),
    maplist(set_max_weekends_schedule(Schedule),Nurses).

set_max_weekends_schedule(Schedule, [NurseID, MaxWeekends]):-
    nth1(NurseID,Schedule,NurseSchedule),
    set_max_weekends_nurse(NurseSchedule,MaxWeekends).

create_arcs_with_counter(_,_,[],_,[]).

create_arcs_with_counter(Source,Sink,[ShiftID|ShiftsList],Counter,[Arc|Arcs]):-
    Arc = arc(Source,ShiftID,Sink,[Counter+1]),
    create_arcs_with_counter(Source,Sink,ShiftsList,Counter,Arcs).

/*
create_arcs_with_counter(Source,Sink,ShiftsList,Counter,Arcs):-
    findall(arc(Source,ShiftID,Sink,[Counter+1]),member(ShiftID,ShiftsList), Arcs).
*/
flatten(List, FlatList) :-
    flatten(List, [], FlatList0),
    !,
    FlatList = FlatList0.

flatten(Var, Tl, [Var|Tl]) :-
    var(Var),
    !.
flatten([], Tl, Tl) :- !.
flatten([Hd|Tl], Tail, List) :-
    !,
    flatten(Hd, FlatHeadTail, List),
    flatten(Tl, Tail, FlatHeadTail).
flatten(NonList, Tl, [NonList|Tl]).

set_max_weekends_nurse(NurseSchedule, MaxWeekends):-
    SourcesSinks = [source(suO),sink(suO),sink(suW)],
    create_arcs_per_shift_and_off(suO,m,Arcs1),
    create_arcs_per_shift_and_off(suW,m,Arcs2),
    create_arcs_per_shift_and_off(m,tu,Arcs3),
    create_arcs_per_shift_and_off(tu,w,Arcs4),
    create_arcs_per_shift_and_off(w,th,Arcs5),
    create_arcs_per_shift_and_off(th,f,Arcs6),
    create_arcs_per_shift(f,saW,Arcs7),
    Arcs8And9 = [arc(f,0,saO), arc(saO,0,suO)],

    get_shifts_list(ShiftsList),
    create_arcs_with_counter(saO,suW,ShiftsList,Counter,Arcs10), 
    create_arcs_with_counter(saW,suW,[0|ShiftsList],Counter,Arcs11),

    flatten([Arcs1,Arcs2,Arcs3,Arcs4,Arcs5,Arcs6,Arcs7,Arcs8And9,Arcs10,Arcs11],Arcs),



    %write(SourcesSinks),nl,
    %write(Arcs),nl,
    %trace,
    automaton(NurseSchedule,_,NurseSchedule,SourcesSinks,Arcs,[Counter],[0],[F]),
    %write(F),
    %automaton(NurseSchedule,SourcesSinks,Arcs),
    %nl, write('not here ??'), nl,
    %nl,
    F #=< MaxWeekends.


% Constrain 10
% HC10 : Requested days off

set_nurses_days_off(Schedule):-
    findall([NurseID, DaysOff], days_off(NurseID,DaysOff), Nurses),
    maplist(set_nurses_days_off_schedule(Schedule),Nurses).

set_nurses_days_off_schedule(Schedule, [NurseID, DaysOff]):-
    nth1(NurseID,Schedule,NurseSchedule),
    set_nurses_days_off_nurse(NurseSchedule,DaysOff).


set_nurses_days_off_nurse(NurseSchedule,DaysOff):-
    maplist(set_nurses_day_off_nurse(NurseSchedule),DaysOff).

set_nurses_day_off_nurse(NurseSchedule,DayOff):-
    %write(NurseSchedule),nl,
    %write(DayOff),nl,nl,
    DayOffnth1 is DayOff + 1, % DayOff starts at 0
    element(DayOffnth1,NurseSchedule,0).



% Soft Constrain 1
% SC1 : Shift on requests

%SECTION_SHIFT_ON_REQUESTS
%# EmployeeID, Day, ShiftID, Weight
%shift_on_request(1,5,2,1).

get_nurses_shift_on_penalty(Schedule, PenaltyShiftOn):-
    findall([NurseID,Day,ShiftID,Weight], shift_on_request(NurseID,Day,ShiftID,Weight), ShiftOnReqs),
    get_shift_on_penalty(Schedule,ShiftOnReqs,PenaltiesShiftOn),
    %write('PenaltiesShiftOn'),write(PenaltiesShiftOn),nl,
    sum(PenaltiesShiftOn,#=,PenaltyShiftOn).


get_shift_on_penalty(_,[],[]).
get_shift_on_penalty(Schedule,[[NurseID,Day,ShiftID,Weight]|ShiftOnReqs],[PenaltyShiftOn|PenaltiesShiftOn]):-
    nth1(NurseID,Schedule,NurseSchedule),
    DayShift is Day + 1, % Day starts at 0
    element(DayShift,NurseSchedule,ShiftAssigned),
    (ShiftAssigned #\= ShiftID) #=> PenaltyShiftOn #= Weight,
    (ShiftAssigned #= ShiftID) #=> PenaltyShiftOn #= 0,
    %logshifton(NurseID,Day,ShiftAssigned,ShiftID,PenaltyShiftOn),    
    get_shift_on_penalty(Schedule,ShiftOnReqs,PenaltiesShiftOn).

logshifton(_,_,_,_,0).
logshifton(NurseID,Day,ShiftAssigned,ShiftID,PenaltyShiftOn):-
    write('logshift on'),nl,
    write('NurseID '), write(NurseID),nl,
    write('Day '), write(Day),nl,
    write('ShiftAssigned '), write(ShiftAssigned),nl,
    write('ShiftID '), write(ShiftID),nl,
    write('PenaltyShiftOn '), write(PenaltyShiftOn),nl,
    nl,nl.


% Soft Constrain 2
% SC2 : Shift off requests


%SECTION_SHIFT_ON_REQUESTS
%# EmployeeID, Day, ShiftID, Weight
%shift_off_request(7,3,1,2).

get_nurses_shift_off_penalty(Schedule, PenaltyShiftOff):-
    findall([NurseID,Day,ShiftID,Weight], shift_off_request(NurseID,Day,ShiftID,Weight), ShiftOffReqs),
    %nl, write('len'),length(ShiftOffReqs,Len), write(Len),
    get_shift_off_penalty(Schedule,ShiftOffReqs,PenaltiesShiftOff),
    %write('PenaltiesShiftOff'),write(PenaltiesShiftOff),nl,
    sum(PenaltiesShiftOff,#=,PenaltyShiftOff).


get_shift_off_penalty(_,[],[]).
get_shift_off_penalty(Schedule,[[NurseID,Day,ShiftID,Weight]|ShiftOffReqs],[PenaltyShiftOff|PenaltiesShiftOff]):-
    nth1(NurseID,Schedule,NurseSchedule),
    DayShift is Day + 1, % Day starts at 0
    element(DayShift,NurseSchedule,ShiftAssigned),
    
    (ShiftAssigned #= ShiftID) #=> PenaltyShiftOff #= Weight,
    (ShiftAssigned #\= ShiftID) #=> PenaltyShiftOff #= 0,    
    %logshifton(NurseID,Day,ShiftAssigned,ShiftID,PenaltyShiftOff), 
    %write('next call - '),nl,write(Schedule),nl,write(ShiftOffReqs),nl,write(PenaltiesShiftOff),nl,
    get_shift_off_penalty(Schedule,ShiftOffReqs,PenaltiesShiftOff).

/*
    maplist(get_nurses_shift_on_requests_schedule(Schedule),Nurses).

get_nurses_shift_on_requests_schedule(Schedule, [NurseID,Day,ShiftID,Weight]]):-
    nth1(NurseID,Schedule,NurseSchedule),
    set_nurses_days_off_nurse(NurseSchedule,DaysOff).
*/




% Soft Constrain 2
% SC3 : Coverage 


%SECTION_COVER
%# Day, ShiftID, Requirement, Weight for under, Weight for over
%cover(0,1,4,100,1).


get_cover_penalty(Schedule, PenaltyCover):-
    transpose(Schedule,ScheduleTranspose),
    get_cover_penalty_all_days(ScheduleTranspose, 0, PenaltiesCover),
    sum(PenaltiesCover,#=,PenaltyCover).

get_cover_penalty_all_days([], _, []).
get_cover_penalty_all_days([ScheduleDay|ScheduleRemain], Day, [PenaltyCoverDay|PenaltiesCover]):-
    get_cover_penalty_day(ScheduleDay, Day, PenaltyCoverDay),
    NextDay is Day + 1,
    get_cover_penalty_all_days(ScheduleRemain, NextDay, PenaltiesCover).


get_cover_penalty_day(ScheduleDay, Day, PenaltyDayCover):-
    findall([ShiftID,Requirement,WeightUnder,WeightOver], cover(Day,ShiftID,Requirement,WeightUnder,WeightOver), Covers),
    length(Covers, NShifts),
    length(ShiftsCounter, NShifts),
    create_global_cardinal_cover(Covers,ShiftsCounter,Vals),
    global_cardinality(ScheduleDay,[0-_|Vals]),
    %nl,nl,nl,write('day '),write(Day),
    get_penalty_day_cover(Covers, Vals, PenaltiesCover),

    sum(PenaltiesCover,#=,PenaltyDayCover).
    %,
    %write(Vals),nl,nl.


create_global_cardinal_cover([],[],[]).
create_global_cardinal_cover([[ShiftID|_]|Covers],[ShiftCounter|ShiftsCounter],[Val|Vals]):-
    Val = ShiftID-ShiftCounter,
    create_global_cardinal_cover(Covers,ShiftsCounter,Vals).


get_penalty_day_cover([], [], []).
get_penalty_day_cover([[ShiftID,Requirement,WeightUnder,WeightOver]|Covers], [ShiftID-ShiftCounter|Vals], [PenaltyCover|PenaltiesCover]):-
    %write('sc '), write(ShiftCounter), nl,
    %write('rq '), write(Requirement), nl,
    (ShiftCounter #> Requirement) #=> (Dif #= ShiftCounter - Requirement #/\ PenaltyCover #= WeightOver * Dif),
    (ShiftCounter #< Requirement) #=> (Dif #= Requirement - ShiftCounter #/\ PenaltyCover #= WeightUnder * Dif), 
    (ShiftCounter #= Requirement) #=> PenaltyCover #= 0,
    %logshiftcover(ShiftID,Requirement,PenaltyCover),   
    %write('pc '), write(PenaltyCover), nl,nl,
    get_penalty_day_cover(Covers, Vals, PenaltiesCover).


logshiftcover(_,_,0).
logshiftcover(ShiftID,Requirement,PenaltyCover):-
    write('logshift on'),nl,
    write('ShiftID '), write(ShiftID),nl,
    write('Requirement '), write(Requirement),nl,
    write('PenaltyCover '), write(PenaltyCover),nl,
    nl,nl.


%%%%%%%%%%%%

/*
get_cover_penalty_day(ScheduleDay, Day, PenaltyDayCover):-
    findall([ShiftID,Requirement,WeightUnder,WeightOver], cover(Day,ShiftID,Requirement,WeightUnder,WeightOver), Covers),
    length(Covers, NShifts),
    length(ShiftsCounter, NShifts),
    create_global_cardinal_cover(Covers,ShiftsCounter,Vals,PenaltiesCover),
    sum(PenaltiesCover,#=,PenaltyDayCover),
    global_cardinality(ScheduleDay,[0-_|Vals]),
    write(Vals),nl,nl.


create_global_cardinal_cover([],[],[],[]).
create_global_cardinal_cover([[ShiftID,Requirement,WeightUnder,WeightOver]|Covers],[ShiftCounter|ShiftsCounter],[Val|Vals],[PenaltyCover|PenaltiesCover]):-
    Val = ShiftID-ShiftCounter,
    (ShiftCounter #> Requirement) #=> PenaltyCover #= WeightOver,
    (ShiftCounter #< Requirement) #=> PenaltyCover #= WeightUnder,
    (ShiftCounter #= 0) #=> PenaltyCover #= 0,    
    create_global_cardinal_cover(Covers,ShiftsCounter,Vals,PenaltiesCover).


*/
/*

create_global_cardinal_vals([],[],[]).
create_global_cardinal_vals([(ShiftID, MaxShift)|MaxShifts],[ShiftCounter|ShiftsCounter],[Val|Vals]):-
    Val = ShiftID-ShiftCounter,
    ShiftCounter #=< MaxShift,
    create_global_cardinal_vals(MaxShifts,ShiftsCounter,Vals).
*/


%set_nurses_days_off(Schedule):-
    %forall(days_off(NurseID,DaysOff), set_nurse_days_off(NurseID,DaysOff,Schedule)).

%set_nurse_days_off(NurseID, [], Schedule).
%set_nurse_days_off(NurseID, [DayOff|DaysOff], Schedule):-

    % TODO
%    set_nurse_days_off(NurseID, DaysOff, Schedule).


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
