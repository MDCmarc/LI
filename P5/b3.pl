main :- EstadoInicial = [[1,0],[2,0],[5,0],[8,0],0], EstadoFinal = [[1,1],[2,1],[5,1],[8,1],1],
between(1, 1000, CosteMax), % Buscamos soluci ́on de coste 0; si no, de 1, etc.
camino( CosteMax, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
reverse(Camino, Camino1), write(Camino1), write(" con coste "), write(CosteMax), nl, halt.

camino( 0, E,E, C,C ). % Caso base: cuando el estado actual es el estado final.

camino( CosteMax, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ) :-
CosteMax > 0,
unPaso( CostePaso, EstadoActual, EstadoSiguiente ), % En B.1 y B.2, CostePaso es 1.
\+ member( EstadoSiguiente, CaminoHastaAhora ),
CosteMax1 is CosteMax-CostePaso,
camino(CosteMax1, EstadoSiguiente, EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal).

unPaso(8, [[1,A],[2,B],[5,0],[8,0],0],[[1,A],[2,B],[5,1],[8,1],1]).
unPaso(8, [[1,A],[2,0],[5,B],[8,0],0],[[1,A],[2,1],[5,B],[8,1],1]).
unPaso(8, [[1,0],[2,A],[5,B],[8,0],0],[[1,1],[2,A],[5,B],[8,1],1]).
unPaso(5, [[1,A],[2,0],[5,0],[8,B],0],[[1,A],[2,1],[5,1],[8,B],1]).
unPaso(5, [[1,0],[2,A],[5,0],[8,B],0],[[1,1],[2,A],[5,1],[8,B],1]).
unPaso(2, [[1,0],[2,0],[5,A],[8,B],0],[[1,1],[2,1],[5,A],[8,B],1]).

unPaso(8, [[1,A],[2,B],[5,C],[8,1],1],[[1,A],[2,B],[5,C],[8,0],0]).
unPaso(5, [[1,A],[2,B],[5,1],[8,C],1],[[1,A],[2,B],[5,0],[8,C],0]).
unPaso(2, [[1,A],[2,1],[5,B],[8,C],1],[[1,A],[2,0],[5,B],[8,C],0]).
unPaso(1, [[1,1],[2,A],[5,B],[8,C],1],[[1,0],[2,A],[5,B],[8,C],0]).


