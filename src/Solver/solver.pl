:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(aggregate)).
:- use_module(library(between)).

:- include('statistics.pl').
:- include('settings.pl').
:- include('matrixUtils.pl').
:- include('queries.pl').
:- include('constrains.pl').


sol2([
    [2,2,2,0,0,2,2,2,2,2,0,0,0,0],
	[2,0,0,1,1,0,0,1,1,1,0,0,1,1],
	[2,0,0,1,1,1,1,0,0,1,1,1,0,0],
	[1,1,1,1,1,0,0,0,1,1,1,0,0,1],
	[2,0,0,2,2,2,2,2,0,0,2,2,0,0],
	[0,0,2,2,2,2,2,0,0,2,2,2,0,0],
	[1,1,1,1,2,0,0,0,0,0,1,1,1,2],
	[1,1,2,0,0,1,1,1,2,2,0,0,0,0],
	[0,2,2,2,2,0,0,1,1,2,0,0,1,2],
	[1,2,2,2,0,0,0,0,0,1,1,2,2,2],
	[0,0,2,0,0,0,0,0,2,0,0,0,2,2],
	[0,0,0,0,0,0,0,0,2,0,2,0,2,2],
	[0,1,0,1,0,2,2,0,0,0,0,0,0,0],
	[0,0,1,0,0,0,0,0,1,0,0,0,1,1]]).

%nurse_problem_solver(Schedule) 
solver(Schedule):-	

	% Variables
	number_of_days(NDays),
	%write('Ndays: '), write(NDays),nl,

	get_number_shifts(NShifts), % TODO: change to assertz
	%write('NShifts: '), write(ListOfShiftIDs), write(NShifts),nl,

	get_number_nurses(NNurses), % TODO: change to assertz
	%write('NNurses: '),write(ListOfNurseIDs), write(NNurses),nl,

	gen_matrix(NNurses, NDays, Schedule),

	% Variables Domain
	% TODO: FOr every nurse get shifts (s)he can do
	term_variables(Schedule, Vars),
	domain(Vars,0,NShifts),
	
	%length(Vars,NVars),
	%write(NVars),

	apply_hard_constrains(Schedule),
	apply_soft_constrains(Schedule,Penalties,[PenaltyShiftOn,PenaltyShiftOff,PenaltyCover]),

	search(Schedule,Vars,Penalties,[PenaltyShiftOn,PenaltyShiftOff,PenaltyCover]),
	
	FileName = 'sol.json',
	write_results_to_file(Schedule,FileName).



apply_hard_constrains(Schedule):-
	nl,nl, write('Applying Hard Constrains...'), nl,
	% Constrain 1
	% HC1 : Maximum one shift per day
	% Already Defined in the domain
	write('HC1 Applied.'), nl,
	
	% Constrain 2
	% HC2 : Shift rotations
	set_shift_rotations(Schedule),
	write('HC2 Applied.'), nl,
	
	% Constrain 3
	% HC3: Maximum number of shifts
	set_max_shifts(Schedule),
	write('HC3 Applied.'), nl,
	 
	
	% Constrain 4
	% HC4 : Maximum total minutes
	write('HC4 Applied.'), nl, 
	
	% Constrain 5
	% HC5 : Minimum total minutes 
	%set_min_minutes(Schedule),
	write('HC5 Applied.'), nl, 
	
	% Constrain 6
	% HC6 : Maximum consecutive shifts 
	set_max_consec_shifts(Schedule),
	write('HC6 Applied.'), nl, 
	
	% Constrain 7
	% HC7 : Minimum consecutive shifts 
	set_min_consec_shifts(Schedule),
	write('HC7 Applied.'), nl, 
	
	% Constrain 8
	% HC8 : Minimum consecutive days off
	set_min_consec_days_off(Schedule),
	write('HC8 Applied.'), nl, 
	
	% Constrain 9
	% HC9 : Maximum number of weekends 
	set_max_weekends(Schedule),
	write('HC9 Applied.'), nl, 
	
	% Constrain 10
	% HC10 : Requested days off
	set_nurses_days_off(Schedule),
	write('HC10 Applied.'), nl,

	write('Applied all Hard Constrains.'), nl.


apply_soft_constrains(Schedule,Penalties,PenaltiesList):-
	nl,nl, write('Applying Soft Constrains...'), nl,

	% SC 1	
	get_nurses_shift_on_penalty(Schedule, PenaltyShiftOn),
	write('SC1 Applied.'), nl,

	% SC 2	
	get_nurses_shift_off_penalty(Schedule, PenaltyShiftOff),
	write('SC2 Applied.'), nl,

	% SC 3
	get_cover_penalty(Schedule, PenaltyCover),
	write('SC3 Applied.'), nl,

	PenaltiesList = [PenaltyShiftOn,PenaltyShiftOff,PenaltyCover],
	sum(PenaltiesList,#=,Penalties),

	write('Applied all Soft Constrains.'), nl,
	write('Applied all Constrains.'), nl.



search(Schedule,Vars,Penalties,[PenaltyShiftOn,PenaltyShiftOff,PenaltyCover]):-
	write('Beggining Search...'), nl,
	
	!,
	%% Search
	TIME_OUT_MIN = 1,
	TIME_OUT_MILISECONDS is TIME_OUT_MIN * 60 * 100,
	%TIME_OUT_MILISECONDS is 1000,
	labeling([minimize(Penalties),time_out(TIME_OUT_MILISECONDS,F)],Vars),
	write('Finished Search.'), nl,

	write('Penalty Shift On:  '), write(PenaltyShiftOn),nl,
	write('Penalty Shift Off: '), write(PenaltyShiftOff),nl,
	write('Penalty Cover:     '), write(PenaltyCover),nl,
	write('Penalty Total:     '), write(Penalties),nl,
	write('Flag:             '), write(F),
	nl,
	nl,
	%displayMat(Schedule),	
	nl.

write_results_to_file(Schedule,FileName):-
	atom_concat('Temp/',FileName,FilePath),
	open(FilePath,write,Out),
	write(Out,'{\n'),

	write(Out,'"schedule":'),
	write(Out,Schedule),
	write(Out,',\n'),

	write(Out,'"time":12'),

	write(Out,'\n}'),

    close(Out). 


/*
 main:-
    reset_timer,
    magicSnailSolver(SpiralList),
    write(SpiralList),nl,
    print_time.
*/