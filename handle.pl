:- consult('project.pl').
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