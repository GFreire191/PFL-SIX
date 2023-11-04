
initial_board(4, [
    [[b,b,b], [], [b], []],
    [[], [], [w,w,w], []],
    [[], [], [], [b]],
    [[], [], [b], []]
]).

initial_board(5, [
    [[b,b,b], [], [b], [], []],
    [[], [], [w,w,w], [], []],
    [[], [], [], [b], []],
    [[], [], [b], [], []],
    [[], [], [b], [], []]
]).



line(5,5, L) :- L = '           0           '.
line(4,5, L) :- L = '           1           '.
line(3,5, L) :- L = '           2           '.
line(2,5, L) :- L = '           3           '.
line(1,5, L) :- L = '           4           '.

line(4,4, L) :- L = '           0           '.
line(3,4, L) :- L = '           1           '.
line(2,4, L) :- L = '           2           '.
line(1,4, L) :- L = '           3           '.



print_header(0,_).

print_header(BoardSize,N) :-
    write('           '),
    write(N),
    write('           |'),
    BoardSize1 is BoardSize - 1,
    N1 is N + 1,
    print_header(BoardSize1,N1).


print_devider(-1).

print_devider(BoardSize) :-
    write('-----------------------|'),
    BoardSize1 is BoardSize - 1,
    print_devider(BoardSize1).

    

print_board(BoardSize,X):-
    nl,
    write('                       |'),
    print_header(BoardSize,0),
    write('\n'),
    print_devider(BoardSize),
    write('\n'),
    print_matrix(X, BoardSize, BoardSize).

print_matrix([], 0, _).
print_matrix([Head|Tail], N, BoardSize) :-
    line(N,BoardSize, L),
    write(L),
    N1 is N-1,
    write('|'),
    print_line(Head),
    write('\n'),
    print_devider(BoardSize),
    write('\n'),
    print_matrix(Tail, N1,BoardSize).

print_line([]).
print_line([Head|Tail]):-
    print_pieces(Head),
    length(Head, Length),
    Spaces is 23 - Length * 2,
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