% II.2 - The Assembly Problem
% To run it, type 'assemble.' in XSB.

% Given parts:
/*
1 -b  |2 +a  |3 -c
-a  +c|-d  +d|-d  +b
  +d  |  -c  |  +d
------+------+------
4 -d  |5 +b  |6 -a
-b  -c|+d  -c|+b  -d
  +d  |  -a  |  +c
------+------+------
7 -b  |8 -a  |9 -b
-a  +c|+b  -c|-c  +a
  +b  |  +a  |  +d
*/

% Assert that two symbols are opposites, i.e. same letter and opposite signs.
% (+a and -a, +b and -b, +c and -c, +d and -d.)
opposites(pa, na).
opposites(na, pa).
opposites(pb, nb).
opposites(nb, pb).
opposites(pc, nc).
opposites(nc, pc).
opposites(pd, nd).
opposites(nd, pd).

% Assert that two parts are aligned horizontally: the right side of the first
% is the opposite of the left side of the second.
align_horizontal(x, _).
align_horizontal(_, x).
align_horizontal([_, _, R, _, _], [_, _, _, _, L]) :- opposites(R, L).

% Assert that two parts are aligned vertically: the bottom of the first
% is the opposite of the top of the second.
align_vertical(x, _).
align_vertical(_, x).
align_vertical([_, _, _, B, _], [_, T, _, _, _]) :- opposites(B, T).

% Assert that one part is a rotation of another, 90 degrees clockwise.
% Parts are represented as lists of [Top, Right, Bottom, Left] symbols.
% (This order is the same as CSS properties.)
rotated([N, T, R, B, L], [N, L, T, R, B]).

place(P1, [x,P2,P3,P4,P5,P6,P7,P8,P9], [P1,P2,P3,P4,P5,P6,P7,P8,P9]) :-
	align_horizontal(P1, P2),
	align_vertical(P1, P4).

place(P2, [P1,x,P3,P4,P5,P6,P7,P8,P9], [P1,P2,P3,P4,P5,P6,P7,P8,P9]) :-
	align_horizontal(P1, P2),
	align_horizontal(P2, P3),
	align_vertical(P2, P5).

place(P3, [P1,P2,x,P4,P5,P6,P7,P8,P9], [P1,P2,P3,P4,P5,P6,P7,P8,P9]) :-
	align_horizontal(P2, P3),
	align_vertical(P3, P6).

place(P4, [P1,P2,P3,x,P5,P6,P7,P8,P9], [P1,P2,P3,P4,P5,P6,P7,P8,P9]) :-
	align_horizontal(P4, P5),
	align_vertical(P1, P4),
	align_vertical(P4, P7).

place(P5, [P1,P2,P3,P4,x,P6,P7,P8,P9], [P1,P2,P3,P4,P5,P6,P7,P8,P9]) :-
	align_horizontal(P4, P5),
	align_horizontal(P5, P6),
	align_vertical(P2, P5),
	align_vertical(P5, P8).

place(P6, [P1,P2,P3,P4,P5,x,P7,P8,P9], [P1,P2,P3,P4,P5,P6,P7,P8,P9]) :-
	align_horizontal(P5, P6),
	align_vertical(P3, P6),
	align_vertical(P6, P9).

place(P7, [P1,P2,P3,P4,P5,P6,x,P8,P9], [P1,P2,P3,P4,P5,P6,P7,P8,P9]) :-
	align_horizontal(P7, P8),
	align_vertical(P4, P7).

place(P8, [P1,P2,P3,P4,P5,P6,P7,x,P9], [P1,P2,P3,P4,P5,P6,P7,P8,P9]) :-
	align_horizontal(P7, P8),
	align_horizontal(P8, P9),
	align_vertical(P5, P8).

place(P9, [P1,P2,P3,P4,P5,P6,P7,P8,x], [P1,P2,P3,P4,P5,P6,P7,P8,P9]) :-
	align_horizontal(P8, P9),
	align_vertical(P6, P9).

solution(Board, [R1|Pieces]) :-
	rotated(R1, R2),
	rotated(R2, R3),
	rotated(R3, R4),
	% Try placing a piece in all possible spaces.
	place(Piece, Board, NextBoard),
	% Try all four rotations of the first piece.
	(Piece = R1; Piece = R2; Piece = R3; Piece = R4),
	% Recursively find a solution from the next board.
	solution(NextBoard, Pieces).

solution(Board, []) :- write_board(Board).

write_board([P1, P2, P3, P4, P5, P6, P7, P8, P9]) :-
	write_row(P1, P2, P3),
	writeln('------+------+------'),
	write_row(P4, P5, P6),
	writeln('------+------+------'),
	write_row(P7, P8, P9).

write_row([N1, T1, R1, B1, L1], [N2, T2, R2, B2, L2], [N3, T3, R3, B3, L3]) :-
	write(N1), write(' '), write_symbol(T1), write('  |'),
	write(N2), write(' '), write_symbol(T2), write('  |'),
	write(N3), write(' '), write_symbol(T3), writeln(''),
	write_symbol(L1), write('  '), write_symbol(R1), write('|'),
	write_symbol(L2), write('  '), write_symbol(R2), write('|'),
	write_symbol(L3), write('  '), write_symbol(R3), writeln(''),
	write('  '), write_symbol(B1), write('  |  '),
	write_symbol(B2), write('  |  '),
	write_symbol(B3), writeln('').

write_symbol(pa) :- write('+a').
write_symbol(na) :- write('-a').
write_symbol(pb) :- write('+b').
write_symbol(nb) :- write('-b').
write_symbol(pc) :- write('+c').
write_symbol(nc) :- write('-c').
write_symbol(pd) :- write('+d').
write_symbol(nd) :- write('-d').

solve(Pieces) :-
	writeln('Given:'),
	write_board(Pieces),
	writeln(''),
	writeln('Solution:'),
	solution([x, x, x, x, x, x, x, x, x], Pieces).

assemble :- solve([
	[1, nb, pc, pd, na], [2, pa, pd, nc, nd], [3, nc, pb, pd, nd],
	[4, nd, nc, pd, nb], [5, pb, nc, na, pd], [6, na, nd, pc, pb],
	[7, nb, pc, pb, na], [8, na, nc, pa, pb], [9, nb, pa, pd, nc]]).
