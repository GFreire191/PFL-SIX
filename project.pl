:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).

:- consult('board.pl').
:- consult('menu.pl').
:- consult('utils.pl').
:- consult('moves.pl').
:- consult('robot.pl').


clear :- write('\33\[2J').

% ---------------------------------------



play :-
    print_menu,
    read(Option), nl,
    process_option(Option).


%Player vs Player Loop
process_option(1) :-
    nl,
    start_game(1).

%Player vs Robot Loop
process_option(2) :-
    nl,
    start_game(2).

%Robot vs Robot Loop
process_option(3):-
    nl,
    start_game(3).

process_option(4) :-
    play.

process_option(5) :- 
    !, write('Goodbye!'), nl.

process_option(_) :- 
    write('Invalid Option!'), nl,
    play.


next_player(w, b).
next_player(b, w).

% --------------------------------------- START GAME ---------------------------------------

start_game(1) :-
    write('What is the board Size? (4,5)'),
    read(BoardSize),
    (BoardSize == 4 ; BoardSize == 5) -> 
        initial_GameState(BoardSize,GameState),
        game_loop(BoardSize,GameState, w);
    write('Invalid board size. Please enter 4 or 5.'),
    start_game(1).

start_game(2) :-
    write('What is the board Size? (4,5)'),
    read(BoardSize),
    (BoardSize == 4 ; BoardSize == 5) -> 
        initial_GameState(BoardSize,GameState),
        game_loop_PR(BoardSize,GameState, w); %Loop of player vs Robot
    write('Invalid board size. Please enter 4 or 5.'),
    start_game(2).
    


start_game(3) :-
    write('What is the board Size? (4,5)'),
    read(BoardSize),
    (BoardSize == 4 ; BoardSize == 5) -> 
        initial_GameState(BoardSize,GameState),
        game_loop_RR(BoardSize,GameState,w); %Loop of Robot vs Robot
    write('Invalid board size. Please enter 4 or 5.'),
    start_game(3).

% --------------------------------------- END OF START GAME ---------------------------------------


% --------------------------------------- GAME LOOP ---------------------------------------

%Classic game loop, player vs player
game_loop(BoardSize,GameState, Player) :-
    displayBoard(BoardSize,GameState), nl, nl,
    print_menu_game,
    write('Player '), write(Player), write(' turn:'), nl, nl,
    read(OptionGame), nl,nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState),
    (check_win(NewGameState, Player) -> displayBoard(BoardSize,NewGameState), nl, nl, !;
    next_player(Player, NextPlayer),
    game_loop(BoardSize,NewGameState, NextPlayer)).


%Loop of player vs robot, the robot chooses a random move

game_loop_PR(BoardSize, GameState, Player) :-
    displayBoard(BoardSize, GameState), nl, nl,
    (Player == w ->
        print_menu_game,
        write('Player '), write(Player), write(' turn:'), nl, nl,
        read(OptionGame), nl, nl,
        process_option_game(OptionGame, GameState, Player, BoardSize, NewGameState)
    ;
        write('Einstein turn:'), nl, nl,
        random_between(1, 3, OptionGame),
        robot_move(OptionGame, GameState, b, BoardSize, NewGameState)
    ),
    (check_win(NewGameState, Player) ->
        displayBoard(BoardSize, NewGameState), nl, nl, !
    ;
        next_player(Player, NextPlayer),
        game_loop_PR(BoardSize, NewGameState, NextPlayer)
    ).


%Loop of robot vs robot, the robot chooses a random move
%Pause the program for 1 second to make it easier to see the moves
game_loop_RR(BoardSize,GameState,Player):-
    displayBoard(BoardSize,GameState), nl, nl,
    write('Einstein '), write(Player), write(' turn:'), nl, nl,
    random_between(1, 3, OptionGame),
    print(OptionGame),nl,
    robot_move(OptionGame, GameState, Player, BoardSize, NewGameState),
    (check_win(NewGameState, Player) ->
        displayBoard(BoardSize, NewGameState), nl, nl, !
    ;
        next_player(Player, NextPlayer),
        sleep(1),
        game_loop_RR(BoardSize, NewGameState, NextPlayer)
    ).

