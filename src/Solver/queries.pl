get_shifts_list(ShiftsList):-
    findall(ShiftID, shift(ShiftID,_,_), ShiftsList).

get_number_shifts(NShifts):-
	get_shifts_list(ShiftsList), 
	length(ShiftsList, NShifts).

get_number_nurses(NNurses):-
    findall(NurseID, nurse(NurseID,_,_,_,_,_,_,_), ListOfNurseIDs), 
    length(ListOfNurseIDs, NNurses).