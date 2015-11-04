% II.1 - The Missionaries and Cannibals Problem
% To run it, type 'schedule.' in XSB.

% Assert that the quantities of missionaries and cannibals on both banks are valid and safe.
valid(ML, CL, MR, CR) :-
	% All quantities of missionaries and cannibals must be non-negative.
	ML >= 0, CL >= 0, MR >= 0, CR >= 0,
	% If there are missionaries on the left bank, there cannot be even more cannibals.
	(ML >= CL; ML = 0),
	% If there are missionaries on the right bank, there cannot be even more cannibals.
	(MR >= CR; MR = 0).

% Assert that one missionary can safely cross right.
crossing([left, ML, CL, MR, CR], [right, ML2, CL, MR2, CR]) :-
	ML2 is ML - 1, MR2 is MR + 1, valid(ML2, CL, MR2, CR).

% Assert that one cannibal can safely cross right.
crossing([left, ML, CL, MR, CR], [right, ML, CL2, MR, CR2]) :-
	CL2 is CL - 1, CR2 is CR + 1, valid(ML, CL2, MR, CR2).

% Assert that two missionaries can safely cross right.
crossing([left, ML, CL, MR, CR], [right, ML2, CL, MR2, CR]) :-
	ML2 is ML - 2, MR2 is MR + 2, valid(ML2, CL, MR2, CR).

% Assert that two cannibals can safely cross right.
crossing([left, ML, CL, MR, CR], [right, ML, CL2, MR, CR2]) :-
	CL2 is CL - 2, CR2 is CR + 2, valid(ML, CL2, MR, CR2).

% Assert that one missionary and one cannibal can safely cross right.
crossing([left, ML, CL, MR, CR], [right, ML2, CL2, MR2, CR2]) :-
	ML2 is ML - 1, MR2 is MR + 1, CL2 is CL - 1, CR2 is CR + 1, valid(ML2, CL2, MR2, CR2).

% Assert that one missionary can safely cross left.
crossing([right, ML, CL, MR, CR], [left, ML2, CL, MR2, CR]) :-
	ML2 is ML + 1, MR2 is MR - 1, valid(ML2, CL, MR2, CR).

% Assert that one cannibal can safely cross left.
crossing([right, ML, CL, MR, CR], [left, ML, CL2, MR, CR2]) :-
	CL2 is CL + 1, CR2 is CR - 1, valid(ML, CL2, MR, CR2).

% Assert that two missionaries can safely cross left.
crossing([right, ML, CL, MR, CR], [left, ML2, CL, MR2, CR]) :-
	ML2 is ML + 2, MR2 is MR - 2, valid(ML2, CL, MR2, CR).

% Assert that two cannibals can safely cross left.
crossing([right, ML, CL, MR, CR], [left, ML, CL2, MR, CR2]) :-
	CL2 is CL + 2, CR2 is CR - 2, valid(ML, CL2, MR, CR2).

% Assert that one missionary and one cannibal can safely cross left.
crossing([right, ML, CL, MR, CR], [left, ML2, CL2, MR2, CR2]) :-
	ML2 is ML + 1, MR2 is MR - 1, CL2 is CL + 1, CR2 is CR - 1, valid(ML2, CL2, MR2, CR2).

% Assert that an item is in a list.
member(X, [Y|Ys]) :- X = Y; member(X, Ys).

solution(Start, Finish) :- solution(Start, Finish, [Start], _).

solution(Start, Finish, Visited, Schedule) :-
	% Perform a crossing to advance to the next state.
	crossing(Start, Next),
	% The next state should not have been visited, or we could infinitely loop.
	not(member(Next, Visited)),
	% Recursively find a solution from the next state.
	solution(Next, Finish, [Next|Visited], [[Start, Next]|Schedule]).

solution(Finish, Finish, _, Schedule) :- write_schedule(Schedule).

% Write a complete schedule of state changes.
write_schedule([]).
write_schedule([[From, To]|Schedule]) :- write_schedule(Schedule), write_crossing(From, To).

% Write a complete change from one state to the next.
write_crossing([left|From], [right|To]) :-
	write_left_delta(To, From), writeln(' cross left to right.'),
	write_state([right|To]).
write_crossing([right|From], [left|To]) :-
	write_left_delta(From, To), writeln(' cross right to left.'),
	write_state([left|To]).

% Write a quantity with its singular or plural case.
write_quantity(1, Singular, _) :- write(1), write(' '), write(Singular).
write_quantity(Q, _, Plural) :- write(Q), write(' '), write(Plural).

% Write which items changed on the left bank from one state to the next.
write_left_delta([ML, CL, _, _], [ML2, CL, _, _]) :-
	M is ML2 - ML,
	write_quantity(M, 'missionary', 'missionaries').
write_left_delta([ML, CL, _, _], [ML, CL2, _, _]) :-
	C is CL2 - CL,
	write_quantity(C, 'cannibal', 'cannibals').
write_left_delta([ML, CL, _, _], [ML2, CL2, _, _]) :-
	M is ML2 - ML, C is CL2 - CL,
	write_quantity(M, 'missionary', 'missionaries'),
	write(' and '),
	write_quantity(C, 'cannibal', 'cannibals').

% Write a single state of the problem.
write_state([B, ML, CL, MR, CR]) :-
	write('    ('),
	write_quantity(ML, 'M', 'Ms'), write(' and '),
	write_quantity(CL, 'C', 'Cs'), write(' on left; '),
	write_quantity(MR, 'M', 'Ms'), write(' and '),
	write_quantity(CR, 'C', 'Cs'), write(' on right; '),
	write('boat is on '), write(B), writeln('.)').

schedule :- solution([left, 3, 3, 0, 0], [right, 0, 0, 3, 3]).
