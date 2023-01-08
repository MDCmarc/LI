%% Write a Prolog predicate eqSplit(L,S1,S2) that, given a list of
%% integers L, splits it into two disjoint subsets S1 and S2 such that
%% the sum of the numbers in S1 is equal to the sum of S2. It should
%% behave as follows:
%%
%% ?- eqSplit([1,5,2,3,4,7],S1,S2), write(S1), write('    '), write(S2), nl, fail.
%%
%% [1,5,2,3]    [4,7]
%% [1,3,7]    [5,2,4]
%% [5,2,4]    [1,3,7]
%% [4,7]    [1,5,2,3]


eqSplit(L,S1,S2):-  getall(L,S1,S2),
                    sum_list(S1, T1),sum_list(S2,T2),T1==T2,
                    write(S1), write('    '), write(S2), nl, fail.

getall([],[],[]).
getall([L|Ls],[L|S1],S2):- getall(Ls,S1,S2).
getall([L|Ls],S1,[L|S2]):- getall(Ls,S1,S2).

getList([],[]).
getList([_|L],S):- getList(L,S).
getList([X|L],[X|S]):- getList(L,S).
  
disjoint([],[]).  
disjoint([],_).
disjoint([L|Ls],S2):- not(member(L,S2)), disjoint(Ls,S2).
 


