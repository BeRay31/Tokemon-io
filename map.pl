:- dynamic(lebarPeta/1).
:- dynamic(tinggiPeta/1).
:- dynamic(gym/2).
:- dynamic(obstacle/2).



init_map :-
    random(10,16,X),
    random(10,16,Y),
    asserta(lebarPeta(X)),asserta(tinggiPeta(Y)),
    random(1,15,A),A\==1,
    random(1,15,B),B\==1,
	asserta(gym(A,B)),
	forall(upto(1,10,1,R),(
		random(1,15,X),X\==A,X\==1,
		random(1,15,Y),Y\==B,Y\==1,
		asserta(obstacle(X,Y))
	)

isBorderAtas(_,Y) :-
    Y=:=0
    ,!.
isBorderKiri(X,_) :-
    X=:=0,
    !.
isBorderBawah(_,Y) :-
    tinggiPeta(T),
    YMax is T+1,
    Y=:=YMax,
    !.
isBorderKanan(X,_) :-
    lebarPeta(L),
    XMax is L+1,
    X=:=XMax,
    !.

printMap(X,Y) :-
    isBorderKanan(X,Y), !, write('X').
printPrio(X,Y) :-
    isBorderKiri(X,Y), !, write('X').
printMap(X,Y) :-
    isBorderAtas(X,Y), !, write('X').
printMap(X,Y) :-
    isBorderBawah(X,Y), !, write('X').
printMap(X,Y) :-
	player(X,Y), !, write('P').
printMap(X,Y) :-
	gym(X,Y),!,write('G').
printMap(X,Y) :-
	obstacle(X,Y),!,write('x').
printMap(_,_) :-
	write('_').
