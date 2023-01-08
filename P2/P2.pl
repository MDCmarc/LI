%prod(L,P)
prod([],1).
prod([L|Ls],P):- prod(Ls,P1) , P is P1*L.

%pescalar(L1,L2,P)
pescalar([],[],0).
pescalar([L|Ls],[T|Ts],P):- pescalar(Ls,Ts,P1), P is P1+L*T.

%inteseccion(L1,L2,P)
inteseccion(_,[],[]).
inteseccion([],_,[]).
inteseccion([L|Ls] ,Ts,[L|P]) :- member(L,Ts), inteseccion(Ls,Ts,P).
interseccion([_|Ls],Ts,P) :- interseccion(Ls,Ts,P).

%union(L1,L2,P)
union([], L2, L2).
union([L|Ls],L2,[L|P]) :- not(member(L,L2)),union(Ls,L2,P). 
union([_|Ls],L2,P):- union(Ls,L2,P).

%last_(L1,P)
last_(L,[P,P1]):- append(_,[P,P1],L). 

%fib(N,F)
fib(1,1):- !.
fib(2,1):- !.
fib(N,F):-  N1 is N-1, N2 is N-2, 
            fib(N1,F1), fib(N2,F2), 
            F is F1 + F2.

%dados(P,N,L)
dados(0,0,[]).
dados(P,N,[X|Ls]) :- N>0,member(X,[1,2,3,4,5,6]),
                     N1 is N-1, P1 is P-X ,dados(P1,N1,Ls).

%suma_demas(L)
suma_demas(L):- append(L1,[X|L2],L),append(L1,L2,Rest),sum(Rest,X).

%suma_ants(L)
suma_ants(L):- append(L1,[X|_],L),sum(L1,X).

%sum(Rest,L)
sum([],0).
sum([L|Ls],P):- sum(Ls,P1), P is P1+L.

%card(L)

card(L):- getcards(L,[]).

getcards([],R):-write(R),!.
getcards([L|Ls],R):- count(L,[L|Ls],T), (not(member([L,_],R)), append(R,[[L,T]],Rnew), getcards(Ls,Rnew),!);getcards(Ls,R),!.

count(_,[],0).
count(X,[X|Ls],R):- count(X,Ls,R1), R is R1 +1, !.
count(X, [_|Ls],R):- count(X,Ls,R).

%esta_ordenada(L)
esta_ordenada([]).
esta_ordenada([_]).
esta_ordenada([L1,L2|Ls]):- L1 < L2, esta_ordenada([L2|Ls]).






%ord(L1,L2)
orde(L1,L2):- permutation(L1,L2), esta_ordenada(L2).

%diccionario(A,N)
diccionario(A,N):- palabras(A,N,R), printPal(R), write(' '), fail.

palabras(_,0,[]):- !.
palabras(A,N,[R|Rs]):- member(R,A), N1 is N-1, palabras(A,N1,Rs).

printPal([]).
printPal([R|Rs]):- write(R),printPal(Rs).


%palindromos(L)
palindromos(L):- setof(L2, (permutation(L,L2),es_pal(L2)), Res), write(Res).

es_pal([]).
es_pal([L|List]):- last(List, Last), L = Last,
        removeLast(List, NewList), es_pal(NewList).

removeLast(L, NewL):- append(NewL, [_], L).

%sendmory
sendMoreMoney:-  
    Letters = [S, E, N, D, M, O, R, Y, _, _],
    Numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    permutation(Letters, Numbers),

    S1 is 1000 * S + 100 * E + 10 * N + D +
          1000 * M + 100 * O + 10 * R + E,

    S1 is 10000 * M + 1000 * O + 100 * N + 10 * E + Y,

    writeLetters(Letters), ! .

writeLetters([S, E, N, D, M, O, R, Y, _, _]):-
    write('S = '), write(S), nl,
    write('E = '), write(E), nl,
    write('N = '), write(N), nl,
    write('D = '), write(D), nl,
    write('M = '), write(M), nl,
    write('O = '), write(O), nl,                                                 
    write('R = '), write(R), nl,
    write('Y = '), write(Y), nl,
    writeSuma([S, E, N, D, M, O, R, Y]).


writeSuma([S, E, N, D, M, O, R, Y]):-
    S1 is 1000 * S + 100 * E + 10 * N + D,
    S2 is 1000 * M + 100 * O + 10 * R + E,
    S3 is S1 + S2,
    S4 is  10000 * M + 1000 * O + 100 * N + 10 * E + Y,
    write('SEND = '), write(S1), 
    write(' + '), 
    write('MORE = '), write(S2), write('-->'), write(S3), nl,
    write('MONEY = '), write(S4).

%15 simplifica 



calculate(K * X + K * Y, K * R):- number(X),number(Y),!,R is X+Y.
calculate(X * K + Y * K, K * R):- number(X),number(Y),!,R is X+Y.
calculate(K * X + Y * K, K * R):- number(X),number(Y),!,R is X+Y.
calculate(X * K + K * Y, K * R):- number(X),number(Y),!,R is X+Y.

calculate(1 * X, X):- !.
calculate(X * 1, X):- !.
calculate(_ * 0, 0):- !.
calculate(0 * _, 0):- !.

calculate(X * Y, R):-number(X),number(Y),!,R is X*Y.

calculate(0 + X, X):-!.
calculate(X + 0, X):-!.
calculate(X + Y, R):-number(X),number(Y),!,R is X+Y.

calculate(X,X):- !.


simplifica(X + Y, R):-simplifica(X,Op1),simplifica(Y,Op2),calculate(Op1 + Op2,R).
simplifica(X * Y, R):-simplifica(X,Op1),simplifica(Y,Op2),calculate(Op1 * Op2,R).
simplifica(Op, Op):- !.

%16 dom(L)
p([],[]).
p(L,[X|P]) :- select(X,L,R), p(R,P).

dom(L) :- p(L,P), ok(P), write(P), nl.
dom( ) :- write("no hay cadena"), nl.

ok([_,_|[]]):- !.
ok([_,P1,P2|Ps]):- P1 == P2,ok([P2|Ps]).

%17



%18

smokers():- 10 = X1+Y1, 10 = X2+Y2, X1/10>Y1/10,  X2/10 > Y2/10 , (Y1+Y2)/20 > (X1+X2)/20 .

%19
monedas([],[],0).
monedas([L|Ls],[M|Ms],N):- between(0, N, M), N2 is (N-M*L),N2 >= 0, monedas(Ls,Ms,N2),!.

%flatten(L,F)
flatten([],[]):- !.
flatten(L,[L]):- L \= [_|_].
flatten([L|Ls],F):- flatten(L, List1), flatten(Ls, List2), append(List1, List2, F).


% log(B,N,L)
log(_,1,0):- !.
log(B,N,L):- N>0, N1 is N/B , log(B,N1,L1), L is L1+1.


%li solo funciona con numeros pequeños sino tarda mucho
li(N,M,L,S):- sselect(N,M,L,S), no_reps(S),try(L,S),! ,nl.
li():- write("error"),nl.

sselect(_,0,_,[]):- !.
sselect(N,M,L,[S|SS]):-between(1,N,S),M1 is M-1, sselect(N,M1,L,SS).

no_reps([]):- !.
no_reps([S|SS]):- not(member(S,SS)), no_reps(SS),!.

try([],_):- !.
try([[A,B]|L],S):- not(and(member(A,S),member(B,S))),try(L,S),!.

and(A,B):-A,B.