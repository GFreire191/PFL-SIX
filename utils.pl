take(0, List, [], List).
take(N, [H|T], [H|Res], Rem) :-
    N > 0,
    N1 is N - 1,
    take(N1, T, Res, Rem).


%-------------------------------------------------- REPLACE A lIST LOCATED IN A ROW/COLUMN --------------------------------------------------
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):-
    I > -1,
    NI is I-1,
    replace(T, NI, X, R), !.
replace(L, _, _, L).



%-------------------------------------------------- CHECK IF THE ROW AND COLUMN ARE VALID --------------------------------------------------
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



