%%Numero de canibales nunca puede ser > numero misioneros

main :- 
    EstadoInicial = [3,3,0,0,true], EstadoFinal = [0,0,3,3,false],
    between(1, 1000, CosteMax), % Buscamos soluci ́on de coste 0; si no, de 1, etc.
    camino( CosteMax, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
    reverse(Camino, Camino1), write(Camino1), write(' con coste '), write(CosteMax), nl, halt.

camino( 0, E,E, C,C ). % Caso base: cuando el estado actual es el estado final.

camino( CosteMax, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ) :-
    CosteMax > 0,
    unPaso( CostePaso, EstadoActual, EstadoSiguiente ),
    \+ member( EstadoSiguiente, CaminoHastaAhora ),
    CosteMax1 is CosteMax-CostePaso,
    camino(CosteMax1, EstadoSiguiente, EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal).


% go possibilities
unPaso( 1, [CI,MI,CD,MD,true], [NextCI,NextMI,NextCD,NextMD,false] ):-
    NextCI is CI - 1, 
    NextCD is CD + 1,
    NextMI is MI - 1, 
    NextMD is MD + 1,
    behaves(NextCI,NextMI,NextCD,NextMD).

unPaso( 1, [CI,MI,CD,MD,true], [NextCI,MI,NextCD,MD,false] ):-
    member(N,[1,2]),
    NextCI is CI - N, 
    NextCD is CD + N,
    behaves(NextCI,MI,NextCD,MD).

unPaso( 1, [CI,MI,CD,MD,true], [CI,NextMI,CD,NextMD,false] ):-
    member(N,[1,2]),
    NextMI is MI - N, 
    NextMD is MD + N,
    behaves(CI,NextMI,CD,NextMD).


% comeback possibilities
unPaso( 1, [CI,MI,CD,MD,false], [NextCI,NextMI,NextCD,NextMD,true] ):-
    NextCI is CI + 1, 
    NextCD is CD - 1,
    NextMI is MI + 1, 
    NextMD is MD - 1,
    behaves(NextCI,NextMI,NextCD,NextMD).

unPaso( 1, [CI,MI,CD,MD,false], [NextCI,MI,NextCD,MD,true] ):-
    member(N,[1,2]),
    NextCI is CI + N, 
    NextCD is CD - N,
    behaves(NextCI,MI,NextCD,MD).

unPaso( 1, [CI,MI,CD,MD,false], [CI,NextMI,CD,NextMD,true] ):-
    member(N,[1,2]),
    NextMI is MI + N, 
    NextMD is MD - N,
    behaves(CI,NextMI,CD,NextMD).

behaves(CI,MI,CD,MD):- 
    MI >= 0, MI=<3, CI >= 0, CI=<3,
    MD >= 0, MD=<3, CD >= 0, CD=<3,
    moreM(MI,CI),moreM(MD,CD).

moreM(0,_).
moreM(M,C):- M>=C.
