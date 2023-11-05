:- consult('utils.pl').

% Place a new disk. Add a disk to the board, at the beggining of the list located at the given row and column.

place_disk(Board, Row, Column, Player, NewBoard) :-
    nth0(Row, Board, RowList),
    nth0(Column, RowList, ColumnList),
    append([Player], ColumnList, NewColumnList),
    replace(RowList, Column, NewColumnList, NewRowList),
    replace(Board, Row, NewRowList, NewBoard).
    




move_tower(Board,Player, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-
    
    append_tower(Board, OldRow, OldColumn, NewRow, NewColumn, NewBoard),
    write('Tower moved!'), nl, nl.
    


move_part_tower(Board, Player, Amount, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-
    nth0(OldRow, Board, OldRowList),
    nth0(OldColumn, OldRowList, OldColumnList),
    length(OldColumnList, Length),
    Length >= Amount,
    take(Amount, OldColumnList, PartToMove, Remaining),
    nth0(NewRow, Board, NewRowList),
    nth0(NewColumn, NewRowList, NewColumnList),
    append(PartToMove, NewColumnList, NewColumnList2),
    replace(NewRowList, NewColumn, NewColumnList2, NewRowList2),
    replace(Board, NewRow, NewRowList2, NewBoard1),
    replace(OldRowList, OldColumn, Remaining, NewRowList3),
    replace(NewBoard1, OldRow, NewRowList3, NewBoard),
    write('Part of tower moved!'), nl, nl.



append_tower(Board, OldRow, OldColumn, NewRow, NewColumn, NewBoard) :-
    nth0(OldRow, Board, OldRowList),

    nth0(OldColumn, OldRowList, OldColumnList),

    length(OldColumnList, Length),
    Length > 0,

    nth0(NewRow, Board, NewRowList),

    nth0(NewColumn, NewRowList, NewColumnList),

    length(NewColumnList, Length2),
    Length2 \= 0 ->

    append(OldColumnList, NewColumnList, NewColumnList2),
    
    replaces(Board, OldRow, OldColumn, NewRow, NewColumn, OldRowList, OldColumnList, NewRowList, NewColumnList, NewColumnList2, NewBoard).


replaces(Board, OldRow, OldColumn, NewRow, NewColumn, OldRowList, OldColumnList, NewRowList, NewColumnList, NewColumnList2, NewBoard) :- 

    replace(NewRowList, NewColumn, NewColumnList2, NewRowList2),

    replace(Board, NewRow, NewRowList2, NewBoard1),

    nth0(OldRow, NewBoard1, Remover),

    nth0(OldColumn, Remover, Removido),

    
    replace(Remover, OldColumn, [], NewRowList3),

    replace(NewBoard1, OldRow, NewRowList3, NewBoard).





move_piece(1, OldRow, OldColumn, NewRow, NewColumn) :-
    NewRow =:= OldRow + 1, NewColumn =:= OldColumn;
    NewRow =:= OldRow - 1, NewColumn =:= OldColumn;
    NewRow =:= OldRow, NewColumn =:= OldColumn + 1;
    NewRow =:= OldRow, NewColumn =:= OldColumn - 1.


    
    


    

move_piece(2, OldRow, OldColumn, NewRow, NewColumn) :-
        OldColumn =:= NewColumn, NewRow \== OldRow;
        OldRow =:= NewRow,  NewColumn \== OldColumn.
    
    




move_piece(3, OldRow, OldColumn, NewRow, NewColumn) :-
    RowDiff is abs(NewRow - OldRow), ColumnDiff is abs(NewColumn - OldColumn),
    ((RowDiff =:= 1, ColumnDiff =:= 2) ; (RowDiff =:= 2, ColumnDiff =:= 1)).
    


move_piece(4, OldRow, OldColumn, NewRow, NewColumn) :-
    RowDiff is abs(NewRow - OldRow),
    ColumnDiff is abs(NewColumn - OldColumn),
    RowDiff =:= ColumnDiff.


move_piece(5, OldRow, OldColumn, NewRow, NewColumn) :-
    RowDiff is abs(NewRow - OldRow),
    ColumnDiff is abs(NewColumn - OldColumn),
    (RowDiff =:= ColumnDiff ; OldRow =:= NewRow ; OldColumn =:= NewColumn).

    