%--------------------------------------- END OF GAME LOOP ---------------------------------------


% --------------------------------------- PROCESS OPTION GAME ---------------------------------------

process_option_game(1, GameState, Player,BoardSize, NewGameState) :-
    write('Which row?'),
    read(Row),
    write('Which column?'),
    read(Column),
    check_matrix(Row, Column,BoardSize),
    (nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    Length == 0 ->
    place_disk(GameState, Row, Column, Player, NewGameState);
    handle_invalid_not_empty(GameState, Player,BoardSize, NewGameState));
    handle_invalid_matrix(GameState, Player,BoardSize, NewGameState).
    

process_option_game(2, GameState, Player,BoardSize, NewGameState) :-
    write('Choose the row of the tower you want to move:'),
    read(Row),
    write('Choose the column of the tower you want to move:'),
    read(Column),
    write('Choose the row where you want to move the tower:'),
    read(NewRow),
    write('Choose the column where you want to move the tower:'),
    read(NewColumn),
    check_matrix(Row, Column,BoardSize),check_matrix(NewRow, NewColumn,BoardSize),
    (nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    check_moves(Length, Row, Column, NewRow, NewColumn) ->
    move_tower(GameState,Row, Column, NewRow, NewColumn, NewGameState);
    handle_invalid_moves(GameState, Player,BoardSize, NewGameState));
    handle_invalid_matrix(GameState, Player,BoardSize, NewGameState).
    


process_option_game(3, GameState, Player,BoardSize, NewGameState) :-
    write('Choose the row of the tower you want to move:'),
    read(Row),
    write('Choose the column of the tower you want to move:'),
    read(Column),
    write('Choose the row where you want to move the tower:'),
    read(NewRow),
    write('Choose the column where you want to move the tower:'),
    read(NewColumn),
    check_matrix(Row, Column, BoardSize),check_matrix(NewRow, NewColumn,BoardSize),
    (nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    check_moves(Length, Row, Column, NewRow, NewColumn) ->
    write('How many pieces do you want to move?'),
    read(Amount),
    move_part_tower(GameState, Amount, Row, Column, NewRow, NewColumn, NewGameState);
    handle_invalid_moves(GameState, Player,BoardSize, NewGameState));
    handle_invalid_matrix(GameState, Player,BoardSize, NewGameState).



process_option_game(_,GameState,Player,BoardSize,NewGameState) :- 
    write('INVALID OPTION!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).

    

% --------------------------------------- END OF PROCESS OPTION GAME ---------------------------------------
    
        
        
   




    
% --------------------------------------- CHECK IF SOMEONE WON ---------------------------------------
% Check if a player has won
check_win(GameState, Player) :-
    % For each row in the board
    member(Row, GameState),
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
    
% --------------------------------------- END OF CHECK IF SOMEONE WON ---------------------------------------


% --------------------------------------- HANDLE INVALID INPUT ---------------------------------------

handle_invalid_input(GameState, Player,BoardSize, NewGameState):-
    write('INVALID INPUT!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).

handle_invalid_matrix(GameState, Player,BoardSize, NewGameState):-
    write('NOT IN GameState RANGE!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).
    

handle_invalid_moves(GameState, Player,BoardSize, NewGameState):-
    write('INVALID MOVES!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).

handle_invalid_not_empty(GameState, Player,BoardSize, NewGameState):-
    write('NOT EMPTY!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).


% --------------------------------------- END OF HANDLE INVALID INPUT ---------------------------------------






%Gerar numeros aleatorios entre x e y
random_between(X,Y,R) :-
    Y1 is Y+1,
    random(X,Y1,R).

%Gerar numeros aleatorios dentro de uma lista
random_mem(X,L) :-
    length(L,Len),
    random_between(0,Len,Index),
    nth0(Index,L,X).









