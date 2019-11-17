:- include('player.pl').


:- dynamic(inBattle/0).
:- dynamic(enemy/2).
:- dynamic(enemyFainted/0).
:- dynamic(specialUsed/0).
:- dynamic(eSpecialUsed/0).
:- dynamic(gameOver/0).
:- dynamic(cantRun/0).

battleStart(Index) :-
    asserta(inBattle),
    tokemon(Index, Nama, _, HP, _, _),
    asserta(enemy(Nama, HP)),
    write('A wild '), write(Nama), write(' appeared!'), nl,
    write('Fight or Run?'),
    write(' (Masukkan \'fight.\' untuk bertarung atau \'run.\' untuk lari)'), nl, 
    !.

fight :-
    \+ inBattle,
    write('Cuma bisa dilakukan dalam battle'), !.
fight :-
    inBattle,
    asserta(cantRun),
    write('Choose '), status, !.

run :-
    \+ inBattle,
    write('Cuma bisa dilakukan dalam battle'), 
    !.
run :-
    inBattle,
    cantRun,
    write('There is no escape.'), nl,
    !.
run :-
    \+ cantRun,
    inBattle,
    random(0, 6, R),
    (R > 3,
        write('You successfully escaped!'), nl,
        retract(inBattle),
        retract(enemy(_, _))
    );
    (R =< 3, 
        write('You failed to run away!'), nl,
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
        write(EName), write(' fainted'), nl,
        asserta(enemyFainted)
    );
    (
        write(EName), write(' took '), write(NA), write(' damage!'), nl,
        asserta(enemy(EName, EHPNew)),
        random(0, 101, R),
        enemyTurn(R)
    ),
    !.

specialAttack :-
    \+ inBattle,
    write('Cuma bisa dilakukan dalam battle'), !.
specialAttack :-
    inBattle,
    battleTokemon(Name),
    tokemon(_, Name, _, _, _, SA),
    inventory(Name, _),
    retract(enemy(EName, EHP)),
    tokemon(_, EName, _, _, _, _),
    EHPNew is EHP - SA,
    write(Name), write(' uses their special attack!'), nl,
    (EHPNew =< 0)->(
        write(EName), write(' fainted'), nl,
        asserta(enemyFainted)
    );
    (
        write(EName), write(' took '), write(SA), write(' damage!'), nl,
        asserta(enemy(EName, EHPNew)),
        random(0, 101, R),
        enemyTurn(R)
    ),
    !.

enemyTurn(Num) :-
    Num =< 70,
    battleTokemon(Name),
    retract(inventory(Name, HP)),
    enemy(EName, _),
    tokemon(_, EName, _, ENA, _),
    HPNew is HP - ENA,
    write('The enemy '), write(Name), write(' attacks!'), nl,
    (HPNew =< 0)->(
        write(Name), write(' fainted')
    );
    (
        write(Name), write(' took '), write(ENA), write(' damage!'), nl,
        asserta(inventory(Name, HPNew))
    ),
    afterEnemyTurn,
    !.

enemyTurn(Num) :-
    Num > 70,
    eSpecialUsed,
    enemyTurn(1), !.

enemyTurn(Num) :-
    Num > 70,
    \+ especialused,
    battleTokemon(Name),
    retract(inventory(Name, HP)),
    enemy(EName, _),
    tokemon(_, EName, _, _, ESA),
    HPNew is HP - ESA,
    write('The enemy '), write(Name), write(' uses their special attack!'), nl,
    (HPNew =< 0)->(
        write(Name), write(' fainted')
    );
    (
        write(Name), write(' took '), write(ESA), write(' damage!'), nl,
        asserta(inventory(Name, HPNew))
    ),
    afterEnemyTurn,
    !.

afterEnemyTurn :-
    countInventory(Length),
    Length =:= 0,
    asserta(gameOver),
    retract(inBattle),
    retract(enemy(_, _)),
    retract(specialUsed),
    retract(eSpecialUsed),
    retract(cantRun),
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
