:- use_module(library(clpfd)).
:- use_module(library(between)).
:- include('matrixUtils.pl').

/*
min_consec(Vars) :-
    automaton(Vars,
    [ source(w0),sink(w0),sink(nw),sink(w1),sink(w2) ],
    [ arc(w0, 0, nw),
    arc(w0, 1, w0),

    arc(nw, 0, nw),
    arc(nw, 1, w1),
    arc(w1, 1, w2),
    arc(w2, 0, nw)]).
    



% createArcsAutomaton(+Vars,+Counter,-ListArcs)
% Creates a List of Arcs to be used in the Automaton
createArcsAutomaton([Var1],Counter,ListArcs):-
	ListArcs = [arc(Counter,0,Counter),
	arc(Counter,Var1,0)].
	
	
createArcsAutomaton([Var1|Vars],Counter,ListArcs):-
	CounterPlus1 is Counter+1,
	ListArcsProv = [arc(Counter,0,Counter),
	arc(Counter,Var1,CounterPlus1)],
	createArcsAutomaton(Vars,CounterPlus1,ListArcsProv2),
	append(ListArcsProv,ListArcsProv2,ListArcs).
	
	
% Applys the Automaton to the list
% The Automaton restricts a list in which the order of the variables is to be same as the key
auto(Spiral,Seq) :-
	createArcsAutomaton(Seq,0,ListArcs),	
	automaton(Spiral, [source(0), sink(0)], ListArcs).


*/

get_number_shifts(2).
get_shifts_list([1,2]).

min_consec(NurseSchedule, MinConsecutiveShifts):-
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
create_arcs_min_consec(1,Arcs):-
    create_arcs_per_shift(w0,w0,ArcsW0),
    create_arcs_per_shift(nw,1,ArcsNW),
    get_number_shifts(NShifts),
    InitialArcs = [arc(w0,0,nw),arc(nw,0,nw),arc(NShifts,0,nw)],
    append(ArcsW0,ArcsNW,ArcsAux),
    append(InitialArcs,ArcsAux,Arcs).
    %printBoardLine(Arcs).


create_arcs_min_consec(Counter,Arcs):-
    CounterMinus1 is Counter-1,
    create_arcs_per_shift(CounterMinus1,Counter,ArcsW),
    append(ArcsW,ArcsRemain,Arcs),
    create_arcs_min_consec(CounterMinus1,ArcsRemain).

*/

