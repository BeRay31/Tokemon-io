:- include('database.pl').

:- dynamic(lebarPeta/1).
:- dynamic(tinggiPeta/1).
:- dynamic(gym/2).
:- dynamic(obstacle/2).
:- dynamic(player/2).

%--------------------------INIT MAP-----------------------------------------------

/*Menginisialisasi map, dengan cara generate dan men-set gym, player, obstacle.*/
init_map :-
    random(10,16,X),
    random(10,16,Y),	
    asserta(lebarPeta(X)),
	asserta(tinggiPeta(Y)),
	asserta(gym(5,5)),
	forall(between(1,10,_),(
		random(1,X,C),
		random(1,Y,D),
		\+ gym(C, D),
		\+ player(C, D),
		asserta(obstacle(C,D))
	)), 
	!.

%------------------------------CEK BORDER------------------------------------------

/*Memberikan garis batas pada map*/
isBorderAtas(X,Y) :-
    Y=:=0,
	asserta(obstacle(X,Y)),
    !.
isBorderKiri(X,Y) :-
    X=:=0,
	asserta(obstacle(X,Y)),
    !.
isBorderBawah(X,Y) :-
    tinggiPeta(T),
    YMax is T+1,
    Y=:=YMax,
	asserta(obstacle(X,Y)),
    !.
isBorderKanan(X,Y) :-
    lebarPeta(L),
    XMax is L+1,
    X=:=XMax,
	asserta(obstacle(X,Y)),
    !.
%------------------------------PRINTMAP----------------------------------------------

/*Mengecek border dan obstacle. 
Jika ada, print X.
Jika tidak, masuk ke printMap selanjutnya*/
printMap(X,Y) :-
	(
		isBorderAtas(X,Y);
		isBorderBawah(X,Y);
		isBorderKanan(X,Y);
		isBorderKiri(X,Y);
		obstacle(X,Y)
	),
	!,write('X').

/*Mengecek lokasi player. 
Jika ada, print P.
Jika tidak, masuk ke printMap selanjutnya*/
printMap(X,Y) :-
	player(X,Y), !, write('P').

/*Mengecek lokasi gym. 
Jika ada, print G.
Jika tidak, masuk ke printMap selanjutnya*/
printMap(X,Y) :-
	gym(X,Y),!, write('G').

/*Jika kondisi printMap sebelumnya tidak memenuhi, Map menjadi lahan kosong*/
printMap(_,_) :-
	write('_').