
initial_board([
    [[b,b,b], [], [], [], []],
    [[], [], [w,w,w], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []]
]).



line(1, L) :- L = '          0          '.
line(2, L) :- L = '          1          '.
line(3, L) :- L = '          2          '.
line(4, L) :- L = '          3          '.
line(5, L) :- L = '          4          '.



print_board(X):-
    nl,
    write('                   |          0          |          1          |          2          |          3          |          4          |\n'),
    write('-------------------|---------------------|---------------------|---------------------|---------------------|---------------------|\n'),
    print_matrix(X, 1).

print_matrix([], 6).
print_matrix([Head|Tail], N) :-
    line(N, L),
    write(L),
    N1 is N+1,
    write('|'),
    print_line(Head),
    write('\n-------------------|---------------------|---------------------|---------------------|---------------------|---------------------|\n'),
    print_matrix(Tail, N1).

print_line([]).
print_line([Head|Tail]):-
    print_pieces(Head),
    length(Head, Length),
    Spaces is 21 - Length * 2,
    print_spaces(Spaces),
    write('|'),
    print_line(Tail).

% ---------------------------------------
print_spaces(0).
print_spaces(N) :-
    write(' '),
    N1 is N-1,
    print_spaces(N1).


print_pieces([]).
print_pieces([Head|Tail]) :-
    write(Head),
    write(','),
    print_pieces(Tail).