:- include('player.pl').


:- dynamic(inBattle/0).     /*Nunjukkin lagi battle atau nggak*/
:- dynamic(enemy/2).        /*Nyimpen nama dan current health enemy*/
:- dynamic(enemyFainted/0).
:- dynamic(specialUsed/0).
:- dynamic(eSpecialUsed/0).
:- dynamic(gameOver/0).
:- dynamic(cantRun/0).
/*effective(X, Y) X is effective against Y*/
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
    asserta(enemy(Nama, HP)),
    write('Tokemon niar nyolot namanya : '), 
    write(Nama),
    (
    legendary(Nama),write('(TOKEMON LEGENDARY)'),nl,write('Tangkep gann!!'); 
    write('(Tokemon Biasa)'),nl,write('Bantaii!!')
    ), 
    nl,
    write('Fight or Run?'),
    write(' (Masukkan \'fight.\' untuk bertarung atau \'run.\' untuk jadi pengecut :0)'), nl, 
    !.

battleStatus :-                /*Munculin Nama, Health, dan Tipe Tokemon yang lagi battle*/
    battleTokemon(Nama),
    inventory(Nama, HP),
    enemy(ENama, EHP),
    tokemon(_, Nama, Tipe, _, _, _),
    tokemon(_, ENama, ETipe, _, _, _),
    write('Enemy'), nl,
    write(ENama), nl,
    write('Health   : '), write(EHP), nl,
    write('Tipe     : '), write(ETipe), nl, nl,
    write('You'), nl,
    write(Nama), nl,
    write('Health   : '), write(HP), nl,
    write('Tipe     : '), write(Tipe), nl,
    !.

fight :-
    \+ inBattle,
    write('Gabisaa kan gaada yang nyolot'), !.
fight :-
    inBattle,
    asserta(cantRun),
    write('Choose '), status, 
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
    (R > 3,
        write('Bakat lo jadi pengecut'), nl,
        retract(inBattle),
        retract(enemy(_, _))
    );
    (R =< 3, 
        write('Tokemon terlalu garang'), nl,
        fight
    ), !.

attack :-
    \+ inBattle,
    write('Cuma bisa dilakukan dalam battle'), !.
attack :-
    inBattle,
    battleTokemon(Name),
    tokemon(_, Name, _, _, NA, _),
    inventory(Name, _),
    retract(enemy(EName, EHP)),
    tokemon(_, EName, _, _, _, _),
    EHPNew is EHP - NA,
    write(Name), write(' attacks!'), nl,
    (EHPNew =< 0)->(
        write(EName), write(' pusingg...'), nl,
        asserta(enemyFainted),
        write('Ketik \'capture.\' untuk nangkep '), write(EName), write(' \'leave\' untuk ninggalin dia'), nl
    );
    (
        write(EName), write(' menerima '), write(NA), write(' damage!'), nl,
        asserta(enemy(EName, EHPNew)),
        random(0, 101, R),
        enemyTurn(R)
    ),
    !.

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
    retract(enemy(EName, EHP)),
    tokemon(_, EName, ETipe, _, _, _),
    write(Name), write(' nyembur pake special attack!'), nl,
    typeModifier(SA, Tipe, ETipe, Result),
    EHPNew is EHP - Result,
    (EHPNew =< 0)->(
        write(EName), write(' pusingg....'), nl,
        asserta(enemyFainted)
    );
    (
        write(EName), write(' menerima '), write(SA), write(' damage!'), nl,
        asserta(enemy(EName, EHPNew)),
        random(0, 101, R),
        enemyTurn(R)
    ),
    asserta(specialUsed),
    !.

typeModifier(Damage, TipePenyerang, TipeDiserang, Result) :-
    effective(TipePenyerang, TipeDiserang),
    write('It\'s super effective!'),
    Result is Damage + (Damage // 2), !.
typeModifier(Damage, TipePenyerang, TipeDiserang, Result) :-
    neffective(TipePenyerang, TipeDiserang),
    write('It\'s not very effective...'),
    Result is Damage / 2, !.
typeModifier(Damage, _, _, Result) :-
    Result is Damage.

enemyTurn(Num) :-
    Num =< 70, !,
    battleTokemon(Name),
    inventory(Name, HP),
    retract(inventory(Name, HP)),
    enemy(EName, _),
    tokemon(_, EName, _,_, ENA, _),
    HPNew is HP - ENA,
    write('The enemy '), write(Name), write(' attacks!'), nl,
    (HPNew =< 0)->(
        write(Name), write(' pusingg...')
    );
    (
        write(Name), write(' took '), write(ENA), write(' damage!'), nl,
        asserta(inventory(Name, HPNew))
    ),
    afterEnemyTurn,
    enemyTurn(Num).

enemyTurn(Num) :-
    Num > 70,
    eSpecialUsed, !,
    enemyTurn(1).

enemyTurn(Num) :-
    Num > 70, !,
    \+ eSpecialUsed,
    battleTokemon(Name),
    retract(inventory(Name, HP)),
    tokemon(_, Name, Tipe, _, _, _),
    enemy(EName, _),
    tokemon(_, EName, ETipe, _, _, ESA),
    write('tokemon musuh  '), write(Name), write(' nyembur pake special attack!'), nl,
    typeModifier(ESA, ETipe, Tipe, Result),
    HPNew is HP - Result,
    (HPNew =< 0)->(
        write(Name), write(' pusing....')
    );
    (
        write(Name), write(' took '), write(ESA), write(' damage!'), nl,
        asserta(inventory(Name, HPNew))
    ),
    asserta(eSpecialUsed),
    afterEnemyTurn.

afterEnemyTurn :-
    countInventory(Length),
    Length =:= 0,
    asserta(gameOver),
    retract(inBattle),
    retract(enemy(_, _)),
    retract(specialUsed),
    retract(eSpecialUsed),
    retract(cantRun),
    gameEnds,
    !.

afterEnemyTurn :-
    enemyFainted,
    retract(specialUsed),
    retract(eSpecialUsed),
    !.

afterEnemyTurn :-
    countInventory(Length),
    \+ (Length =:= 0),
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
    retract(enemy(Name, _)),
    countInventory(Length),
    maxInventory(MAX),
    Length < MAX,
    addTokemon(Name),
    write(Name), write(' Hoki lu bisa nangkep.'), nl,
    retract(inBattle),
    retract(enemyFainted),
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
    retract(enemy(_, _)),
    retract(inBattle),
    retract(enemyFainted),
    !.

gameEnds :-
    gameOver,
    write('Lo jadi kuyang HAHAHAH!!!'), nl,
    quit,
    !.
gameEnds :-
    \+ gameOver,
    write('SELAMAT lo gajadi kayang'), nl,
    quit,
    !.