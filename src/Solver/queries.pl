
get_number_shifts(NShifts):-
	findall(ShiftID, shift(ShiftID,_,_), ListOfShiftIDs), 
	length(ListOfShiftIDs, NShifts).

get_number_nurses(NNurses):-
    findall(NurseID, nurse(NurseID,_,_,_,_,_,_,_), ListOfNurseIDs), 
    length(ListOfNurseIDs, NNurses).