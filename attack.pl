:- include('database.pl').
:- include('player.pl').

:- dynamic(inBattle/0).
:- dynamic(enemy/3).

battleStart(Index) :-
    asserta(inBattle),
    tokemon(Index, Nama, Tipe, HP, _, _),
    asserta(enemy(Nama, Tipe, HP)),
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
        retract(enemy(_, _, _))
    );
    (R =< 3, 
        write('You failed to run away!'), nl,
        fight
    ).