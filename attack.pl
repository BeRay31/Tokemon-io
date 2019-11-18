:- include('player.pl').


:- dynamic(inBattle/0).     /*Nunjukkin lagi battle atau nggak*/
:- dynamic(enemy/2).        /*Nyimpen nama dan current health enemy*/
:- dynamic(enemyFainted/0).
:- dynamic(specialUsed/0).
:- dynamic(eSpecialUsed/0).
:- dynamic(gameOver/0).
:- dynamic(cantRun/0).
/*effective(X, Y) X(attack) is effective against Y(target)*/
effective(water, fire).
effective(fire, light).
effective(light, dark).
effective(dark, nightmare).
effective(nightmare, water).
/*neffective(X, Y) X is ineffective against Y*/
neffective(fire, water).
neffective(light, fire).
neffective(dark, light).
neffective(nightmare, dark).
neffective(water, nightmare).

battleStart(Index) :-          /*Pesan yang muncul setelah random encounter*/
    asserta(inBattle),
    tokemon(Index, Nama, _, HP, _, _),
    (
        retract(enemy(_,_)),asserta(enemy(Nama,HP));
        asserta(enemy(Nama, HP))
    ),
    write('Tokemon niar nyolot namanya : '), 
    write(Nama),
    (
    legendary(Nama),write('(TOKEMON LEGENDARY)'),nl,write('Tangkep gann!!'); 
    write('(Tokemon Biasa)'),nl,write('Bantaii!!')
    ), 
    nl,
    write('Bertarung ato kabur?'),
    write(' (Masukkan \'fight.\' untuk bertarung atau \'run.\' untuk jadi pengecut :0)'),nl, 
    !.
battleStatus :-
    \+battleTokemon(_),!.
battleStatus :-
    countInventory(Length),
    Length =:= 0, 
    !.
battleStatus :-                /*Munculin Nama, Health, dan Tipe Tokemon yang lagi battle*/
    countInventory(Length),
    \+ (Length =:= 0),
    battleTokemon(Nama),
    inventory(Nama, HP),
    enemy(ENama, EHP),
    tokemon(_, Nama, Tipe, _, _, _),
    tokemon(_, ENama, ETipe, _, _, _),
    ((
        EHP=<0,
        write('Tokemon musuh melemahhh, Serang lagi untuk mengalahkan ...!'),nl
    );
    (
        HP=<0,
        retract(inventory(Nama, HP)),
        write(Nama), write(' pusingg...')

    );
    (
        write('Enemy'), nl,
        write(ENama), nl,
        write('Health   : '), write(EHP), nl,
        write('Tipe     : '), write(ETipe), nl, nl,
        write('You'), nl,
        write(Nama), nl,
        write('Health   : '), write(HP), nl,
        write('Tipe     : '), write(Tipe), nl
    )),!.

fight :-
    \+ inBattle,
    write('Gabisaa kan gaada yang tokemon yang ngajak ribut'), !.
fight :-
    inBattle,
    (
        (cantRun, retract(cantRun));
        \+ cantRun    
    ),
    asserta(cantRun),
    (
        enemyFainted,retract(enemyFainted);
        \+enemyFainted
    ),
    (
        battleTokemon(_);
        write('Choose '), showInventory
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
        (enemyFainted, retract(enemyFainted));
        (\+ enemyFainted)     
    ), 
    battleStatus,
    !.

run :-
    \+ inBattle,
    write('Cuma bisa dilakukan dalam battle'), 
    !.
run :-
    inBattle,
    cantRun,
    write('Gabole kabur lu....'), nl,
    !.
run :-
    \+ cantRun,
    inBattle,
    random(0, 6, R),
    ((R > 3,
        write('Bakat lo jadi pengecut'), nl,
        retract(inBattle),
        retract(enemy(_, _))
    );
    (R =< 3, 
        write('Tokemon terlalu garang'), nl,
        fight
    )), !.

attack :-
    \+ inBattle,
    write('Ma nyerang siapa?????????'), !.

attack :-
    inBattle,
    battleTokemon(Name),
    tokemon(_, Name, Tipe, _, NA, _),
    inventory(Name, _),
    enemy(EName, EHP),
    tokemon(_, EName, ETipe, _, _, _),
    write(Name), write(' attacks!'), nl,
    typeModifier(NA, Tipe, ETipe, Result),
    EHPNew is EHP - Result,
    ((
            EHP =< 0,
            write(EName), write(' pusingg...'), nl,
            asserta(enemyFainted),
            write('Ketik \'capture.\' untuk nangkep '), write(EName), write(' \'leave\' untuk ninggalin dia'), nl
    );
    (
            EHP > 0,
            write(EName), write(' menerima '), write(Result), write(' damage!'), nl,
            retract(enemy(EName,EHP)),
            asserta(enemy(EName, EHPNew)),
            random(0, 101, R),
            enemyTurn(R)
    )),!.



specialAttack :-
    \+ inBattle,
    write('Mau nyerang siapa???????'), !.
specialAttack :-
    inBattle,
    specialUsed,!,
    write('CUMA BISA SEKALI WOI!!'), nl.
specialAttack :-
    inBattle,
    battleTokemon(Name),
    tokemon(_, Name, Tipe, _, _, SA),
    inventory(Name, _),
    enemy(EName, EHP),
    tokemon(_, EName, ETipe, _, _, _),
    write(Name), write(' nyembur pake special attack!'), nl,
    typeModifier(SA, Tipe, ETipe, Result),
    EHPNew is EHP - Result,
    ((
        EHPNew =< 0,
        write(EName), write(' pusingg....'), nl,
        asserta(enemyFainted)
    );
    (
        EHPNew > 0,
        write(EName), write(' menerima '), write(Result), write(' damage!'), nl,
        retract(enemy(EName,EHP)),
        asserta(enemy(EName, EHPNew)),
        random(0, 101, R),
        enemyTurn(R)
    )),
    asserta(specialUsed),
    !.

