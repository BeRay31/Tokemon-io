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



start :-
	main(_),
	write('Kamu tidak bisa memulai game ketika game sudah dimulai.'), nl, !.
	
start :-
	write(' _____  ____  _  __ _____ _      ____  _'),nl,     
	write('/__ __\/  _ \/ |/ //  __// \__/|/  _ \/ \  /|'),nl,
	write('  / \  | / \||   / |  \  | |\/||| / \|| |\ ||'),nl,
	write('  | |  | \_/||   \ |  /_ | |  ||| \_/|| | \||'),nl,
	write('  \_/  \____/\_|\_\\____\\_/  \|\____/\_/  \|'),nl,
	write('Gotta catch em all!.'),nl,nl,nl,
	write('Hello there! Welcome to the world of Tokemon! My name is Aril! (BODOAMAT)'),nl,
	write('People call me the Tokemon Professor! This world is inhabited by'),nl,
	write('creatures called Tokemon! There are hundreds of Tokemon loose in '),nl,
	write('Labtek 5! You can catch them all to get stronger, but what I\'m'),nl,
	write('really interested in are the 2 legendary Tokemons, Icanmon dan '),nl,
	write('Sangemon. If you can defeat or capture all those Tokemons I will'),nl,
	write('not kill you.'),nl,
	nl,
	write('Game Mulai'),nl,
	help,nl,nl,
	init_map,
	!.
	


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
	write('P    :    Player'), nl,
	write('X    :    Border'), nl,
	write('x    :    Obstacle'), nl,
	write('G	:	 Gym'),nl,
	write('_    :    Lahan kosong'), nl,
	!.



/* Movement */
w :-
	\+main(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
w :-
	retract(player(X,Y)),
	Y > 1,
	YBaru is Y-1,
	write([X,YBaru]),nl,
	asserta(player(X,YBaru)),!.
d :-
	\+main(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.

d :-
	retract(player(X,Y)),
	lebarPeta(Le),
	X < Le,
	XBaru is X+1,
	write([XBaru,Y]),nl,
	asserta(player(XBaru,Y)),!.
a :-
	\+main(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.

a :-
	retract(player(X,Y)),
	X > 1,
	XBaru is X-1,
	write([XBaru,Y]),nl,
	asserta(player(XBaru,Y)),!.
	
s :-
	\+main(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.

s :-
	retract(player(X,Y)),
	tinggiPeta(Ti),
	Y < Ti,
	YBaru is Y+1,
	write([X,YBaru]),nl,
	asserta(player(X,YBaru)),!.
