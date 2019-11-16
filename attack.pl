:- include('player.pl').
:- include('database.pl').

:- dynamic(inBattle/0).
:- dynamic(enemy/2).
:- dynamic(enemyfainted/0).

battleStart(Index) :-
    asserta(inBattle),
    tokemon(Index, Nama, Tipe, HP, _, _),
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
    write('Choose '), status.

run :-
    \+ inBattle,
    write('Cuma bisa dilakukan dalam battle'), !.
run :-
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
    ).

attack :-
    \+ inBattle,
    write('Cuma bisa dilakukan dalam battle'), !.
attack :-
    inBattle,
    battleTokemon(Name),
    tokemon(_, Name, _, _, NA, _),
    inventory(Name, HP),
    retract(enemy(EName, EHP)),
    tokemon(_, EName, _, _, _, _),
    EHPNew is EHP - NA,
    write(Name), write(' attacks!'), nl,
    (EHPNew =< 0)->(
        write(EName), write(' fainted'), nl,
        asserta(enemyfainted)
    );
    {
        write(EName), write(' took '), write(NA), write(' damage!'), nl
    }.