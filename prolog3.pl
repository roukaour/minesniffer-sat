% II.3 - The Puzzling Case of the Water and Zebra
% To run it, type 'solve.' in XSB.

% Assert that two items in two lists have corresponding relative positions.
correspond(A, [A|_], B, [B|_]).
correspond(A, [_|As], B, [_|Bs]) :- correspond(A, As, B, Bs).

% Assert that two items in two lists have adjacent relative positions.
adjacent(A, [A|_], B, [_,B|_]).
adjacent(A, [_,A|_], B, [B|_]).
adjacent(A, [_|As], B, [_|Bs]) :- adjacent(A, As, B, Bs).

% Assert that two items in two lists have arranged relative positions.
arranged(A, [A|_], B, [_,B|_]).
arranged(A, [_|As], B, [_|Bs]) :- arranged(A, As, B, Bs).

solution(Colors, Drinks, Nations, Smokes, Pets) :-
	% Initialize the lists of five unique things.
	Colors = [_, _, _, _, _],
	Drinks = [_, _, _, _, _],
	Nations = [_, _, _, _, _],
	Smokes = [_, _, _, _, _],
	Pets = [_, _, _, _, _],
	% The Englishman lives in the red house.
	correspond(english, Nations, red, Colors),
	% The Spaniard owns a dog.
	correspond(spanish, Nations, dog, Pets),
	% The Norwegian lives in the first house.
	Nations = [norwegian|_],
	% Kools are smoked in the yellow house.
	correspond(kools, Smokes, yellow, Colors),
	% Chesterfields are smoked next to where the fox is kept.
	adjacent(chesterfields, Smokes, fox, Pets),
	% The Norwegian lives next to the blue house.
	adjacent(norwegian, Nations, blue, Colors),
	% The Old Gold smoker owns snails.
	correspond(oldgolds, Smokes, snails, Pets),
	% The Lucky Strike smoker drinks orange juice.
	correspond(luckystrike, Smokes, orangejuice, Drinks),
	% The Ukrainian drinks tea.
	correspond(ukrainian, Nations, tea, Drinks),
	% The Japanese smokes Parliaments.
	correspond(japanese, Nations, parliaments, Smokes),
	% The Kools smoker lives next to where the horse is kept.
	adjacent(kools, Smokes, horse, Pets),
	% Coffee is drunk in the green house.
	correspond(coffee, Drinks, green, Colors),
	% The green house is to the immediate right of the ivory house.
	arranged(ivory, Colors, green, Colors),
	% Milk is drunk in the middle house.
	Drinks = [_, _, milk, _, _],
	% Who drinks water?
	correspond(water, Drinks, WhoDrinksWater, Nations),
	write('The '), write(WhoDrinksWater), writeln(' drinks water.'),
	% Who keeps the zebra?
	correspond(zebra, Pets, WhoKeepsTheZebra, Nations),
	write('The '), write(WhoKeepsTheZebra), writeln(' keeps the zebra.').

solve :- solution(_, _, _, _, _).
