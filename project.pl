:- use_module(library(lists)).
:- consult('board.pl').
:- consult('menu.pl').


clear :- write('\33\[2J').

% ---------------------------------------



makeSix :-
    print_menu,
    read(Option), nl,
    process_option(Option).



process_option(1) :-
    nl,
    start_game.

process_option(4) :- 
    write('Invalid Option!'), nl,
    write('Invalid Option!'), nl,
    write('Invalid Option!'), nl,
    write('Invalid Option!'), nl,
    write('Invalid Option!'), nl, nl,
    makeSix.

process_option(5) :- 
    !, write('Goodbye!'), nl.

process_option(_) :- 
    write('Invalid Option!'), nl,
    makeSix.

% ---------------------------------------

start_game :-
    initial_board(Board),
    game_loop(Board, w).
    



process_option_game(1, Board, Player, NewBoard) :-

    write('Which row?'),
    read(Row),
    write('Which column?'),
    read(Column),
    check_matrix(Row, Column) -> place_disk(Board, Row, Column, Player, NewBoard);
    handle_invalid_input( Board, Player, NewBoard).

process_option_game(2, Board, Player, NewBoard) :-
    write('Choose the row of the tower you want to move:'),
    read(Row),
    write('Choose the column of the tower you want to move:'),
    read(Column),
    write('Choose the row where you want to move the tower:'),
    read(NewRow),
    write('Choose the column where you want to move the tower:'),
    read(NewColumn),
    check_matrix(Row, Column),check_matrix(NewRow, NewColumn) -> move_tower(Board, Row, Column, NewRow, NewColumn, NewBoard);
    handle_invalid_input(Board, Player, NewBoard).

    
    


process_option_game(3, Board, Player, NewBoard) :-
    write('Choose the row of the tower you want to move:'),
    read(Row),
    write('Choose the column of the tower you want to move:'),
    read(Column),
    write('Choose the row where you want to move the tower:'),
    read(NewRow),
    write('Choose the column where you want to move the tower:'),
    read(NewColumn),
    write('How many pieces do you want to move?'),
    read(amount_to_move),
    
    check_matrix(Row, Column),check_matrix(NewRow, NewColumn) -> move_tower(Board, Row, Column, NewRow, NewColumn, NewBoard),
    handle_invalid_input(Board, Player, NewBoard).

    

process_option_game(_) :- 
    write('INVALID OPTION!'), nl,
    print_menu_game.

% ---------------------------------------


check_matrix(Row, Column) :-
    is_valid(Row, Column).

is_valid(X, Y) :-
    limits(0, 4, X),
    limits(0, 4, Y).

limits(Low, High, Low) :- Low =< High.
limits(Low, High, Value) :-
    Low < High,
    Next is Low + 1,
    limits(Next, High, Value).

% ---------------------------------------

next_player(w, b).
next_player(b, w).


game_loop(Board, Player) :-
    print_board(Board), nl, nl,
    print_menu_game,
    write('Player '), write(Player), write(' turn:'), nl, nl,
    read(OptionGame), nl,nl,
    process_option_game(OptionGame, Board, Player, NewBoard),
    next_player(Player, NextPlayer),
    game_loop(NewBoard, NextPlayer).



% Place a new disk. Add a disk to the board, at the beggining of the list located at the given row and column.





place_disk(Board, Row, Column, Player, NewBoard) :-
    nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    Length == 0 ->
    append([Player], ColumnList, NewColumnList),
    replace(RowList, Column, NewColumnList, NewRowList),
    replace(Board, Row, NewRowList, NewBoard);
    handle_ivalid_moves(Board, Player, NewBoard).


replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):-
    I > -1,
    NI is I-1,
    replace(T, NI, X, R), !.
replace(L, _, _, L).





% ---------------------------------------





    





    

get_columnList(Board, Row, Column, ColumnList) :-
    nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList).


% ---------------------------------------
    
    
% re-place a tower from a list located at the given row and column to a new row and column.


move_tower(Board, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-

    
    
    append_tower(Board, OldRow, OldColumn, NewRow, NewColumn, NewBoard),
    write('Tower moved!'), nl, nl.
    remove_tower(Board, OldRow, OldColumn, NewBoard).
    

    




append_tower(Board, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-
    nth0(OldRow, Board, OldRowList),
    nth0(OldColumn, OldRowList, OldColumnList),
    length(OldColumnList, Length),
    Length > 0,
    nth0(NewRow, Board, NewRowList),
    nth0(NewColumn, NewRowList, NewColumnList),
    length(NewColumnList, Length2),
    Length2 \= 0 ->
    append(OldColumnList, NewColumnList, NewColumnList2),
    replace(NewRowList, NewColumn, NewColumnList2, NewRowList2),
    replace(Board, NewRow, NewRowList2, NewBoard);
    handle_ivalid_moves(Board, Player, NewBoard).




remove_tower(Board, OldRow, OldColumn, NewBoard) :-
    
    



    



% Move only a part of a tower.
move_part_tower(Board, OldRow, OldColumn, NewRow, NewColumn, Amount, NewBoard) :-
    write('Need to be done'), nl.


handle_ivalid_moves(Board, Player, NewBoard):-
    write('INVALID OPTION!'), nl,
    write('You can only place a disk in an empty spot!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, Board, Player, NewBoard).

handle_invalid_input(Board, Player, NewBoard):-
    write('INVALID OPTION!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, Board, Player, NewBoard).
    



