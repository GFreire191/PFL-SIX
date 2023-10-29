

handle_ivalid_moves(Board, Player, NewBoard):-
    write('INVALID OPTION!'), nl, write('You can only place a disk in an empty spot!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, Board, Player, NewBoard).

handle_invalid_input(Board, Player, NewBoard):-
    write('INVALID OPTION! The input is off limits!'), nl,
    print_menu_game,
    read(OptionGame),nl,
    process_option_game(OptionGame, Board, Player, NewBoard).
    

handle_invalid_input(Board, Player, NewBoard,1):-
    write('INVALID OPTION!'), nl, write('The input might have been off limits!'), nl, write('If not, check if you have any disks left!'), nl,
    print_menu_game,
    player_disks(Player, Disks),
    print_player_disks(Player, Disks),
    read(OptionGame),nl,
    process_option_game(OptionGame, Board, Player, NewBoard).

