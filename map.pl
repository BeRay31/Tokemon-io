:- dynamic(lebarPeta/1).
:- dynamic(tinggiPeta/1).
:- dynamic(gym/2).
:- dynamic(obstacle/2).
:- dynamic(player/2).
%--------------------------INIT MAP-----------------------------------------------
init_map :-
	asserta(player(1,1)),
    random(10,16,X),
    random(10,16,Y),
    asserta(lebarPeta(X)),
	asserta(tinggiPeta(Y)),
	asserta(gym(5,5)),
	forall(between(1,10,R),(
		random(1,X,C),
		random(1,Y,D),
		asserta(obstacle(C,D))
	)).
%------------------------------CEK BORDER------------------------------------------
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
%------------------------------PRINTMAP----------------------------------------------
printMap(X,Y) :-
    isBorderKanan(X,Y), !, write('X').
printMap(X,Y) :-
	isBorderKiri(X,Y),!,write('X').
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

printM :-
	tinggiPeta(T),
	lebarPeta(L),
	XMin is 0,
	XMax is L+1,
	YMin is 0,
	YMax is T+1,
	forall(between(YMin,YMax,J), (
		forall(between(XMin,XMax,I), (
			printMap(I,J)
		)),
		nl
	)),
	write('Keterangan Simbol :'), nl,
	write('P    :    Player'), nl,
	write('G    :    Gym'), nl,
	write('X    :    Border'), nl,
	write('x    :    Obstacle'),nl,
	write('-    :    Empty Field'), nl,
	!.

