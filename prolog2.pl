% II.2 - The Assembly Problem

% TODO:

% Output should be something like this:
/*
topleft goes to center rotated 90
top goes to bottomright rotated 0
topright goes to bottom rotated 180
...
*/

move([A, B, C, D], [B, C, D, A]).
move([A, B, C, D], [C, D, A, B]).
move([A, B, C, D], [D, A, B, C]).

move1([[P,P2,P3], [P4,P5,P6], [P7,P8,P9]], [[Pn,P2,P3], [P4,P5,P6], [P7,P8,P9]]) :- move(P, Pn).
move2([[P1,P,P3], [P4,P5,P6], [P7,P8,P9]], [[P1,Pn,P3], [P4,P5,P6], [P7,P8,P9]]) :- move(P, Pn), align_leftright(P1, Pn).
move3([[P1,P2,P], [P4,P5,P6], [P7,P8,P9]], [[P1,P2,Pn], [P4,P5,P6], [P7,P8,P9]]) :- move(P, Pn), align_leftright(P2, Pn).
move4([[P1,P2,P3], [P,P5,P6], [P7,P8,P9]], [[P1,P2,P3], [Pn,P5,P6], [P7,P8,P9]]) :- move(P, Pn), align_updown(P1, Pn).
move5([[P1,P2,P3], [P4,P,P6], [P7,P8,P9]], [[P1,P2,P3], [P4,Pn,P6], [P7,P8,P9]]) :- move(P, Pn), align_updown(P2, Pn), align_leftright(P4, Pn).
move6([[P1,P2,P3], [P4,P5,P], [P7,P8,P9]], [[P1,P2,P3], [P4,P5,Pn], [P7,P8,P9]]) :- move(P, Pn), align_updown(P3, Pn), align_leftright(P5, Pn).
move7([[P1,P2,P3], [P4,P5,P6], [P,P8,P9]], [[P1,P2,P3], [P4,P5,P6], [Pn,P8,P9]]) :- move(P, Pn), align_updown(P4, Pn).
move8([[P1,P2,P3], [P4,P5,P6], [P7,P,P9]], [[P1,P2,P3], [P4,P5,P6], [P7,Pn,P9]]) :- move(P, Pn), align_updown(P5, Pn), align_leftright(P7, Pn).
move9([[P1,P2,P3], [P4,P5,P6], [P7,P8,P]], [[P1,P2,P3], [P4,P5,P6], [P7,P8,Pn]]) :- move(P, Pn), align_updown(P6, Pn), align_leftright(P8, Pn).

move0(A, B) :- move1(A, B); move2(A, B); move3(A, B);
               move4(A, B); move5(A, B); move6(A, B);
               move7(A, B); move8(A, B); move9(A, B). 

align(negA, a).
align(negB, b).
align(negC, c).
align(negD, d).

align_updown([_, _, X, _], [Y, _, _, _]) :- (align(X, Y); align(Y, X)).
align_leftright([_, X, _, _], [_, _, _, Y]) :- align(X, Y); align(Y, X).
align3_updown(X, Y, Z) :- align_updown(X, Y), align_updown(Y, Z).
align3_leftright(X, Y, Z) :- align_leftright(X, Y), align_leftright(Y, Z).

goal([[P1,P2,P3], [P4,P5,P6], [P7,P8,P9]]) :-
    align3_updown(P1, P4, P7),
    align3_updown(P2, P5, P8),
    align3_updown(P3, P6, P9),
    align3_leftright(P1, P2, P3),
    align3_leftright(P4, P5, P6),
    align3_leftright(P7, P8, P9).

dfs(S, _):-goal(S).
dfs(S, SoFar):-
	writeln(S),
	move0(S, S2), 
	\+member(S2, SoFar),
	dfs(S2, [S2|SoFar]).

solve :- dfs([[[negA, negB, c, d], [a, d, negC, negD], [negD, negC, b, d]], [[negB, negD, negC, d], [d, b, negC, negA], [negA, negD, c, b]],
[[negA, negB, c, b], [b, negA, negC, a], [negB, a, d, negC]]], []).

solve.

% Or maybe like this:
/*
1. [-a, -c, +a, +b]
2. [+b, -a, -b, +c]
3. [-a, -d, +c, +b]
...
*/

% Original positions:
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
