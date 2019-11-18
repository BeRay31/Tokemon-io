#Tugas Besar Logika Komputasional– IF2121
#Tokemon Pro & Log


DESKRIPSI AWAL
		Terdapat seorang pemain yang mempunyai tokeballs dan 1 pokemon starter yaitu tokemon X.
	Player ini mempunyai batas maksimal 6 tokemon dalam inventori.
		Map yang dibuat dibuat random dengan panjang dan lebar antara 10-15 dengan 3 tipe yaitu 
	G,_,X. G untuk Gym, _ untuk lahan kosong, X untuk Obstacle. Pada map seolah olah terdapat
	tokemon yang berkeliaran namun tidak ditampilkan.
		Terdapat 7 tokemon legendary yang lebih kuat dari tokemon biasa, tokemon legendary adalah
	tokemon terpilih dari tiap tipe tokemon. Peluang bertemu tokemon legendary adalah 7/150, 
	sementara peluang bertemu tokemon biasa adalah 43/150. Tokemon biasa berjumlah 43.
		Gerak pemain dieksekusi dengan moving command yaitu w,a,s,d. w untuk ke arah atas, a untuk
	ke arah kiri, s untuk ke arah bawah, dan d untuk ke arah kanan.
		Tokemon memiliki 6 parameter yaitu nama, tipe, HP atau Health Point, Normal Attack (integer),
	Special Attack(integer). Tokemon memiliki 5 tipe yaitu Fire, Nighmare, Water, Dark, Light. Setiap
	tokemon dapat menggunakan special attacknya 1 x per pertarungan dan damage special attack yang 
	ditimbulkan lebih besar dari normal attack. Damage tiap tokemon adalah unik, namun tidak menutup
	kemungkinan sama. Rentang HP tokemon biasa adalah 200 -- 495. Rentang HP tokemon legend adalah 
	900-1000.

MEKANISME BATTLE
		Pemain menulis command start. Player dapat menjalankan playernya sesuai peta yang diberikan. 
	Jika player bertemu tokemon, maka dapat memilih fight atau run. Jika player memilih run, player 
	belum tentu dapat run, karena terdapat kemungkinan kondisi dimana player harus tetap memilih 
	fight. Jika player memilih fight, maka akan ditampilkan status dari tokemon player dan tokemon 
	liar. Jika di inventori terdapat lebih dari 1 tokemon, player dapat memilih tokemon yang player 
	mau untuk melawan tokemon liar. Jika tokemon yang player pilih kalah, akan tetapi masih terdapat 
	tokemon di inventori, maka player dapat pick tokemon dalam inventorinya untuk menggantikan tokemon 
	yang mati. Jika player menang, akan ada pilihan antara capture tokemon atau leave tokemon. Ketika 
	inventori player penuh, sementara player berkeinginan untuk capture, player harus men-drop tokemon
	dalam inventorinya untuk digantikan tokemon yang ditangkap. Jika player berada di lokasi gym, maka
	mempunyai pilihan untuk heal HP. Player tidak dapat melewati obstacle.
		Urutan kekuatan tipe tokemon dimulai dari yang paling kuat adalah Water,Fire,Light,Dark,Nightmare. 
	Jika tokemon yang lebih lemah menyerang tokemon yang lebih kuat, maka damage yang diterima tokemon 
	yang lebih kuat adalah setengah dari attack yang diberikan tokemon lemah. Jika tokemon yang lebih 
	kuat menyerang tokemon yang lebih lemah, maka damage yang diterima tokemon yang lemah adalah 3/2 
	dari attack yang diberikan tokemon kuat. Jika tokemon yang diserang bertipe sama, maka damage yang diterima 
	tetap sama.
		Player dinyatakan menang, jika tokemon legendary sudah dikalahkan semua atau semua tokemon 
	legendary sudah terdapat di inventori. Player dinyatakan kalah, jika semua pokemon dalam inventorinya
	mati semua. 

COMMAND
	1. start : memulai permainan.
	2. help : menampilkan fungsi-fungsi yang dapat dipanggil dalam permainan dan informasi lain.
	3. quit : Keluar dari permainan.
	4. w : Bergerak kearah Utara(atas).
	5. d : Bergerak kearah Timur(kanan).
	6. a : Bergerak kearah Barat(kiri).
	7. s : Bergerak kearah Selatan(bawah).
	8. map : menampilkan peta.
	9. heal : Mengobati semua tokemon yang ada di inventory.
	10. status : Melihat status diri.
	11. pick(tokemon) : Memilih Pokemon untuk digunakan .
	12. attack : Melakukan Normal attack .
	13. specialattack : Melakukan Special attack pada musuh.
	14. run : Memilih lari (dalam battle).
	15. drop(tokemon) : Menghilangkan tokemon dalam inventory.
	16. save (filename) : menyimpan data permainan saat ini dengan nama file tertentu.
	17. load (filename) : Memuat data permainan dari file eksternal.
	
