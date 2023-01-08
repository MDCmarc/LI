%INPUT = (N,FilaI,ColumnaI,Pasos = 0)
%Final= (N,FilfaF,ColumnaF,Pasos = P)

main :- EstadoInicial = [1,1,5], EstadoFinal = [1,2,5],
between(5, 5, CosteMax), % Buscamos solución de coste 0; si no, de 1, etc.
camino( CosteMax, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
reverse(Camino, Camino1), write(Camino1), write(" con coste "), write(CosteMax), nl, halt.

camino( 0, E,E, C,C ). % Caso base: cuando el estado actual es el estado final.

camino( CosteMax, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ) :-
CosteMax > 0,
unPaso( CostePaso, EstadoActual, EstadoSiguiente ), % En B.1 y B.2, CostePaso es 1.
\+ member( EstadoSiguiente, CaminoHastaAhora ),
CosteMax1 is CosteMax-CostePaso,
camino(CosteMax1, EstadoSiguiente, EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal).


unPaso(1, [Fila,Columna,N], [FilaNueva,ColumnaNueva,N]) :- 
    FilaNueva is Fila+1, ColumnaNueva is Columna+2, FilaNueva > 0, FilaNueva =< N,ColumnaNueva > 0, ColumnaNueva =< N.
unPaso(1, [Fila,Columna,N], [FilaNueva,ColumnaNueva,N]) :- 
    FilaNueva is Fila+1, ColumnaNueva is Columna-2, FilaNueva > 0, FilaNueva =< N,ColumnaNueva > 0, ColumnaNueva =< N.
unPaso(1, [Fila,Columna,N], [FilaNueva,ColumnaNueva,N]) :- 
   FilaNueva is Fila-1, ColumnaNueva is Columna+2, FilaNueva > 0, FilaNueva =< N,ColumnaNueva > 0, ColumnaNueva =< N.
unPaso(1, [Fila,Columna,N], [FilaNueva,ColumnaNueva,N]) :- 
    FilaNueva is Fila-1, ColumnaNueva is Columna-2, FilaNueva > 0, FilaNueva =< N,ColumnaNueva > 0, ColumnaNueva =< N.
unPaso(1, [Fila,Columna,N], [FilaNueva,ColumnaNueva,N]) :- 
    FilaNueva is Fila+2, ColumnaNueva is Columna+1, FilaNueva > 0, FilaNueva =< N,ColumnaNueva > 0, ColumnaNueva =< N.
unPaso(1, [Fila,Columna,N], [FilaNueva,ColumnaNueva,N]) :- 
    FilaNueva is Fila+2, ColumnaNueva is Columna-1, FilaNueva > 0, FilaNueva =< N,ColumnaNueva > 0, ColumnaNueva =< N.
unPaso(1, [Fila,Columna,N], [FilaNueva,ColumnaNueva,N]) :- 
    FilaNueva is Fila-2, ColumnaNueva is Columna+1, FilaNueva > 0, FilaNueva =< N,ColumnaNueva > 0, ColumnaNueva =< N. 
unPaso(1, [Fila,Columna,N], [FilaNueva,ColumnaNueva,N]) :- 
    FilaNueva is Fila-2, ColumnaNueva is Columna-1, FilaNueva > 0, FilaNueva =< N,ColumnaNueva > 0, ColumnaNueva =< N. 