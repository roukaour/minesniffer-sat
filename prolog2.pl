% II.2 - The Assembly Problem
% To run it, type 'assemble.' in XSB.

% Given parts:
/*
1         2         3
+------+  +------+  +------+
|  -b  |  |  +a  |  |  -c  |
|-a  +c|  |-d  +d|  |-d  +b|
|  +d  |  |  -c  |  |  +d  |
+------+  +------+  +------+
4         5         6
+------+  +------+  +------+
|  -d  |  |  +b  |  |  -a  |
|-b  -c|  |+d  -c|  |+b  -d|
|  +d  |  |  -a  |  |  +c  |
+------+  +------+  +------+
7         8         9
+------+  +------+  +------+
|  -b  |  |  -a  |  |  -b  |
|-a  +c|  |+b  -c|  |-c  +a|
|  +b  |  |  +a  |  |  +d  |
+------+  +------+  +------+
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
align_horizontal([_, R, _, _], [_, _, _, L]) :- opposites(R, L).

% Assert that two parts are aligned vertically: the bottom of the first
% is the opposite of the top of the second.
align_vertical(x, _).
align_vertical(_, x).
align_vertical([_, _, B, _], [T, _, _, _]) :- opposites(B, T).

% Assert that one part is a rotation of another, 90 degrees clockwise.
% Parts are represented as lists of [Top, Right, Bottom, Left] symbols.
% (This order is the same as CSS properties.)
rotated([T, R, B, L], [L, T, R, B]).

place(P1, [[x,P2,P3],[P4,P5,P6],[P7,P8,P9]], [[P1,P2,P3],[P4,P5,P6],[P7,P8,P9]]) :-
	align_horizontal(P1, P2),
	align_vertical(P1, P4).

place(P2, [[P1,x,P3],[P4,P5,P6],[P7,P8,P9]], [[P1,P2,P3],[P4,P5,P6],[P7,P8,P9]]) :-
	align_horizontal(P1, P2),
	align_horizontal(P2, P3),
	align_vertical(P2, P5).

place(P3, [[P1,P2,x],[P4,P5,P6],[P7,P8,P9]], [[P1,P2,P3],[P4,P5,P6],[P7,P8,P9]]) :-
	align_horizontal(P2, P3),
	align_vertical(P3, P6).

place(P4, [[P1,P2,P3],[x,P5,P6],[P7,P8,P9]], [[P1,P2,P3],[P4,P5,P6],[P7,P8,P9]]) :-
	align_horizontal(P4, P5),
	align_vertical(P1, P4),
	align_vertical(P4, P7).

place(P5, [[P1,P2,P3],[P4,x,P6],[P7,P8,P9]], [[P1,P2,P3],[P4,P5,P6],[P7,P8,P9]]) :-
	align_horizontal(P4, P5),
	align_horizontal(P5, P6),
	align_vertical(P2, P5),
	align_vertical(P5, P8).

place(P6, [[P1,P2,P3],[P4,P5,x],[P7,P8,P9]], [[P1,P2,P3],[P4,P5,P6],[P7,P8,P9]]) :-
	align_horizontal(P5, P6),
	align_vertical(P3, P6),
	align_vertical(P6, P9).

place(P7, [[P1,P2,P3],[P4,P5,P6],[x,P8,P9]], [[P1,P2,P3],[P4,P5,P6],[P7,P8,P9]]) :-
	align_horizontal(P7, P8),
	align_vertical(P4, P7).

place(P8, [[P1,P2,P3],[P4,P5,P6],[P7,x,P9]], [[P1,P2,P3],[P4,P5,P6],[P7,P8,P9]]) :-
	align_horizontal(P7, P8),
	align_horizontal(P8, P9),
	align_vertical(P5, P8).

place(P9, [[P1,P2,P3],[P4,P5,P6],[P7,P8,x]], [[P1,P2,P3],[P4,P5,P6],[P7,P8,P9]]) :-
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

solution([R1, R2, R3], []) :- writeln(R1), writeln(R2), writeln(R3).

assemble :- solution([[x, x, x], [x, x, x], [x, x, x]],
	[[nb, pc, pd, na], [pa, pd, nc, nd], [nc, pb, pd, nd],
	[nd, nc, pd, nb], [pb, nc, na, pd], [na, nd, pc, pb],
	[nb, pc, pb, na], [na, nc, pa, pb], [nb, pa, pd, nc]]).
