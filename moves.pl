:- consult('utils.pl').


% Updates the game state by placing the player's disk at the specified row and column.
place_disk(GameState, Row, Column, Player, NewGameState) :-
    nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    append([Player], ColumnList, NewColumnList),
    replace(RowList, Column, NewColumnList, NewRowList),
    replace(GameState, Row, NewRowList, NewGameState), !.
    

% Transfers a tower from one position to another in the game state.
move(GameState, OldRow, OldColumn, NewRow, NewColumn, NewGameState) :-
    nth0(OldRow, GameState, OldRowList),
    nth0(OldColumn, OldRowList, OldColumnList),
    length(OldColumnList, Length),
    Length > 0,
    nth0(NewRow, GameState, NewRowList),
    nth0(NewColumn, NewRowList, NewColumnList),
    length(NewColumnList, Length2),
    Length2 \= 0 ->
    append(OldColumnList, NewColumnList, StackToPlace),
    Remaining = [],
    replaces(GameState, OldRow, OldColumn, NewRow, NewColumn, NewRowList, StackToPlace,Remaining, NewGameState),
    write('Tower moved!'), nl, nl.
    
    
% Moves a specified amount of disks from one tower to another.
move(GameState, Amount, OldRow, OldColumn, NewRow, NewColumn, NewGameState) :-
    nth0(OldRow, GameState, OldRowList),
    nth0(OldColumn, OldRowList, OldColumnList),
    length(OldColumnList, Length),
    Length >= Amount,
    take(Amount, OldColumnList, PartToMove, Remaining),

    nth0(NewRow, GameState, NewRowList),
    nth0(NewColumn, NewRowList, NewColumnList),
    append(PartToMove, NewColumnList, StackToPlace),
    replaces(GameState, OldRow, OldColumn, NewRow, NewColumn, NewRowList, StackToPlace, Remaining, NewGameState),
    write('Part of tower moved!'), nl, nl.


% Replaces a list with another list in a list of lists. This is used to update the game state after a move.
replaces(GameState, OldRow, OldColumn, NewRow, NewColumn, NewRowList, StackToPlace, Remaining, NewGameState) :- 
    replace(NewRowList, NewColumn, StackToPlace, ListStack),
    replace(GameState, NewRow, ListStack, NewGameState1),
    nth0(OldRow, NewGameState1, OldRowList),
    replace(OldRowList, OldColumn, Remaining, UpdatedList),
    replace(NewGameState1, OldRow, UpdatedList, NewGameState).

% Checks if a move is valid for a stack according to it' size.
valid_moves(1, OldRow, OldColumn, NewRow, NewColumn) :-
    NewRow =:= OldRow + 1, NewColumn =:= OldColumn;
    NewRow =:= OldRow - 1, NewColumn =:= OldColumn;
    NewRow =:= OldRow, NewColumn =:= OldColumn + 1;
    NewRow =:= OldRow, NewColumn =:= OldColumn - 1.

valid_moves(2, OldRow, OldColumn, NewRow, NewColumn) :-
        OldColumn =:= NewColumn, NewRow \== OldRow;
        OldRow =:= NewRow,  NewColumn \== OldColumn.

valid_moves(3, OldRow, OldColumn, NewRow, NewColumn) :-
    RowDiff is abs(NewRow - OldRow), ColumnDiff is abs(NewColumn - OldColumn),
    ((RowDiff =:= 1, ColumnDiff =:= 2) ; (RowDiff =:= 2, ColumnDiff =:= 1)).

valid_moves(4, OldRow, OldColumn, NewRow, NewColumn) :-
    OldRow =\= NewRow,
    OldColumn =\= NewColumn,
    RowDiff is abs(NewRow - OldRow),
    ColumnDiff is abs(NewColumn - OldColumn),
    RowDiff =:= ColumnDiff.

valid_moves(5, OldRow, OldColumn, NewRow, NewColumn) :-
    \+((OldRow =:= NewRow, OldColumn =:= NewColumn)),
    (OldRow =:= NewRow ; OldColumn =:= NewColumn ; 
    (RowDiff is abs(NewRow - OldRow), ColumnDiff is abs(NewColumn - OldColumn), RowDiff =:= ColumnDiff)).

