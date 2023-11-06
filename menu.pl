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
    write('| Choose an option            |'), nl,
    nl, nl.


    print_instructions :-
    write('|-------------------------------------------------------------------------------------------------------|'), nl,
    write('|                                              INSTRUCTIONS                                             |'), nl,
    write('|-------------------------------------------------------------------------------------------------------|'), nl,
    write('|  The goal of the game is to make a stack of 6 pieces, with your color on top                          |'), nl,
    write('|  The pieces move accordingly to their size                                                            |'), nl,
    write('|                                                                                                       |'), nl,
    write('|  1. Pawn - 1 space horizontal or vertical                                                             |'), nl,
    write('|  2. Rook - any number of spaces horizontal or vertical                                                |'), nl,
    write('|  3. Knight  "L" shape; 1 step orthogonal, 1 step diagonal                                             |'), nl,
    write('|  4. Bishop any number of spaces diagonally                                                            |'), nl,
    write('|  5. Queen any number of spaces in any direction                                                       |'), nl,
    write('|  6. King - wins, no moves                                                                             |'), nl,
    write('|                                                                                                       |'), nl,
    write('|  You can move any number of pieces from any stack,  but always to a square that is already occupied   |'), nl,
    write('|-------------------------------------------------------------------------------------------------------|'), nl,
    write('|  Type anything to go back to the main menu                                                            |'), nl.

