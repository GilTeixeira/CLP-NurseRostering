:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

:- include('statistics.pl').

 

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