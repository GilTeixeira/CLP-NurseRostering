% Prints the time of execution of a program
reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.
	 
% writeTimesAux(+NumberVars, +SizeMatrix, +Limit, +Stream)
% writeTimes auxiliar predicate	 	
writeTimesAux(_,Limit,Limit,_).	
writeTimesAux(NumberVars,SizeMatrix,Limit,Stream):-
	statistics(walltime, _),
	createList(NumberVars,1,Seq),	
	magicSnailAux(SizeMatrix, Seq, [], Matrix),
	statistics(walltime, [ _ | [ExecutionTime]]),
	write(Stream,ExecutionTime),  nl(Stream),	
	nl, write(SizeMatrix), nl, printBoard(Matrix),	
	SizeMatrixPlus1 is SizeMatrix+1,
	writeTimesAux(NumberVars,SizeMatrixPlus1,Limit,Stream).
		

% writeTimesAux(+NumVars,+SizeMatrix,+Limit)
% write times of execution to file of matrix between size [SizeMatrix,Limit[
writeTimes(NumVars,SizeMatrix,Limit):-	
	open('times.txt',write,Stream),
	writeTimesAux(NumVars,SizeMatrix,Limit,Stream),
    close(Stream).