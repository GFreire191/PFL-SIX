# Programação Funcional e Lógica 2023/2024
## Trabalho Prático 1
O jogo realizado pelo nosso grupo no 1º trabalho prático no âmbito da unidade curricula Programação Funcional e Lógica foi o "Six Making".

- Grupo: Six Making_2
- Participantes: 
  - up202004809 - Guilherme Miguel de Lima Faria (contribuição: 50%)
  - up202005700 - Simão Queirós Rodrigues        (contribuição: 50%)
  
## Instalação e Execução

Para instalar o jogo Six Making primeiro é necessário fazer o download dos ficheiros presentes em PFL_TP1_T13_SixMaking_2.zip e descompactá-los. 
Dentro do diretório src consulte o ficheiro main.pl através da linha de comandos ou pela própria UI do Sicstus Prolog 4.8.0.

O jogo está disponível em ambientes Windows e Linux e inicia com o predicado:

```
play/0
```

## Descrição do Jogo
### ♟️ Tabuleiro
O tabuleiro do jogo pode ter formato de uma matriz 4x4 ou 5x5.
### 🎯 Gameplay
Os jogadores podem jogar com as peças pretas ou com as brancas.
Existem três tipos de jogadas possíveis:
- Colocar um disco novo numa posição vazia;
- Mover uma stack inteira para uma nova posição que já contenha alguma peça;
- Mover parte de uma stack para uma nova posição que já contenha alguma peça.

As stacks têm diferentes movimentos consoante a sua altura:
1. Peão - um espaço horizontal ou vetical;
2. Torre - qualuqer número de espaços verticais ou horizontais;
3. Cavalo - formato "L", um espaço ortogonal ou diagonal;
4. Bispo - qualquer número de espaços na diagonal;
5. Rainha - qualquer número de espaços em qualquer direção;
6. Rei - ganha, não tem movimentos.
  
🏆 Quando uma stack de seis ou mais é formada, o vencedor é quem possui a sua cor no topo da stack.

## Lógica do Jogo
### Representação Interna do Estado do Jogo
Estado atual do tabuleiro:
- Este é representado por uma **lista de listas de listas**, pois as casas do tabuleiro podem conter vários discos a formar a stack.
- Cada jogador é definido pelo uso dos caracteres `w` e `b`, sendo `w` o primeiro a jogar.

### Estado Inicial (4x4)
```
[
    [[], [], [], []],
    [[], [], [], []],
    [[], [], [], []],
    [[], [], [], []]
] 
```

### Estado Intermédio (4x4)
```
[
    [[], [w,b], [], []],
    [[], [], [], [w]],
    [[], [b], [], []],
    [[], [], [w,b,w], []]
]  
```

### Estado Final (4x4)
```
[
    [[w], [], [], []],
    [[], [w,w,b,b,w,w], [], []],
    [[], [b], [w,b], []],
    [[], [], [w,b,w], []]
] 
```

### Visualização do Estado do Jogo

Após o ínicio do jogo, ao correr o predicado `play.` é pedido ao usuário o tamanho do tabuleiro, sendo apenas os valores `4` e `5` permitidos.


As opções `1`, `2` e `3` correspoondem aos modos de jogo disponíveis:
```
1 - Human vs Human
2 - Human vs Computer
3 - Computer vs Computer
```
Após a seleção de qualquer uma dessas três opções é apresentado um ecrã para escolher o tipo de jogo.

Para a opção `1 - Human vs Human`:
Após a seleção do tamanho do tabuleiro, dá-se início ao jogo. O primeiro a jogar é o **Player 1**, definido por **w**, seguido do **Player 2**, definido por **b**, repetidamente, até ao fim do jogo.

Já para a opção `2 - Player vs Computer`:
Após a escolha do tamanho do tabuleiro, dá-se início ao jogo.
Novamente, o **Player 1** é quem joga a primeira jogada (sendo o `Player 1` o humano, e o **Player 2** o computador), seguido do **Player 2**, mantendo-se este ciclo até ao término da partida.

Na opção `3 - Computer vs Computer`:
Após a escolha do tamanho do tabuleiro, dá-se início ao jogo.
Ao iniciar um jogo, é apresentado um tabuleiro, com a medida escolhida, apresentando cada jogada feita pelos dois computadores, até que o vencedor seja declarado.

