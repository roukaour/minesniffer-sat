% II.2 - The Assembly Problem

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

% Assert that an item is in a list.
member(X, [Y|Ys]) :- X = Y; member(X, Ys).

% Assert that one part is a rotation of another.
% Parts are represented as lists of [Up, Right, Down, Left] symbols.
% (This order is the same as CSS properties.)
rotation([A, B, C, D], [A, B, C, D]).
rotation([A, B, C, D], [B, C, D, A]).
rotation([A, B, C, D], [C, D, A, B]).
rotation([A, B, C, D], [D, A, B, C]).

% Assert that a board includes a part at some position and rotation.
% Boards are represented as lists of rows, which are themselves lists of cells.
check_part(Board, Part) :- member(Row, Board), member(Cell, Row), rotation(Part, Cell).

% Assert that a board includes each part in a list.
check_rotations(_, []).
check_rotations(Board, [Part|Parts]) :- check_part(Board, Part), check_rotations(Board, Parts).

% Assert that two symbols are opposites, i.e. same letter and opposite signs.
% (+a and -a, +b and -b, +c and -c, +d and -d.)
opposites(a, na).
opposites(na, a).
opposites(b, nb).
opposites(nb, b).
opposites(c, nc).
opposites(nc, c).
opposites(d, nd).
opposites(nd, d).

% Assert that two parts are aligned horizontally: the bottom of the first
% is the opposite of the top of the second.
align_horizontal([_, _, Down, _], [Up, _, _, _]) :- opposites(Down, Up).

% Assert that two parts are aligned vertically: the right side of the first
% is the opposite of the left side of the second.
align_vertical([_, Right, _, _], [_, _, _, Left]) :- opposites(Right, Left).

% Assert that the adjacent edges of all parts in a board are aligned.
check_edges(Board) :-
	Board = [[P1, P2, P3], [P4, P5, P6], [P7, P8, P9]],
	align_horizontal(P1, P2),
	align_horizontal(P2, P3),
	align_horizontal(P4, P5),
	align_horizontal(P5, P6),
	align_horizontal(P7, P8),
	align_horizontal(P8, P9),
	align_vertical(P1, P4),
	align_vertical(P4, P7),
	align_vertical(P2, P5),
	align_vertical(P5, P8),
	align_vertical(P3, P6),
	align_vertical(P6, P9).

% Assert that a board is a solution to the puzzle: its parts have aligned edges
% and are all taken from the given nine parts.
solution(Board) :-
	check_edges(Board),
	Parts = [[nb, c, d, na], [a, d, nc, nd], [nc, b, d, nd],
		[nd, nc, d, nb], [b, nc, na, d], [na, nd, c, b],
		[nb, c, b, na], [na, nc, a, b], [nb, a, d, nc]],
	check_rotations(Board, Parts),
	(writeln(Board), fail; true).

assemble :- solution(_).
