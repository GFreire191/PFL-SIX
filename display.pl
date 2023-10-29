line(1, L) :- L = '     0     '.
line(2, L) :- L = '     1     '.
line(3, L) :- L = '     2     '.
line(4, L) :- L = '     3     '.
line(5, L) :- L = '     4     '.



display_game(GameState):-
    nl,
    write('           |     0     |     1     |     2     |     3     |     4     |\n'),
    write('-----------|-----------|-----------|-----------|-----------|-----------|\n'),
    print_matrix(GameState, 1).

print_matrix([], 6).
print_matrix([Head|Tail], N) :-
    line(N, L),
    write(L),
    N1 is N+1,
    write('|'),
    print_line(Head),
    write('\n-----------|-----------|-----------|-----------|-----------|-----------|\n'),
    print_matrix(Tail, N1).

print_line([]).
print_line([Head|Tail]):-
    print_pieces(Head),
    length(Head, Length),
    Spaces is 11 - Length * 2,
    print_spaces(Spaces),
    write('|'),
    print_line(Tail).

% ---------------------------------------
print_spaces(0).
print_spaces(N) :-
    write(' '),
    N1 is N-1,
    print_spaces(N1).


print_pieces([]).
print_pieces([Head|Tail]) :-
    write(Head),
    write(','),
    print_pieces(Tail).

% --------------------------------------- Menu Related ---------------------------------------

print_menu :-
    clear,
    write('|-----------------------------|'), nl,
    write('| Six Making - Main Menu      |'), nl,
    write('|-----------------------------|'), nl,
    write('| 1. Human vs Human           |'), nl,
    write('| 2. Human vs Computer        |'), nl,
    write('| 3. Computer vs Computer     |'), nl,
    write('|-----------------------------|'), nl,
    write('| 4. Instructions             |'), nl,
    write('| 5. Exit                     |'), nl,
    write('|-----------------------------|'), nl,
    write('| Choose an option            |'), nl.



    print_menu_game :-
    write('|-----------------------------|'), nl,
    write('| 1. - Place a new disk       |'), nl,
    write('| 2. - Move one tower         |'), nl,
    write('| 3. - Move part of a tower   |'), nl,
    write('|-----------------------------|'), nl,
    write('| Choose an option            |'), nl.



write_player_info(Player,Disks) :-
    write('You have '), write(Disks), write(' disks left.'), nl, nl,
    write('Player '), write(Player), write(' turn:'), nl, nl.