A visualização do estado do jogo foi implementada fazendo uso do predicado `display_game(+BoardSize, +GameState)`, que dá _display_ ao estado atual do tabuleiro, recorrendo também ao predicado `print_matrix`, que recebe o estado atual do tabuleiro e desenha todo o tabuleiro.

```prolog
display_game(BoardSize,X):-
    nl,
    write('                       |'),
    print_header(BoardSize,0),
    write('\n'),
    print_devider(BoardSize),
    write('\n'),
    print_matrix(X, BoardSize, BoardSize).
```

Também é feito uso do predicado `initial_state`, que ao receber o tamanho do tabuleiro devolve o estado inicial do jogo.

```prolog
initial_state(4, [
    [[], [], [], []],
    [[], [], [], []],
    [[], [], [], []],
    [[], [], [], []]
]).

initial_state(5, [
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []]
]).
```

### Processo de Execução de uma Jogada
O processo de execução de uma jogada é feita através do predicado `move`, que é responsável pelo movimento das peças e do predicado `valid_moves` que verifica se a nova posição é válida.

move/6, responsável pelo movimento de uma stack interia:

```prolog
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
```

move/7, responsável pelo movimento da parte de uma stack:

```prolog
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
```

Existe ainda um predicado `place_disk` responsável pela funcionalidade de colocar novos discos no tabuleiro.

```prolog
place_disk(GameState, Row, Column, Player, NewGameState) :-
    nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    append([Player], ColumnList, NewColumnList),
    replace(RowList, Column, NewColumnList, NewRowList),
    replace(GameState, Row, NewRowList, NewGameState), !.
```

### Lista das Jogadas Válidas
A verificação de uma jogada é feita pelo predicado `valid_moves` que verifica se a nova posição é válida consoante o comprimento da torra a ser movida.

```prolog
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
```

### Game Over
A estratégia utilizada para verificar se o jogo chegou ao fim está implementada através do predicado `game_over` que verifica a existência de uma torre composta por 6 ou mais peças.

```prolog
game_over(GameState, Player) :-
    member(Row, GameState),
    member(Tower, Row),
    length(Tower, Length),
    Length >= 6,
    nth0(0, Tower, TopDisk),
    (TopDisk == Player ->
        nl, nl, write('Player '), write(Player), write(' wins!'), nl, nl;
        next_player(Player, OtherPlayer),
        TopDisk == OtherPlayer ->
            write('Player '), write(OtherPlayer), write(' wins!'), nl),
    !.
```

### Jogadas do Computador
Jogada do computador:
  - O computador gera um número aleatório entre um e três para escolher que tipo de jogada efetuar. De seguida, gera mais números aleatórios compreendidos ente zero e o tamanho do tabuleiro para escolher a coluna e a linha.
   Após a escolha, verifica se o movimento é válido consoante as regras. Caso falhe volta a tentar uma combinação possível, assim sucessivamente.

```prolog
computer_move(1, GameState, Player,BoardSize, NewGameState) :-
    count_pieces(GameState, Player, Count),
    random_between(0, BoardSize, Row),
    random_between(0, BoardSize, Column),
    (nth0(Row, GameState, RowList),
    nth0(Column, RowList, ColumnList),
    length(ColumnList, Length),
    Count < (BoardSize - 1) * 4,
    Length == 0 ->
    place_disk(GameState, Row, Column, Player, NewGameState),
    write('Computer placed a disk in row '), write(Row), write(' and column '), write(Column), write('.'), nl;
    random_between(1,3,Option),
    computer_move(Option, GameState,Player,BoardSize, NewGameState)).

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
    write('Computer moved a tower from row '), write(Row), write(' and column '), write(Column), write(' to row '), write(NewRow), write(' and column '), write(NewColumn), write('.'), nl;
    random_between(1,3,Option),
    computer_move(Option, GameState,Player,BoardSize, NewGameState)).

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
    write('Computer moved '), write(Amount), write(' pieces of a tower from row '), write(Row), write(' and column '), write(Column), write(' to row '), write(NewRow), write(' and column '), write(NewColumn), write('.'), nl;
    random_between(1,3,Option),
    computer_move(Option, GameState,Player,BoardSize, NewGameState)).
```

## Conclusão
Consideramos que o jogo foi implementado com sucesso, com exceção de um segundo nível de inteligência artificial.

### Dificuldades
- Manipulação das stacks.

### Melhorias
- Implementação do nível 2 de inteligência artificial.

## Fontes
- https://www.boardspace.net/english/about_sixmaking.html
