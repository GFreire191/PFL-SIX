% Splits a list into two parts: the first N elements and the remaining elements.
take(0, List, [], List).
take(N, [H|T], [H|Res], Rem) :-
    N > 0,
    N1 is N - 1,
    take(N1, T, Res, Rem).


% Replace a list located in a row/column
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):-
    I > -1,
    NI is I-1,
    replace(T, NI, X, R), !.
replace(L, _, _, L).


% Check if the row and column are valid
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


% Join everything in a single list
my_flatten(X,[X]) :- \+ is_list(X).
my_flatten([],[]).
my_flatten([X|Xs],Zs) :- my_flatten(X,Y), my_flatten(Xs,Ys), append(Y,Ys,Zs).


% Counts the number of occurrences of an element in a list
count(_, [], 0).
count(X, [X|T], N) :-
    count(X, T, N2),
    N is N2 + 1.
count(X, [Y|T], N) :-
    X \= Y,
    count(X, T, N).