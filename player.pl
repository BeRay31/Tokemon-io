:- dynamic(player/2). 				/* player(XPos,YPos) */
:- dynamic(inventory/1).			/* inventory(NamaTokemon) */
:- dynamic(main/1).					/* gameMain(Main) */
:- dynamic(maxInventory/1).			/* maxInventory(Maks) */


init_player :-
	asserta(player(1,1)),
	asserta(inventory(bebasmon)),
	asserta(maxInventory(6)),

drop(X):-
	retract(inventory(X)),

status :-
	write('Your tokemon :'),nl,
	inventory(_)->(
		forall(inventory(N),
		(
			tokemon(N,T,Hp,Na,Sa),
			write('		-'),write(N),nl,
			write('		Health	: '),write(Hp),nl,
			write('		Type 	: '),write(T),nl,nl,nl
		)
		),!.
