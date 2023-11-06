:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).


:- consult('board.pl').
:- consult('menu.pl').
:- consult('utils.pl').
:- consult('moves.pl').
:- consult('computer.pl').


clear :- write('\33\[2J').


%
play :-
    print_menu,
    read(Option), nl,
    process_option_menu(Option).


% Process the user's option from the main menu
process_option_menu(1) :-
    nl,
    start_game(1).

process_option_menu(2) :-
    nl,
    start_game(2).

process_option_menu(3):-
    nl,
    start_game(3).

process_option_menu(4) :-
    print_instructions,
    read(_),
    play.

process_option_menu(5) :-
    !, write('Goodbye!'), nl.

% If the user selects an invalid option, display an error message and return to the menu
process_option_menu(_) :-
    write('Invalid Option!'), nl,
    play.

% Switch the current player
next_player(w, b).
next_player(b, w).



% Start a game with respective option
start_game(1) :-
    write('What is the board Size? (4,5)'),
    read(BoardSize),
    (BoardSize == 4 ; BoardSize == 5) -> 
        initial_state(BoardSize,GameState),
        game_loop_HH(BoardSize,GameState, w);
    write('Invalid board size. Please enter 4 or 5.'),
    start_game(1).

start_game(2) :-
    write('What is the board Size? (4,5)'),
    read(BoardSize),
    (BoardSize == 4 ; BoardSize == 5) -> 
        initial_state(BoardSize,GameState),
        game_loop_HC(BoardSize,GameState, w);
    write('Invalid board size. Please enter 4 or 5.'),
    start_game(2).
    
start_game(3) :-
    write('What is the board Size? (4,5)'),
    read(BoardSize),
    (BoardSize == 4 ; BoardSize == 5) -> 
        initial_state(BoardSize,GameState),
        game_loop_PC(BoardSize,GameState,w);
    write('Invalid board size. Please enter 4 or 5.'),
    start_game(3).


% Game loop for Player vs Player mode

game_loop_HH(BoardSize,GameState, Player) :-
    display_game(BoardSize,GameState), nl, nl,
    print_menu_game,
    count_pieces(GameState, Player, Count),
    DisksNum is (BoardSize - 1) * 4 - Count,
    write('Player '), write(Player), write(' has '), write(DisksNum), write(' pieces left.'), nl,
    write('Player '), write(Player), write(' turn:'), nl, nl,
    read(OptionGame), nl,nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState),
    (game_over(NewGameState, Player) -> display_game(BoardSize,NewGameState), nl, nl, !;
    next_player(Player, NextPlayer),
    game_loop_HH(BoardSize,NewGameState, NextPlayer)).

% Game loop for Player vs Computer mode

game_loop_HC(BoardSize, GameState, Player) :-
    display_game(BoardSize, GameState), nl, nl,
    count_pieces(GameState, Player, Count),
    (Player == w ->
        print_menu_game,
        DisksNum is (BoardSize - 1) * 4 - Count,
        write('Player '), write(Player), write(' has '), write(DisksNum), write(' pieces left.'), nl,
        write('Player '), write(Player), write(' turn:'), nl, nl,
        read(OptionGame), nl, nl,
        process_option_game(OptionGame, GameState, Player, BoardSize, NewGameState)
    ;
        write('Computer '), write(' has '), write((BoardSize - 1)*4 - Count), write(' pieces left.'), nl,       
        write('Computer turn:'), nl, nl,
        random_between(1, 3, OptionGame),
        computer_move(OptionGame, GameState, b, BoardSize, NewGameState)
    ),
    (game_over(NewGameState, Player) ->
        display_game(BoardSize, NewGameState), nl, nl, !
    ;
        next_player(Player, NextPlayer),
        game_loop_HC(BoardSize, NewGameState, NextPlayer)
    ).


% Game loop for Computer vs Computer mode

game_loop_PC(BoardSize, GameState, Player) :-
    display_game(BoardSize,GameState), nl, nl,
    count_pieces(GameState, Player, Count),
    DisksNum is (BoardSize - 1) * 4 - Count,
    write('Computer '), write(Player), write(' has '), write(DisksNum), write(' pieces left.'), nl,
    write('Computer '), write(Player), write(' turn:'), nl, nl,
    random_between(1, 3, OptionGame),
    computer_move(OptionGame, GameState, Player, BoardSize, NewGameState),
    (game_over(NewGameState, Player) ->
        display_game(BoardSize, NewGameState), nl, nl, !
    ;
        next_player(Player, NextPlayer),
        sleep(1),
        game_loop_PC(BoardSize, NewGameState, NextPlayer)
    ).

% Process the user's option from the game menu
process_option_game(1, GameState, Player,BoardSize, NewGameState) :-
    count_pieces(GameState, Player, Count),
    write('Which row?'),
    read(Row),
    write('Which column?'),
    read(Column),
    check_matrix(Row, Column,BoardSize),
    (nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    Count < (BoardSize - 1) * 4,
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
    valid_moves(Length, Row, Column, NewRow, NewColumn) ->
    move(GameState,Row, Column, NewRow, NewColumn, NewGameState);
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
    valid_moves(Length, Row, Column, NewRow, NewColumn) ->
    write('How many pieces do you want to move?'),
    read(Amount),
    move(GameState, Amount, Row, Column, NewRow, NewColumn, NewGameState);
    handle_invalid_moves(GameState, Player,BoardSize, NewGameState));
    handle_invalid_matrix(GameState, Player,BoardSize, NewGameState).

% If the user selects an invalid option, display an error message and return to the menu
process_option_game(_,GameState,Player,BoardSize,NewGameState) :- 
    write('|-----------------------------|'), nl,
    write('| INVALID INPUT!              |'), nl,
    write('|-----------------------------|'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).


% Check if a player has won
game_over(GameState, Player) :-
    member(Row, GameState),
    member(Tower, Row),
    length(Tower, Length),
    Length >= 6,
    nth0(0, Tower, TopDisk),
    (TopDisk == Player ->
        nl,nl,write('Player '), write(Player), write(' wins!'), nl,nl;
        next_player(Player, OtherPlayer),
        TopDisk == OtherPlayer ->
            write('Player '), write(OtherPlayer), write(' wins!'), nl),
    !.


% Handle invalid inputs
handle_invalid_input(GameState, Player,BoardSize, NewGameState):-
    nl,
    write('|-----------------------------|'), nl,
    write('| INVALID INPUT!              |'), nl,
    write('|-----------------------------|'), nl, nl, nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).

handle_invalid_matrix(GameState, Player,BoardSize, NewGameState):-
    nl,
    write('|-----------------------------|'), nl,
    write('| NOT IN RANGE!               |'), nl,
    write('|-----------------------------|'), nl, nl, nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).
    
handle_invalid_moves(GameState, Player,BoardSize, NewGameState):-
    nl,
    write('|-----------------------------|'), nl,
    write('| INVALID MOVES!              |'), nl,
    write('|-----------------------------|'), nl, nl, nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).

handle_invalid_not_empty(GameState, Player,BoardSize, NewGameState):-
    nl,
    write('|-----------------------------|'), nl,
    write('| NOT EMPTY!                  |'), nl,
    write('|-----------------------------|'), nl, nl, nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, GameState, Player,BoardSize, NewGameState).







