:- use_module(library(lists)).
:- consult('board.pl').
:- consult('menu.pl').
:- consult('utils.pl').
:- consult('moves.pl').


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
    makeSix.

process_option(5) :- 
    !, write('Goodbye!'), nl.

process_option(_) :- 
    write('Invalid Option!'), nl,
    makeSix.

% ---------------------------------------

start_game :-
    write('What is the board Size? (4,5)'),
    read(BoardSize),
    (BoardSize == 4 ; BoardSize == 5) -> 
        initial_board(BoardSize,Board),
        game_loop(BoardSize,Board, w);
    write('Invalid board size. Please enter 4 or 5.'),
    start_game.
    


% If check matrix fails, handle matrix
process_option_game(1, Board, Player,BoardSize, NewBoard) :-
    write('Which row?'),
    read(Row),
    write('Which column?'),
    read(Column),
    check_matrix(Row, Column,BoardSize),
    (write('HEREEEEEEEEEE'),
    nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    Length == 0 ->
    place_disk(Board, Row, Column, Player, NewBoard);
    handle_invalid_not_empty(Board, Player,BoardSize, NewBoard));
    handle_invalid_matrix(Board, Player,BoardSize, NewBoard).
    

process_option_game(2, Board, Player,BoardSize, NewBoard) :-
    write('Choose the row of the tower you want to move:'),
    read(Row),
    write('Choose the column of the tower you want to move:'),
    read(Column),
    write('Choose the row where you want to move the tower:'),
    read(NewRow),
    write('Choose the column where you want to move the tower:'),
    read(NewColumn),
    check_matrix(Row, Column,BoardSize),check_matrix(NewRow, NewColumn,BoardSize),
    (nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    move_piece(Length, Row, Column, NewRow, NewColumn) ->
    move_tower(Board,Player ,Row, Column, NewRow, NewColumn, NewBoard);
    handle_invalid_moves(Board, Player,BoardSize, NewBoard));
    handle_invalid_matrix(Board, Player,BoardSize, NewBoard).
    


process_option_game(3, Board, Player,BoardSize, NewBoard) :-
    write('Choose the row of the tower you want to move:'),
    read(Row),
    write('Choose the column of the tower you want to move:'),
    read(Column),
    write('Choose the row where you want to move the tower:'),
    read(NewRow),
    write('Choose the column where you want to move the tower:'),
    read(NewColumn),
    check_matrix(Row, Column, BoardSize),check_matrix(NewRow, NewColumn,BoardSize),
    (nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    move_piece(Length, Row, Column, NewRow, NewColumn) ->
    write('How many pieces do you want to move?'),
    read(Amount),
    move_part_tower(Board, Player, Amount, Row, Column, NewRow, NewColumn, NewBoard);
    handle_invalid_moves(Board, Player,BoardSize, NewBoard));
    handle_invalid_matrix(Board, Player,BoardSize, NewBoard).



process_option_game(_,Board,Player,BoardSize,NewBoard) :- 
    write('INVALID OPTION!'), nl,
    game_loop(BoardSize,Board, Player).

% ---------------------------------------




check_matrix(Row, Column,BoardSize) :-
    is_valid(Row, Column,BoardSize).

is_valid(X, Y,BoardSize) :-
    limits(0, BoardSize -1, X),
    limits(0, BoardSize-1, Y).

limits(Low, High, Low) :- Low =< High.
limits(Low, High, Value) :-
    Low < High,
    Next is Low + 1,
    limits(Next, High, Value).

% ---------------------------------------

next_player(w, b).
next_player(b, w).


game_loop(BoardSize,Board, Player) :-
    print_board(BoardSize,Board), nl, nl,
    print_menu_game,
    write('Player '), write(Player), write(' turn:'), nl, nl,
    read(OptionGame), nl,nl,
    process_option_game(OptionGame, Board, Player,BoardSize, NewBoard),
    (check_win(NewBoard, Player) -> print_board(BoardSize,NewBoard), nl, nl, !;
    next_player(Player, NextPlayer),
    game_loop(BoardSize,NewBoard, NextPlayer)).



% Check if a player has won
check_win(Board, Player) :-
    % For each row in the board
    member(Row, Board),
    % For each column in the row
    member(Tower, Row),
    % If the length of the tower is 6 or more
    length(Tower, Length),
    Length >= 6,
    % Get the top disk of the tower
    nth0(0, Tower, TopDisk),
    % If the top disk matches the current player's color, the current player wins
    (TopDisk == Player ->
        write('Player '), write(Player), write(' wins!'), nl;
        % If the top disk matches the other player's color, the other player wins
        next_player(Player, OtherPlayer),
        TopDisk == OtherPlayer ->
            write('Player '), write(OtherPlayer), write(' wins!'), nl),
    !.
    
move_piece(1, OldRow, OldColumn, NewRow, NewColumn) :-
    move1(OldRow, OldColumn, NewRow, NewColumn).

move1(OldRow, OldColumn, NewRow, NewColumn) :-
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


handle_invalid_input(Board, Player,BoardSize, NewBoard):-
    write('INVALID INPUT!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, Board, Player,BoardSize, NewBoard).

handle_invalid_matrix(Board, Player,BoardSize, NewBoard):-
    write('NOT IN BOARD RANGE!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, Board, Player,BoardSize, NewBoard).
    

handle_invalid_moves(Board, Player,BoardSize, NewBoard):-
    write('INVALID MOVES!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, Board, Player,BoardSize, NewBoard).

handle_invalid_not_empty(Board, Player,BoardSize, NewBoard):-
    write('NOT EMPTY!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, Board, Player,BoardSize, NewBoard).









