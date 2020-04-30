% length_list(+N, -List)
% Creates List of size N
length_(Length, List) :- length(List, Length).


% gen_matrix(+N, +Len, -List)
% Generates Matrix of Size (N x Len), Create N lists of Length Len
gen_matrix(N, Len, List) :- length(List, N), maplist(length_(Len), List).





% displayMat(+Matrix)
% Displays a Matrix
displayMat([]).
displayMat([Line|Ls]):-
	write(Line),nl,
	displayMat(Ls).

% printSeparator(+N)
% Displays a Separator	
printSeparator(N):-
	write('   +'),
	printSeparatorAux(N),
	nl.

% printSeparatorAux(+N)
% printSeparator auxiliar predicate
printSeparatorAux(0).
printSeparatorAux(N):-
	write('---+'),
	NMinus1 is N-1,
	printSeparatorAux(NMinus1).
	
	

% printBoardCell(+Elem)
% Displays a Board Cell	
printBoardCell(Elem):-
	write(' '),
	write(Elem),
	write(' |').

% printBoardLine(+BoardLine)
% Displays a Board Line	
printBoardLine([]).	
printBoardLine([LineHead|LineTail]):-
	printBoardCell(LineHead),
	printBoardLine(LineTail).

% printLine(+BoardLine)
% Displays a Board Line	
printLine(BoardLine):-
	write('   |'),
	printBoardLine(BoardLine),
	nl.

% printSeparatorAux(+Board,SizeBoard)
% printBoard auxiliar predicate
printBoardAux([],_).
printBoardAux([BoardHead | BoardTail],SizeBoard):-
	printLine(BoardHead),
	printSeparator(SizeBoard),
	printBoardAux(BoardTail,SizeBoard).

% printBoard(+Board)
% Displays a Board	
printBoard(Board):-
	length(Board,SizeBoard),
	printSeparator(SizeBoard),
	printBoardAux(Board,SizeBoard).

% pressEnterToContinue
% Press Enter To Continue.
pressEnterToContinue:-
	write('Pressione Enter para continuar.'),
	get_char(_),
	nl.