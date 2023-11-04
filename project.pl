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
    
    check_matrix(Row, Column),check_matrix(NewRow, NewColumn) -> move_tower(Board, Row, Column, NewRow, NewColumn, NewBoard);
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

    write(Row),nl,
    write(Board),nl,
    write(RowList),nl,nl,

    nth0(Column, RowList, ColumnList),

    write(Column),nl,
    write(RowList),nl,
    write(ColumnList),nl,nl,

    length(ColumnList, Length),
    Length == 0 ->
    append([Player], ColumnList, NewColumnList),
    replace(RowList, Column, NewColumnList, NewRowList),

    write(RowList),nl,
    write(Column),nl,
    write(NewColumnList),nl,
    write(NewRowList),nl,nl,

    replace(Board, Row, NewRowList, NewBoard),

    write(Board),nl,
    write(Row),nl,
    write(NewRowList),nl,
    write(NewBoard),nl,nl;

    handle_ivalid_moves(Board, Player, NewBoard).


replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):-
    I > -1,
    NI is I-1,
    replace(T, NI, X, R), !.
replace(L, _, _, L).


% moverrrrrr

move_tower(Board, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-
    
    append_tower(Board, OldRow, OldColumn, NewRow, NewColumn, NewBoard),
    write('Tower moved!'), nl, nl;
    
    handle_ivalid_moves(Board, Player, NewBoard).


append_tower(Board, Player, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-
    nth0(OldRow, Board, OldRowList),

    write(OldRow),nl,
    write(Board),nl,
    write(OldRowList),nl,nl,

    nth0(OldColumn, OldRowList, OldColumnList),

    write(OldColumn),nl,
    write(OldRowList),nl,
    write(OldColumnList),nl,nl,

    length(OldColumnList, Length),
    Length > 0,

    nth0(NewRow, Board, NewRowList),

    write(NewRow),nl,
    write(Board),nl,
    write(NewRowList),nl,nl,

    nth0(NewColumn, NewRowList, NewColumnList),

    write(NewColumn),nl,
    write(NewRowList),nl,
    write(NewColumnList),nl,nl,

    length(NewColumnList, Length2),
    Length2 \= 0 ->

    append(OldColumnList, NewColumnList, NewColumnList2),

    write('IMPORTANTTTTTTT'), nl,
    write(Length), nl,
    
    move_piece(Length, OldRow, OldColumn, NewRow, NewColumn) -> replaces(Board, OldRow, OldColumn, NewRow, NewColumn, OldRowList, OldColumnList, NewRowList, NewColumnList, NewColumnList2, NewBoard).


replaces(Board, OldRow, OldColumn, NewRow, NewColumn, OldRowList, OldColumnList, NewRowList, NewColumnList, NewColumnList2, NewBoard) :- 

    replace(NewRowList, NewColumn, NewColumnList2, NewRowList2),

    write(NewRowList),nl,
    write(NewColumn),nl,
    write(NewColumnList2),nl,
    write(NewRowList2),nl,nl,

    replace(Board, NewRow, NewRowList2, NewBoard1),
    
    write(Board),nl,
    write(NewRow),nl,
    write(NewRowList2),nl,
    write(NewBoard1),nl,nl,

    nth0(OldRow, NewBoard1, Remover),

    write('-----------------------------------------'),nl,
    write(OldRow),nl,
    write(NewBoard1),nl,
    write(Remover),nl, nl,

    nth0(OldColumn, Remover, Removido),

    write(OldColumn),nl,
    write(Remover),nl,
    write(Removido),nl, nl,
    write('-----------------------------------------'),nl,
    
    replace(Remover, OldColumn, [], NewRowList3),

    write(OldRowList),nl,
    write(OldColumn),nl,
    write('nada'),nl,
    write(NewRowList3),nl,nl,

    replace(NewBoard1, OldRow, NewRowList3, NewBoard),
    
    write(NewBoard1),nl,
    write(OldRow),nl,
    write(NewRowList3),nl,
    write(NewBoard),nl,nl.
    

% movesssssss
    
move_piece(1, OldRow, OldColumn, NewRow, NewColumn) :-
    move1(OldRow, OldColumn, NewRow, NewColumn).

move1(Player, OldRow, OldColumn, NewRow, NewColumn) :-
    write('Entreiiiiiiiiiiiiiii'),
    (NewRow =:= OldRow + 1, NewColumn =:= OldColumn;
    NewRow =:= OldRow - 1, NewColumn =:= OldColumn;
    NewRow =:= OldRow, NewColumn =:= OldColumn + 1;
    NewRow =:= OldRow, NewColumn =:= OldColumn - 1).


    

move_piece(2, OldRow, OldColumn, NewRow, NewColumn) :-
    move2(OldRow, OldColumn, NewRow, NewColumn).
        
move2(OldRow, OldColumn, NewRow, NewColumn) :-
    write('EntreiiiiiiiiiiiiiiiNekaaaaaa'),
    (OldColumn =:= NewColumn, NewRow \== OldRow);
    (OldRow =:= NewRow,  NewColumn \== OldColumn).




move_piece(3, OldRow, OldColumn, NewRow, NewColumn) :-
    move3(OldRow, OldColumn, NewRow, NewColumn).

move3(OldRow, OldColumn, NewRow, NewColumn) :-
    (RowDiff is abs(NewRow - OldRow), ColumnDiff is abs(NewColumn - OldColumn),
    ((RowDiff =:= 1, ColumnDiff =:= 2) ; (RowDiff =:= 2, ColumnDiff =:= 1))).




move_piece(4, OldRow, OldColumn, NewRow, NewColumn) :-
    move4(OldRow, OldColumn, NewRow, NewColumn).

move4(OldRow, OldColumn, NewRow, NewColumn) :-
    RowDiff is abs(NewRow - OldRow),
    ColumnDiff is abs(NewColumn - OldColumn),
    RowDiff =:= ColumnDiff.



move_piece(5, OldRow, OldColumn, NewRow, NewColumn) :-
    move5(OldRow, OldColumn, NewRow, NewColumn).

move5(OldRow, OldColumn, NewRow, NewColumn) :-
    RowDiff is abs(NewRow - OldRow),
    ColumnDiff is abs(NewColumn - OldColumn),
    (RowDiff =:= ColumnDiff ; OldRow =:= NewRow ; OldColumn =:= NewColumn).


% handlesssssss


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
    

% handles voltar erro do 2 para o 1
% win condition



