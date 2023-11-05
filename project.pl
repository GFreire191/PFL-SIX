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
    check_matrix(Row, Column),check_matrix(NewRow, NewColumn),
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
    check_matrix(Row, Column),check_matrix(NewRow, NewColumn),
    (nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    move_piece(Length, Row, Column, NewRow, NewColumn) ->
    write('How many pieces do you want to move?'),
    read(Amount),
    move_part_tower(Board, Player, Amount, Row, Column, NewRow, NewColumn, NewBoard);
    handle_invalid_moves(Board, Player,BoardSize, NewBoard));
    handle_invalid_matrix(Board, Player,BoardSize, NewBoard).

    

process_option_game(_) :- 
    write('INVALID OPTION!'), nl,
    print_menu_game.

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
    write(NewBoard),nl,nl.

    


replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):-
    I > -1,
    NI is I-1,
    replace(T, NI, X, R), !.
replace(L, _, _, L).



move_tower(Board,Player, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-
    
    append_tower(Board, OldRow, OldColumn, NewRow, NewColumn, NewBoard),
    write('Tower moved!'), nl, nl;
    
    handle_invalid_input(Board, Player, NewBoard).




move_part_tower(Board, Player, Amount, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-
    nth0(OldRow, Board, OldRowList),
    nth0(OldColumn, OldRowList, OldColumnList),
    length(OldColumnList, Length),
    Length >= Amount,
    take(Amount, OldColumnList, PartToMove, Remaining),
    nth0(NewRow, Board, NewRowList),
    nth0(NewColumn, NewRowList, NewColumnList),
    length(NewColumnList, Length2),
    Length2 \= 0,
    append(PartToMove, NewColumnList, NewColumnList2),
    replace(NewRowList, NewColumn, NewColumnList2, NewRowList2),
    replace(Board, NewRow, NewRowList2, NewBoard1),
    replace(OldRowList, OldColumn, Remaining, NewRowList3),
    replace(NewBoard1, OldRow, NewRowList3, NewBoard),
    write('Part of tower moved!'), nl, nl;
    handle_invalid_input(Board, Player,_, NewBoard).

take(0, List, [], List).
take(N, [H|T], [H|Res], Rem) :-
    N > 0,
    N1 is N - 1,
    take(N1, T, Res, Rem).
    



append_tower(Board, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-
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
    
    replaces(Board, OldRow, OldColumn, NewRow, NewColumn, OldRowList, OldColumnList, NewRowList, NewColumnList, NewColumnList2, NewBoard).


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


% handlesssssss


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








