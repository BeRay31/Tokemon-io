:- include('map.pl').


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
	asserta(inventory(bebasmon, 480)),
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
	(
		battleTokemon(_),retract(battleTokemon(_));
		\+battleTokemon(_)
	),
	(
		inventory(_,_),forall(inventory(_,_),retract(inventory(_,_)));
		\+inventory(_,_)
	),
	(
		inBattle,retract(inBattle);
		\+inBattle
	),
	(
		enemy(_,_),retract(enemy(_,_));
		\+enemy(_,_)
	),
	(
		enemyFainted,retract(enemyFainted);
		\+enemyFainted
	),
	(
		specialUsed,retract(specialUsed);
		\+specialUsed
	),
	(
		eSpecialUsed,retract(eSpecialUsed);
		\+eSpecialUsed
	),
	(
		gameOver,retract(gameOver);
		\+gameOver
	),
	(
		cantRun,retract(cantRun);
		\+cantRun
	),
	(
		legendary(_),forall(legendary(_),retract(legendary(_)));
		\+legendary(_)
	),
	retract(healAvl(_)),
	retract(lebarPeta(_)),
	retract(tinggiPeta(_)),
	retract(gym(_,_)),
	forall(obstacle(_,_),retract(obstacle(_,_))),
	retract(maxInventory(_)),
	retract(main(_)),!.

/*Menuliskan status tokemon dengan rincian nama, health, dan type.*/	
status :-
	\+ main(_),
	write('Ente belum mulai main gayn'), nl,
	!.
status :-
	inBattle,
	showInventory,!.
status :-
	showInventory,nl, sisalegend,!.

sisalegend :-
	write('Tokemon legend yang tersisa'), nl,
	forall(legendary(LName), 
	(
		write(LName), nl
	)
	), nl, !.

showInventory :-
	write('Your tokemon :'),nl,
	inventory(_,_)->(
		forall(inventory(Name,Hp),
		(
			tokemon(_,Name,Type,_,NA,SA),
			((
				inventory(Name,HP),
				HP>=0,
				tokemon(_,Name,Type,_,NA,SA),
				write(Name),nl,
                write('Health                  : '),write(Hp),nl,
				write('Type                    : '),write(Type),nl,
				write('Normal Attack Damage    : '),write(NA),nl,
				write('Special Attack Damage   : '),write(SA),nl,nl
			);
			(
				HP<0
			))
		)
		)),nl,!.
%---------------------------------------HEAL-------------------------
/*Jika sedang battle, command dinonaktifkan. Jika tidak sedang battle masuk ke rules heal selanjutnya*/
heal :-
	\+ main(_),
	write('Game belum mulai bang'), nl,
	!.
heal :-
	inBattle,
	write('GABISAA!!! lo dalam battle.!!'),nl,!.

/*Mengecek player di gym atau tidak. Jika player tidak berada di gym, player tidak bisa heal. Jika berada di gym, lanju*/
heal :-
	\+(player(5,5)),
	write('LIAT TEMPAT!! Mana ada tempat ngeheal disini!'),nl,!.

/*Mengecek heal avaliable.
Jika heal tidak avaliable, tidak bisa heal.
Jika heal availiable, lanjut ke rules heal selanjutnya. */
heal :-
	\+healAvl(_),
	write('Sekali doang ngeheal !'),!.

/*Player berada di gym. Heal dapat dilakukan.*/
heal :-
	player(5,5),
	forall(inventory(N,_),
	(
		tokemon(_,N,_,HP,_,_),
		retract(inventory(N,_)),
		asserta(inventory(N,HP))
	)),!,
	retract(healAvl(_)),
	write('Tokemon diberi obat Kuat supaya sehat dan kuat.!'),nl.

%---------------------------------------DROP-------------------------
/*Jika tokemon di inventory tinggal 1, tokemon tidak dapat dibuang.*/
drop(_) :- 
	\+ main(_),
	write('Start game dulu atuh'), nl, 
	!.
drop(_) :-
	countInventory(X),
	X =:= 1,
	write('Tokemon tinggal 1 gabisa dibuang dongg...'),nl,
	!.

/*Tokemon tidak ada di inventory*/
drop(Name) :-
	\+ inventory(Name,_),
	format('~w gak ada di inventory ~n', [Name]),!.

/*Berhasil dibuang*/
drop(Name):-
	retract(inventory(Name,_)),
	format('~w telah dibuang dari inventory :( ~n',[Name]).

%---------------------------------------PICK & COUNT-------------------------
/*Memilih tokemon yang dipakai untuk battle.*/
pick(_) :-
	\+ main(_),
	write('Start the game first pls ty'), nl, 
	!.
pick(Name):-
	\+ inventory(Name,_),
	format('lo gapunya ~w di inventory ~n',[Name]),!.
pick(Name) :-
	battleTokemon(Name),
	format('~w Sudah lo pilih ANJIR!!!!, mau dianggap apa dia!!!!',[Name]),!.
pick(Name) :-
	inventory(Name, _),
	(
		(battleTokemon(_),retract(battleTokemon(_)));
		(\+battleTokemon(_))
	),
	asserta(battleTokemon(Name)),
	format('~w dipilih sebagai battle tokemon ~n',[Name]),
	(
		inBattle,battleStatus;
		\+inBattle	
	),!.

/*Fungsi rekursif untuk menghitung anggota List*/
listCount([], 0) :- !.
listCount([_ | T], Length) :- listCount(T, N), Length is N + 1.

/*Menghitung tokemon yang ada dalam inventory.*/
countInventory(Length) :-
    findall(N, inventory(N,_), ListInventory),
    listCount(ListInventory, Length), !.

/*Menghitung pokemon legend yang berada di inventory.*/
countUniqueLegend(Length) :-
	findall(legend(Name),inventory(Name,_),List),
	listCount(List,Length),!.

%---------------------------------------ADD-------------------------
/*Menambahkan tokemon ke dalam inventori, jika tokemon sudah ada dalam inventory, penambahan akan gagal.*/
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

%-------------------------CEK PLACE --------------------------

/*Jika player berada di gym, beritahu player, bahwa player berada di gym.
Jika tidak, masuk ke cekPlace selanjutnya*/
cekPlace(X,Y) :-
	gym(X,Y),
	write('Lo di Gym , bisa ngeheal tokemon lohh tapi cuma sekali!!!!'),!.

/**/
cekPlace(_, _) :-
	random(1,150,Index),
	Index=<50,
	tokemon(Index,Name,_,_,_,_),
	\+(inventory(Name,_)),
	battleStart(Index),!.
cekPlace(_,_) :-
	write('Padang rumput yang hijau...'),nl,!.