typeModifier(Damage, TipePenyerang, TipeDiserang, Result) :-
    effective(TipePenyerang, TipeDiserang),
    write('It\'s super effective!'),nl,
    Result is Damage + (Damage // 2), !.
typeModifier(Damage, TipePenyerang, TipeDiserang, Result) :-
    neffective(TipePenyerang, TipeDiserang),
    write('It\'s not very effective...'),nl,
    Result is Damage / 2, !.
typeModifier(Damage, _, _, Result) :-
    Result is Damage.

enemyTurn(_) :-
    enemyFainted,
    afterEnemyTurn.

enemyTurn(Num) :-
    Num =< 70,
    battleTokemon(Name),
    inventory(Name, HP),
    tokemon(_,Name,Tipe,_,_,_),
    enemy(EName, _),
    tokemon(_, EName, ETipe,_, ENA, _),
    write('Tokemon musuh '), write('nyerang '),write(Name), nl,
    typeModifier(ENA, ETipe, Tipe, Result),
    HPNew is HP - Result,
    (
    (
        HPNew > 0,
        write(Name), write(' took '), write(Result), write(' damage!'), nl,
        retract(inventory(Name, HP)),
        asserta(inventory(Name, HPNew))
    );
    (
            HPNew =< 0,
            write(Name), write(' took '), write(Result), write(' damage!'), nl,
            write(Name), write(' terbantai!!!'),nl,
            retract(inventory(Name, HP)),
            retract(battleTokemon(Name))
    )),
    (
        battleStatus,
        afterEnemyTurn
    ),!.
   

enemyTurn(Num) :-
    Num > 70,
    eSpecialUsed, !,
    enemyTurn(1).

enemyTurn(Num) :-
    Num > 70,
    \+ eSpecialUsed,
    battleTokemon(Name),
    inventory(Name, HP),
    tokemon(_, Name, Tipe, _, _, _),
    enemy(EName, _),
    tokemon(_, EName, ETipe, _, _, ESA),
    write('tokemon musuh nyembur '), write(Name), write(' pake special attack!'), nl,
    typeModifier(ESA, ETipe, Tipe, Result),
    HPNew is HP - Result,
    (
    (
        HPNew > 0,
        write(Name), write(' took '), write(Result), write(' damage!'), nl,
        retract(inventory(Name,HP)),
        asserta(inventory(Name, HPNew))
    );
    (
        HPNew =< 0,
        write(Name), write(' took '), write(Result), write(' damage!'), nl,
        write(Name), write(' terbantai!!!'),nl,
        retract(inventory(Name,HP))    
    )),
    asserta(eSpecialUsed),
    (
        battleStatus,
        afterEnemyTurn,!
    ),!.

afterEnemyTurn :-
    enemyFainted,
    (
        specialUsed,retract(specialUsed);
        \+specialUsed
    ),
    (
         eSpecialUsed,retract(eSpecialUsed);
        \+eSpecialUsed
    ),
    !.

afterEnemyTurn :-
    countInventory(Length),
    Length =:= 0,
    asserta(gameOver),
    retract(inBattle),
    retract(enemy(_, _)),
    ((
        specialUsed,retract(specialUsed);
        \+specialUsed
    ),
    (
        eSpecialUsed,retract(specialUsed);
        \+eSpecialUsed
    )),
    retract(cantRun),
    gameEnds,
    !. 

afterEnemyTurn :-
    countInventory(Length),
    \+ (Length =:= 0),
    battleTokemon(Nama),
    inventory(Nama, HP),
    ((
        HP>0
    )
    ;
    (
    HP =< 0,
    write('Pilih Tokemon lain'), nl,
    showInventory
    )),
    !.

capture :-
    \+ inBattle,
    write('Apa yang lo mau tangkepp????'), nl,
    !.
capture :-
    inBattle,
    \+ enemyFainted,
    write('Lo terlalu lemah untuk nangkep.'), nl,
    !.
capture :-
    inBattle,
    enemyFainted,
    enemy(NameT,_),
    (
        legendary(NameT),retract(legendary(NameT));
        \+legendary(NameT)
    ),
    retract(enemy(Name, _)),
    countInventory(Length),
    maxInventory(MAX),
    Length < MAX,
    addTokemon(Name),
    write(Name), write(' Tertangkap....!!'), nl,
    retract(inBattle),
    retract(enemyFainted),
    retract(cantRun),
    gameEnds,
    !.
capture :-
    inBattle,
    enemyFainted,
    countInventory(Length),
    maxInventory(MAX),
    Length =:= MAX,
    write('Inventory mu full. \'drop(Tokemon)\' untuk melepas salah satu Tokemonmu'), nl,
    !.

leave :-
    \+ inBattle,
    write('???'), nl,
    !.
leave :-
    inBattle,
    \+ enemyFainted,
    write('Tokemon musuh ga ngebolehin pergi.'), nl,
    !.
leave :-
    inBattle,
    enemyFainted,
    enemy(NameT,_),
    (
        legendary(NameT),retract(legendary(NameT));
        \+legendary(NameT)
    ),
    retract(enemy(_, _)),
    retract(inBattle),
    retract(enemyFainted),
    retract(cantRun),
    gameEnds,
    !.

gameEnds :-
    \+ gameOver,
    legendary(_),
    !.
gameEnds :-
    gameOver,
    write('Lo jadi kuyang HAHAHAH!!!'), nl,
    quit,
    !.
gameEnds :-
    \+ gameOver,
    \+ legendary(_),
    write('SELAMAT lo gajadi kayang'), nl,
    quit,
    !.