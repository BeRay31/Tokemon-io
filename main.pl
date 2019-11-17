:- include('attack.pl').

/*Menampilkan fungsi-fungsi yang dapat dipanggil dalam permainan.*/
help :-	
	write('Daftar Command : '),nl,
	write('1. start : memulai permainan.'),nl,
	write('2. help : menampilkan fungsi-fungsi yang dapat dipanggil dalam permainan dan informasi lain.'),nl,
	write('3. quit : Keluar dari permainan.'),nl,
	write('4. w : Bergerak kearah Utara(atas).'),nl,
	write('5. d : Bergerak kearah Timur(kanan).'),nl,
	write('6. a : Bergerak kearah Barat(kiri).'),nl,
	write('7. s : Bergerak kearah Selatan(bawah).'),nl,
	write('8. map : menampilkan peta.'),nl,
	write('9. heal : Mengobati semua tokemon yang ada di inventory.'),nl,
	write('10. status : Melihat status diri.'),nl,
	write('11. pick(tokemon) : Memilih Pokemon untuk digunakan .'),nl,
	write('12. attack : Melakukan Normal attack .'),nl,
	write('13. specialattack : Melakukan Special attack pada musuh.'),nl,
	write('14. run : Memilih lari (dalam battle).'),nl,
	write('15. drop(tokemon) : Menghilangkan tokemon dalam inventory.'),nl,
	write('16. save (filename) : menyimpan data permainan saat ini dengan nama file tertentu.'),nl,
	write('17. load (filename) : Memuat data permainan dari file eksternal.'),nl,
	write('Catatan : Semua command di atas diakhiri titik (Misal : "help.")'), nl, !.

%-------------------------------START------------------------------------------------

/*Memulai permainan*/
start :-
	main(_),
	write('Kamu tidak bisa memulai game ketika game sudah dimulai.'), nl, !.

/*Menampilkan judul dan instruksi permainan*/	
start :-
	write(' _________________       _____     ____    ____       ______        ______  _______           _____  _____   ______'),nl,   
	write('/                 \\ ____|\\    \\   |    |  |    |  ___|\\     \\      |      \\/       \\     ____|\\    \\|\\    \\ |\\     \\'),nl,  
	write('\\______     ______//     /\\    \\ |    |  |    | |     \\     \\    /          /\\     \\   /     /\\    \\\\\\    \\| \\     \\'),nl, 
	write('   \\( /    /  )/  /     /  \\    \\ |    | /    // |     ,_____/|  /     /\\   / /\\     | /     /  \\    \\|    \\  \\     |'),nl,
	write('      |   |      |     |    |    ||    |/ _ _//  |     \\-- \\_|/ /     /\\ \\_/ / /    /||     |    |    ||     \\  |    |'),nl,
	write('      |   |      |     |    |    ||    |\\    \\   |     /___/|  |     |  \\|_|/ /    / ||     |    |    ||      \\ |    |'),nl,
	write('     /   //      |\\     \\  /    /||    | \\    \\  |     \\____|\\ |     |       |    |  ||\\     \\  /    /||    |\\ \\|    |'),nl,
	write('    /___//       | \\_____\\/____/ ||____|  \\____\\ |____       /||\\____\\       |____|  /| \\_____\\/____/ ||____||\\_____/|'),nl,
	write('   |    |         \\ |    ||    | /|    |   |    ||    /_____/ || |    |      |    | /  \\ |    ||    | /|    |/ \\|   ||'),nl,
	write('   |____|          \\|____||____|/ |____|   |____||____|     | / \\|____|      |____|/    \\|____||____|/ |____|   |___|/'),nl,
	write('     \\(               \\(    )/      \\(       )/    \\( |_____|/     \\(          )/          \\(    )/      \\(       )/'),nl,
	write('Gotta catch em all!.'),nl,nl,nl,
	write('Hello there! Welcome to the world of Tokemon! My name is Aril!'),nl,
	write('People call me the Tokemon Professor! This world is inhabited by'),nl,
	write('creatures called Tokemon! There are hundreds of Tokemon loose in '),nl,
	write('Labtek 5! You can catch them all to get stronger, but what I\'m'),nl,
	write('really interested in are the  legendary Tokemons.'),nl,
	write('If you can defeat or capture all those Tokemons I will'),nl,
	write('not kill you.'),nl,
	nl,
	write('Game Mulai'),nl,
	init_player,
	init_map,
	!.
	
%------------------------------------------------MAP-------------------

/*Mencetak peta permainan saat ini beserta lokasi pemain, obstacle, lahan kosong, dan */
map :-
	inBattle,
	write('Sedang battle command dinonaktifkan'),nl,!.
map :-
	\+main(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
map :-
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
	write('P : Player'), nl,
	write('X : Obstacle'), nl,
	write('G : Gym'),nl,
	write('_ : Padang rumput'), nl,
	!.

%--------------------------------------------MOVEMENT-------------------

/* Gerak ke atas */
w :-
	\+main(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
w :- 
	inBattle,
	write('Sedang battle command dinonaktifkan'),nl,!.
w :-
	player(X,Y),
	Ytemp is Y - 1,
	obstacle(X,Ytemp),
	write('DUARRRR!!!!!!!! Nabrakkkk!!!!, cari rute lain ..'),!.
w :-
	retract(player(X,Y)),
	Y > 1,
	YBaru is Y-1,
	format('Pindah ke -> '),
	write([X,YBaru]),nl,
	asserta(player(X,YBaru)),
	cekPlace(X,YBaru),!.
/* Gerak ke kanan */
d :-
	\+main(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
d :-
	inBattle,
	write('Sedang battle command dinonaktifkan'),nl,!.
d :-
	player(X,Y),
	Xtemp is X + 1,
	obstacle(Xtemp,Y),
	write('DUARRRR!!!!!!!! Nabrakkkk!!!!, cari rute lain ..'),!.
d :-
	retract(player(X,Y)),
	lebarPeta(Le),
	X < Le,
	XBaru is X+1,
	format('Pindah ke -> '),
	write([XBaru,Y]),nl,
	asserta(player(XBaru,Y)),
	cekPlace(XBaru,Y),!.
/* Gerak ke kiri */
a :-
	\+main(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
a:-
	inBattle,
	write('Sedang battle command dinonaktifkan'),nl,!.
a :-
	player(X,Y),
	Xtemp is X - 1,
	obstacle(Xtemp,Y),
	write('DUARRRR!!!!!!!! Nabrakkkk!!!!, cari rute lain ..'),!.
a :-
	retract(player(X,Y)),
	X > 1,
	XBaru is X-1,
	format('Pindah ke -> '),
	write([XBaru,Y]),nl,
	asserta(player(XBaru,Y)),
	cekPlace(XBaru,Y),!.
/* Gerak ke bawah */	
s :-
	\+main(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
s :- 
	inBattle,
	write('Sedang battle command dinonaktifkan'),nl,!.
s :-
	player(X,Y),
	Ytemp is Y + 1,
	obstacle(X,Ytemp),
	write('DUARRRR!!!!!!!! Nabrakkkk!!!!, cari rute lain ..'),!.
s :-
	retract(player(X,Y)),
	tinggiPeta(Ti),
	Y < Ti,
	YBaru is Y+1,
	format('Pindah ke -> '),
	write([X,YBaru]),nl,
	asserta(player(X,YBaru)),
	cekPlace(X,YBaru),!.




