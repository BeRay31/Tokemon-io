:- include('map.pl').
:- include('database.pl').	
:- include('attack.pl').

/*Fakta yang dapat ditambah dan dikurangkan*/
:- dynamic(inventory/2).			/* inventory(NamaTokemon, HP) */
:- dynamic(main/1).					/* gameMain(Main) */
:- dynamic(maxInventory/1).			/* maxInventory(Maks) */
:- dynamic(battleTokemon/1). 		%nyimpen tokemon yang bakal digunain saat battle
:- dynamic(healAvl/1).				%udah ngeheal ato belom

/*Inisialisasi player, dengan cara men-set player, main, inventory, battleTokemon, maxInventory, healAvl.*/
init_player :-
	asserta(player(1,1)),
	asserta(main(100)),
	asserta(inventory(bebasmon, 435)),
	asserta(battleTokemon(bebasmon)),
	asserta(maxInventory(10)),
	asserta(healAvl(1)),
	!.

/*Menampilkan notifikasi belum mulai, jika player memilih untuk quit, padahal permainan belum dimulai.*/
quit :-
	\+main(_),
	write('BELUM MULAI NJIR'),nl,
	write('ketik \'start.\' dan enter biar mulai'),nl, !.

/*Mengeluarkan player dari permainan*/
quit :- 
	retract(player(_,_)),
	retract(battleTokemon(_)),
	retract(inventory(_,_)),
	retract(main(_)).

/*Menuliskan status tokemon dengan rincian nama, health, dan type.*/	
status :-
	write('Your tokemon :'),nl,
	inventory(_,_)->(
		forall(inventory(Name,Hp),
		(
			tokemon(_,Name,Type,_,_,_),
			write(Name),nl,
			write('Health	: '),write(Hp),nl,
			write('Type 	: '),write(Type),nl
		)
		)),!.

%---------------------------------------HEAL-------------------------
/*Jika sedang battle, command dinonaktifkan. Jika tidak sedang battle masuk ke rules heal selanjutnya*/
heal :-
	inBattle,
	write('Sedang battle command dinonaktifkan...'),nl,!.
/*Mengecek heal avaliable.
Jika heal tidak avaliable, tidak bisa heal.
Jika heal availiable, lanjut ke rules heal selanjutnya. */
heal :-
	\+healAvl(_),
	write('Cuma bisa sekali ngeheal yak!!'),!.
/*Mengecek player di gym atau tidak. Jika player tidak berada di gym, player tidak bisa heal. Jika berada di gym, lanju*/
heal :-
	\+(player(5,5)),
	write('Gabole bray lu di padang rumput sekarang'),nl,!.
/**/
heal :-
	player(5,5),
	forall(inventory(N,_),
	(
		tokemon(_,N,_,HP,_,_),
		retract(inventory(N,_)),
		asserta(inventory(N,HP))
	)),!,
	retract(healAvl(_)),
	write('Tokemon Sehat dan Kuat...'),nl.


drop(Name):-
	inBattle,
	write('Sedang battle command dinonaktifkan'),nl,!.
drop(Name) :-
	countInventory(X),
	X =:= 1,
	write('Tokemon tinggal 1 gabisa dibuang dongg...'),nl,
	!.

drop(Name) :-
	\+ inventory(Name,_),
	format('~w gak ada di inventory ~n', [Name]),!.

drop(Name):-
	retract(inventory(Name,_)),
	format('~w telah dibuang dari inventory :( ~n',[Name]).

pick(Name):-
	\+ inventory(Name,_),
	format('lo gapunya ~w di inventory ~n',[Name]),!.
pick(Name) :-
	inventory(Name,CurrentHP),
	asserta(battleTokemon(Name,CurrentHP)),
	format('~w dipilih sebagai battle tokemon ~n').

countInventory(Length) :-
    findall(N, inventory(N,_), ListInventory),
    length(ListInventory, Length), !.

addTokemon(_) :-
    countInventory(Length),
	maxInventory(Max),
    Length >= Max, !, fail.
addTokemon(Nama) :-
    countInventory(Length),
	maxInventory(Max),
	Length < Max,
	tokemon(_,Nama,_,HP,_,_),
	asserta(inventory(Nama,HP)), !.	
countUniqueLegend(Length) :-
	findall(legend(Name),inventory(Name,_),List),
	length(List,Length),!.
