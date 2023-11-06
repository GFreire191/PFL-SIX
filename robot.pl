



%Robot move(1) usa o place disk para colocar um disco numa posicao aleatoria
computer_move(1, GameState, Player,BoardSize, NewGameState) :-
    random_between(0, BoardSize, Row),
    random_between(0, BoardSize, Column),
    (nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    Length == 0 ->
    place_disk(GameState, Row, Column, Player, NewGameState),
    write('Einstein placed a disk in row '), write(Row), write(' and column '), write(Column), write('.'), nl;
    random_between(1,3,Option),
    computer_move(Option, GameState,Player,BoardSize, NewGameState)).

%Robot move(2) move uma torre para uma posicao aleatoria

computer_move(2, GameState,Player,BoardSize, NewGameState) :-
    random_between(0, BoardSize, Row),
    random_between(0, BoardSize, Column),
    random_between(0, BoardSize, NewRow),
    random_between(0, BoardSize, NewColumn),
    (nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    nth0(NewRow, GameState, NewRowList),
    nth0(NewColumn, NewRowList, NewColumnList),
    length(NewColumnList, NewLength),
    NewLength \=0,
    valid_moves(Length, Row, Column, NewRow, NewColumn) ->
    move(GameState, Row, Column, NewRow, NewColumn, NewGameState),
    write('Einstein moved a tower from row '), write(Row), write(' and column '), write(Column), write(' to row '), write(NewRow), write(' and column '), write(NewColumn), write('.'), nl;
    random_between(1,3,Option),
    computer_move(Option, GameState,Player,BoardSize, NewGameState)).
    



%Robot move(3) move uma parte de uma torre para uma posicao aleatoria

computer_move(3, GameState,Player,BoardSize, NewGameState) :-
    random_between(0, BoardSize, Row),
    random_between(0, BoardSize, Column),
    random_between(0, BoardSize, NewRow),
    random_between(0, BoardSize, NewColumn),
    (nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    nth0(NewRow, GameState, NewRowList),
    nth0(NewColumn, NewRowList, NewColumnList),
    length(NewColumnList, NewLength),
    NewLength \=0,
    valid_moves(Length, Row, Column, NewRow, NewColumn) ->
    random_between(1, Length, Amount),
    move(GameState, Amount, Row, Column, NewRow, NewColumn, NewGameState),
    write('Einstein moved '), write(Amount), write(' pieces of a tower from row '), write(Row), write(' and column '), write(Column), write(' to row '), write(NewRow), write(' and column '), write(NewColumn), write('.'), nl;
    random_between(1,3,Option),
    computer_move(Option, GameState,Player,BoardSize, NewGameState)).
