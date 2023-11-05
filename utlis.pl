take(0, List, [], List).
take(N, [H|T], [H|Res], Rem) :-
    N > 0,
    N1 is N - 1,
    take(N1, T, Res, Rem).

replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):-
    I > -1,
    NI is I-1,
    replace(T, NI, X, R), !.
replace(L, _, _, L).