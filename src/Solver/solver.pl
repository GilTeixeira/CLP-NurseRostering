:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(aggregate)).

:- include('statistics.pl').
:- include('data.pl').
:- include('matrixUtils.pl').
:- include('constrains.pl').
:- include('queries.pl').

%nurse_problem_solver(Schedule) 
solver(Schedule):-
	

	% Variables
	number_of_days(NDays),
	%write('Ndays: '), write(NDays),nl,

	% aggregate_all(ShiftID, shift(ShiftID,_,_), NShifts),
	%aggregate(count,ShiftID, shift(ShiftID,_,_),NShifts),

	get_number_shifts(NShifts), % TODO: change to assertz
	%write('NShifts: '), write(ListOfShiftIDs), write(NShifts),nl,

	get_number_nurses(NNurses), % TODO: change to assertz
	%aggregate(count, nurse(_,_,_,_,_,_,_,_), NNurses),	
	%write('NNurses: '),write(ListOfNurseIDs), write(NNurses),nl,

	gen_matrix(NNurses, NDays, Schedule),

	% Variables Domain
	% TODO: FOr every nurse get shifts (s)he can do
	term_variables(Schedule, Vars),
	domain(Vars,0,NShifts),
	
	%length(Vars,NVars),
	%write(NVars),

	% Constrains

	% Constrain 1
	% HC1 : Maximum one shift per day
	% Already Defined in the domain 
	
	% Constrain 2
	% HC2 : Shift rotations
	set_shift_rotations(Schedule),
	
	% Constrain 3
	% HC3: Maximum number of shifts
	set_max_shifts(Schedule),
	 
	
	% Constrain 4
	% HC4 : Maximum total minutes 
	
	% Constrain 5
	% HC5 : Minimum total minutes 
	%set_min_minutes(Schedule),
	
	% Constrain 6
	% HC6 : Maximum consecutive shifts 
	set_max_consec_shifts(Schedule),
	
	% Constrain 7
	% HC7 : Minimum consecutive shifts 
	
	% Constrain 8
	% HC8 : Minimum consecutive days off 
	
	% Constrain 9
	% HC9 : Maximum number of weekends 
	
	% Constrain 10
	% HC10 : Requested days off
	% set_nurses_days_off(Schedule),


	% Soft Constrains
	% SC1 : Shift on requests 
	% SC2 : Shift off requests 
	% SC3 : Coverage 


	%% Search
	labeling([],Vars),
	nl,
	nl,
	displayMat(Schedule),
	
	nl.


%magicSnailSolver(N, Seq, Initials, LabOptions, Matrix):-
magicSnailSolver(SpiralList):-

    SpiralList = [A, B, C, D, E],
    A #> 3,
    B #> 1,
    C #> 2,
    D #= 4,
    E #< 7,
    domain(SpiralList,0,4),
	
	%generate_matrix(N,Matrix),
	%transpose(Matrix,TransMatrix),
	%spiral(Matrix,SpiralList),
		
	%%Domain
	%length(Seq, NVars),
	%domain(SpiralList,0,NVars),
	
	
	%%Constrains
	
	%createListGlobalCardinality(Seq,N,ListGlobalCard),
	
	%%Constrain 1
	%%Each Row must some re-arrangement of all the elements of the given key
	%setGlobal(Matrix,ListGlobalCard),
	
	
	%%Constrain 2
	%%Each Column must some re-arrangement of all the elements of the given key
	%setGlobal(TransMatrix,ListGlobalCard),
	
	
	%%Constrain 3
	%% Elements already on Matrix
	%setListMatrix(Matrix,Initials),
	
	%%Constrain 4
	%%While reading the letters from outside towards the dead-end inside the
	%%grid, the order of the elements is to be same as the key
	%auto(SpiralList,Seq),
	
	
	%% Search
	labeling([],SpiralList).


 main:-
    reset_timer,
    magicSnailSolver(SpiralList),
    write(SpiralList),nl,
    print_time.