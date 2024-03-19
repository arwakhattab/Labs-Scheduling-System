ta_slot_assignment([ta(Name,Y)|T],[ta(Name,Z)|T],Name):-
	Y > 0,
	Z is Y - 1.

ta_slot_assignment([ta(X,Y)|T1],[ta(X,Y)|T2],Name):-
	X \= Name,
	ta_slot_assignment(T1,T2,Name).

slot_assignment_helper(0,_,[]).

slot_assignment_helper(LabsNum,[ta(X,_)|T1],[X|T2]):-
	LabsNum > 0,
	LabsNum1 is LabsNum - 1,
	slot_assignment_helper(LabsNum1,T1,T2).

slot_assignment_helper(LabsNum,[_|T],Assignment):-
	LabsNum > 0,
	slot_assignment_helper(LabsNum,T,Assignment).

decrement_loads(TAs,[],TAs).

decrement_loads(TAs,[H|T],RemTAs):-
	ta_slot_assignment(TAs,RemTAs1,H),
	decrement_loads(RemTAs1,T,RemTAs).

slot_assignment(LabsNum,TAs,RemTAs,Assignment):-
	slot_assignment_helper(LabsNum,TAs,Assignment1),
	permutation(Assignment1,Assignment),
	decrement_loads(TAs,Assignment,RemTAs).

count_list([],_,0).

count_list([X|T],X,Count):-
	count_list(T,X,Count1),
	Count is 1 + Count1.

count_list([H|T],X,Count):-
	H \= X,
	count_list(T,X,Count).

remove_duplicates(L,R):-
	remove_duplicates(L,[],R).

remove_duplicates([],R,R).

remove_duplicates([H|T],A,R):-
	\+member(H,A),
	append(A,[H],A1),
	remove_duplicates(T,A1,R).

remove_duplicates([H|T],A,R):-
	member(H,A),
	remove_duplicates(T,A,R).

max_slots_helper([],_,_).

max_slots_helper([H|T],L,Max):-
	count_list(L,H,Count),
	Count =< Max,
	max_slots_helper(T,L,Max).

max_slots_per_day(DaySched,Max):-
	flatten(DaySched,X),
	remove_duplicates(X,Y),
	max_slots_helper(Y,X,Max).

day_schedule([],TAs,TAs,[]).

day_schedule([H1|T1],TAs,RemTAs,[H2|T2]):-
	slot_assignment(H1,TAs,RemTAs1,H2),
	day_schedule(T1,RemTAs1,RemTAs,T2).

week_schedule([],_,_,[]).

week_schedule([H1|T1],TAs,DayMax,[H2|T2]):-
	day_schedule(H1,TAs,RemTAs,H2),
	max_slots_per_day(H2,DayMax),
	week_schedule(T1,RemTAs,DayMax,T2).
