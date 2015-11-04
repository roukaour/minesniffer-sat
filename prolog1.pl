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

solution(Start, Finish, Visited, Schedule) :-
	% Perform a crossing to advance to the next state.
	crossing(Start, Next),
	% The next state should not have been visited, or we could infinitely loop.
	not(member(Next, Visited)),
	% Recursively find a solution from the next state.
	solution(Next, Finish, [Next|Visited], [[Start, Next]|Schedule]).

solution(Finish, Finish, _, Schedule) :- write_schedule(Schedule).

% Write a quantity with its singular or plural case.
write_quantity(1, Singular, _) :- write(1), write(' '), write(Singular).
write_quantity(Q, _, Plural) :- write(Q), write(' '), write(Plural).

write_schedule([]).
write_schedule([[From, To]|Schedule]) :- write_schedule(Schedule), write_crossing(From, To).

write_crossing([left|From], [right, ML, CL, MR, CR]) :-
	write_delta([ML, CL, MR, CR], From), writeln(' cross left to right.'),
	write('('), write_state(ML, CL, MR, CR), writeln('boat is on right.)').
write_crossing([right, ML, CL, MR, CR], [left|To]) :-
	write_delta([ML, CL, MR, CR], To), writeln(' cross right to left.'),
	write('('), write_state(ML, CL, MR, CR), writeln('boat is on left.)').

write_delta([ML, CL, _, _], [ML2, CL, _, _]) :-
	M is ML2 - ML,
	write_quantity(M, 'missionary', 'missionaries').
write_delta([ML, CL, _, _], [ML, CL2, _, _]) :-
	C is CL2 - CL,
	write_quantity(C, 'cannibal', 'cannibals').
write_delta([ML, CL, _, _], [ML2, CL2, _, _]) :-
	M is ML2 - ML, C is CL2 - CL,
	write_quantity(M, 'missionary', 'missionaries'),
	write(' and '),
	write_quantity(C, 'cannibal', 'cannibals').

write_state(ML, CL, MR, CR) :-
	write_quantity(ML, 'm.', 'm.s'), write(' and '),
	write_quantity(CL, 'c.', 'c.s'), write(' on left; '),
	write_quantity(MR, 'm.', 'm.s'), write(' and '),
	write_quantity(CR, 'c.', 'c.s'), write(' on right; ').

schedule :-
	solution([left, 3, 3, 0, 0], [right, 0, 0, 3, 3], [[left, 3, 3, 0, 0]], _).
