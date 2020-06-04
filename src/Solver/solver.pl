:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(aggregate)).
:- use_module(library(between)).

:- include('statistics.pl').
:- include('settings/settings.pl').
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


	domain_shifts(Schedule),
	
	%length(Vars,NVars),
	%write(NVars),

	apply_hard_constrains(Schedule),
	apply_soft_constrains(Schedule,Penalties,[PenaltyShiftOn,PenaltyShiftOff,PenaltyCover]),

	search(Vars,Penalties,[PenaltyShiftOn,PenaltyShiftOff,PenaltyCover],Flag),
	
	%FileName = 'sol.json',
	write_results_to_file(Schedule,Penalties,[PenaltyShiftOn,PenaltyShiftOff,PenaltyCover],Flag),
	displayMat(Schedule),	
	nl.



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



search(Vars,Penalties,[PenaltyShiftOn,PenaltyShiftOff,PenaltyCover],Flag):-
	write('Beggining Search...'), nl,
	
	!,
	%% Search
	search_time(SearchTimeSeconds),
	%TIME_OUT_MIN = 1,
	TIME_OUT_MILISECONDS is SearchTimeSeconds * 1000,
	%TIME_OUT_MILISECONDS is 1000,
	labeling_options(Options),
	AllOptions = [minimize(Penalties),time_out(TIME_OUT_MILISECONDS,Flag)|Options],
	labeling(AllOptions,Vars),
	write('Finished Search.'), nl,

	write('Penalty Shift On:  '), write(PenaltyShiftOn),nl,
	write('Penalty Shift Off: '), write(PenaltyShiftOff),nl,
	write('Penalty Cover:     '), write(PenaltyCover),nl,
	write('Penalty Total:     '), write(Penalties),nl,
	write('Flag:             '), write(Flag), nl,
	write('Labeling Options:             '), write(Options),
	nl,
	nl,
	nl.

%last line = false
write_line_to_file(Out,Element,Value,false):-
	write(Out,'"'),
	write(Out,Element),
	write(Out,'":'),
	write(Out,Value),
	write(Out,',\n').

%last line = true
write_line_to_file(Out,Element,Value,true):-
	write(Out,'"'),
	write(Out,Element),
	write(Out,'":'),
	write(Out,Value).

% convert value to string
write_line_to_file_string(Out,Element,Value):-
	write(Out,'"'),
	write(Out,Element),
	write(Out,'":'),
	write(Out,'"'),
	write(Out,Value),
	write(Out,'"'),
	write(Out,',\n').

atom_to_string(Atom, String):-
	atom_concat('"',Atom,StringAux),
	atom_concat(StringAux,'"',String).


write_results_to_file(_,_,_,time_out):-
	sol_filename(SolFileName),
	atom_concat('sol/',SolFileName,FilePath),
	open(FilePath,write,Out),
	write(Out,'{\n'),
	write_line_to_file(Out,'totalPenalty',0,false),
	write_line_to_file(Out,'flag','"time_out"',false),
	search_time(SearchTimeSeconds),
	write_line_to_file(Out,'time',SearchTimeSeconds,true),


	write(Out,'\n}'),

    close(Out). 

write_results_to_file(Schedule,Penalties,[PenaltyShiftOn,PenaltyShiftOff,PenaltyCover],Flag):-

	sol_filename(SolFileName),
	atom_concat('sol/',SolFileName,FilePath),
	open(FilePath,write,Out),
	write(Out,'{\n'),


	atom_to_string(Flag, FlagString),
	write_line_to_file(Out,'schedule',Schedule,false),
	write_line_to_file(Out,'totalPenalty',Penalties,false),
	write_line_to_file(Out,'penaltyShiftOn',PenaltyShiftOn,false),
	write_line_to_file(Out,'penaltyShiftOff',PenaltyShiftOff,false),
	write_line_to_file(Out,'penaltyCover',PenaltyCover,false),
	write_line_to_file(Out,'flag',FlagString,false),


	search_time(SearchTimeSeconds),
	% final
	write_line_to_file(Out,'time',SearchTimeSeconds,true),

	write(Out,'\n}'),

    close(Out). 


/*
 main:-
    reset_timer,
    magicSnailSolver(SpiralList),
    write(SpiralList),nl,
    print_time.
*/