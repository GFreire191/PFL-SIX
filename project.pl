:- use_module(library(lists)).
:- use_module(library(random)).

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
    start_game(1).

process_option(2) :-
    nl,
    start_game(2).

process_option(4) :-
    makeSix.

process_option(5) :- 
    !, write('Goodbye!'), nl.

process_option(_) :- 
    write('Invalid Option!'), nl,
    makeSix.

% ---------------------------------------

start_game(1) :-
    write('What is the board Size? (4,5)'),
    read(BoardSize),
    (BoardSize == 4 ; BoardSize == 5) -> 
        initial_GameState(BoardSize,Board),
        game_loop(BoardSize,Board, w);
    write('Invalid board size. Please enter 4 or 5.'),
    start_game(1).

start_game(2) :-
    write('What is the board Size? (4,5)'),
    read(BoardSize),
    (BoardSize == 4 ; BoardSize == 5) -> 
        initial_board(BoardSize,Board),
        game_loop_PR(BoardSize,Board, w); %Loop of player vs Robot
    write('Invalid board size. Please enter 4 or 5.'),
    start_game(2).
    


% If check matrix fails, handle matrix
process_option_game(1, Board, Player,BoardSize, NewBoard) :-
    write('Which row?'),
    read(Row),
    write('Which column?'),
    read(Column),
    check_matrix(Row, Column,BoardSize),
    (nth0(Row, Board, RowList),
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



% ---------------------------------------

next_player(w, b).
next_player(b, w).


game_loop(BoardSize,Board, Player) :-
    displayBoard(BoardSize,Board), nl, nl,
    print_menu_game,
    write('Player '), write(Player), write(' turn:'), nl, nl,
    read(OptionGame), nl,nl,
    process_option_game(OptionGame, Board, Player,BoardSize, NewBoard),
    (check_win(NewBoard, Player) -> displayBoard(BoardSize,NewBoard), nl, nl, !;
    next_player(Player, NextPlayer),
    game_loop(BoardSize,NewBoard, NextPlayer)).


%Loop of player vs robot, the robot chooses a random move

game_loop_PR(BoardSize, Board, Player) :-
    displayBoard(BoardSize, Board), nl, nl,
    (Player == w ->
        print_menu_game,
        write('Player '), write(Player), write(' turn:'), nl, nl,
        read(OptionGame), nl, nl,
        process_option_game(OptionGame, Board, Player, BoardSize, NewBoard)
    ;
        write('Robot turn:'), nl, nl,
        random_between(1, 3, OptionGame),
        robot_move(OptionGame, Board, b, BoardSize, NewBoard)
    ),
    (check_win(NewBoard, Player) ->
        displayBoard(BoardSize, NewBoard), nl, nl, !
    ;
        next_player(Player, NextPlayer),
        game_loop_PR(BoardSize, NewBoard, NextPlayer)
    ).

    
%Robot move(1) usa o place disk para colocar um disco numa posicao aleatoria
robot_move(1, Board, b,BoardSize, NewBoard) :-
    random_between(0, BoardSize, Row),
    random_between(0, BoardSize, Column),
    (nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    Length == 0 ->
    place_disk(Board, Row, Column, b, NewBoard),
    write('Robot placed a disk in row '), write(Row), write(' and column '), write(Column), write('.'), nl;
    robot_move(1, Board, b,BoardSize, NewBoard)).

%Robot move(2) usa o move_tower para mover uma torre para uma posicao aleatoria
robot_move(2, Board, b,BoardSize, NewBoard) :-
    random_between(0, BoardSize, Row),
    random_between(0, BoardSize, Column),
    random_between(0, BoardSize, NewRow),
    random_between(0, BoardSize, NewColumn),
    (nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    nth0(NewRow, Board, NewRowList),
    nth0(NewColumn, NewRowList, NewColumnList),
    length(NewColumnList, NewLength),
    NewLength \=0,
    move_piece(Length, Row, Column, NewRow, NewColumn) ->
    move_tower(Board, b, Row, Column, NewRow, NewColumn, NewBoard),
    write('Robot moved a tower from row '), write(Row), write(' and column '), write(Column), write(' to row '), write(NewRow), write(' and column '), write(NewColumn), write('.'), nl;
    robot_move(2, Board, b,BoardSize, NewBoard)).



%Robot move(3) usa o move_part_tower para mover uma parte de uma torre para uma posicao aleatoria

robot_move(3, Board, b,BoardSize, NewBoard) :-
    random_between(0, BoardSize, Row),
    random_between(0, BoardSize, Column),
    random_between(0, BoardSize, NewRow),
    random_between(0, BoardSize, NewColumn),
    (nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    nth0(NewRow, Board, NewRowList),
    nth0(NewColumn, NewRowList, NewColumnList),
    length(NewColumnList, NewLength),
    NewLength \=0,
    move_piece(Length, Row, Column, NewRow, NewColumn) ->
    random_between(1, Length, Amount),
    move_part_tower(Board, b, Amount, Row, Column, NewRow, NewColumn, NewBoard),
    write('Robot moved '), write(Amount), write(' pieces of a tower from row '), write(Row), write(' and column '), write(Column), write(' to row '), write(NewRow), write(' and column '), write(NewColumn), write('.'), nl;
    robot_move(3, Board, b,BoardSize, NewBoard)).

    
    
        
        
   




    

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






%Gerar numeros aleatorios entre x e y
random_between(X,Y,R) :-
    Y1 is Y+1,
    random(X,Y1,R).

%Gerar numeros aleatorios dentro de uma lista
random_mem(X,L) :-
    length(L,Len),
    random_between(0,Len,Index),
    nth0(Index,L,X).









