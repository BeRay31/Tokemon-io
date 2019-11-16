include(map.pl).
include(database.pl).
:- dynamic(inventory/1).			/* inventory(NamaTokemon) */
:- dynamic(main/1).					/* gameMain(Main) */
:- dynamic(maxInventory/1).			/* maxInventory(Maks) */


init_player :-
	asserta(main(100)),
	asserta(inventory(bebasmon)),
	asserta(maxInventory(6)).

quit :-
	\+main(_),
	write('BELUM MULAI NJIR'),nl,
	write('ketik \'start. dan enter biar mulai'),nl.

quit :- 
	retract(player(_,_)),
	retract(main(_)).
	


drop(X):-
	retract(inventory(X)).

status :-
	write('Your tokemon :'),nl,
	inventory(_)->(
		forall(inventory(N),
		(
			tokemon(N,T,Hp,_,_),
			write('		-'),write(N),nl,
			write('		Health	: '),write(Hp),nl,
			write('		Type 	: '),write(T),nl,nl,nl
		)
		)),!.
