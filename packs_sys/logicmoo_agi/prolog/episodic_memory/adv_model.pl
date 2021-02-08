/*
% NomicMUD: A MUD server written in Prolog
% Maintainer: Douglas Miles
% Jan 19, 2038 @ 03:14:07
%
% Bits and pieces:
%
% LogicMOO, Inform7, FROLOG, Guncho, PrologMUD and Marty's Prolog Adventure Prototype
%
% Copyright (C) 2004 Marty White under the GNU GPL
% Sept 20, 1999 - Douglas Miles
% July 10, 1996 - John Eikenberry
%
% Logicmoo Project changes:
%
% Main file.
%
*/

must_be_same(X, Y):- must(X==Y).
model_prepend(X, Y, Z):- append(X, Y, Z).
model_remove_if(X, Y, Z):- select(X, Y, Z).
model_remove_always(X, Y, Z):- select_always(X, Y, Z).
%:- ensure_loaded(adv_main).

% TODO: change agent storage into a term:
% mind(DoerName, DoerType, History, ModelData, Goals /*, ToDo*/)

model_recent(X, List, List):-
  old_figment(X, _F, _A, XNew),
  member(XNew, List), !,
  XNew=X.


% -------- Model updating predicates (here M stands for ModelData)

% Fundamental predicate that actually modifies the list:
remove_old_parents(_Spatial, '<mystery>'(_, _, _), _Timestamp, M0, M0) :- !.
remove_old_parents(_Spatial, [], _Timestamp, M0, M0) :- !.
remove_old_parents(Spatially, [Orphan|Tail], Timestamp, M0, M2) :-
 make_orphan(Spatially, Orphan, Timestamp, M0, M1),
 remove_old_parents(Spatially, Tail, Timestamp, M1, M2).
 
make_orphan(Spatially, Orphan, _Timestamp, M0, M2) :-
 model_remove(h(Spatially, OldPrep, Orphan, OldParent), M0, M1),
 model_prepend([h(Spatially, OldPrep, Orphan, '<mystery>'(removed, OldPrep, OldParent))], M1, M2).
make_orphan(_Spatially, _Orphan, _Timestamp, M0, M0).
 

remove_old_children(Spatially, Prep, Parent, RetainedChildren, Timestamp, M0, M3) :-
 in_model(h(Spatially, Prep, OldChild, Parent), M0, M1),
 \+ member(OldChild,RetainedChildren), !,
 make_orphan(Spatially, OldChild, Timestamp, M1, M2), 
 remove_old_children(Spatially, Prep, Parent, Timestamp, M2, M3).
remove_old_children(_Spatial, _Prep, _Parent, _Timestamp, M0, M0).


update_children(Spatially, Prep, Object, '<mystery>'(How, WhatPrep, Object2), _Timestamp, M0, M1):- !,
 \+ in_model(h(Spatially, WhatPrep, Object, _), M0) 
 -> model_prepend([h(Spatially, Prep, Object, '<mystery>'(How, WhatPrep, Object2))], M0, M1) ; M0 = M1.
update_children(Spatially, Prep, Object, '<mystery>'(How, WhatPrep, Object2), _Timestamp, M0, M1):- 
 \+ in_model(h(Spatially, WhatPrep, _, Object), M0),
 model_prepend([h(Spatially, Prep, '<mystery>'(How, WhatPrep, Object2), Object)], M0, M1), !.
update_children(Spatially, Prep, Parent, [], Timestamp, M0, M1):- 
  remove_old_children(Spatially, Prep, Parent, [], Timestamp, M0, M1).
update_children(Spatially, PrepNew, Object, [Item|Tail], Timestamp, M0, M2) :-
  add_children(Spatially, PrepNew, Object, [Item|Tail], Timestamp, M0, M1),!,
  remove_old_children(Spatially, PrepNew, Object, [Item|Tail], Timestamp, M1, M2).

add_children(_Spatial, _PrepNew, _NewParent, [], _Timestamp, M0, M0):- !.
add_children(Spatially, PrepNew, NewParent, [Item|Tail], Timestamp, M0, M2) :-
 add_child(Spatially, PrepNew, NewParent, Item, Timestamp, M0, M1),
 add_children(Spatially, PrepNew, NewParent, Tail, Timestamp, M1, M2).

add_child(Spatially, Prep, Object, Child, Timestamp, M0, M2):- 
  make_orphan(Spatially, Child,  Timestamp, M0, M1),
  model_prepend([h(Spatially, Prep, Child, Object)], M1, M2).


% If dynamic topology needs storing, use
%  h(Spatially,exit(E), Here, [There1|ThereTail], Timestamp)

realize_model_exit(Spatially, At, From, _Timestamp, M0, M2) :-
 model_recent(h(Spatially, exit(At), From, _To), M0, M2), !.
/*realize_model_exit(Spatially, At, From, _Timestamp, M0, M2) :-
 model_remove_if((h(exit(At), From, To)), M0, M1), !,
 model_prepend([(h(exit(At), From, To))], M1, M2).
*/
realize_model_exit(Spatially, At, From, _Timestamp, M0, M1) :-
 model_prepend([(h(Spatially, exit(At), From, '<mystery>'(exit, At, From)))], M0, M1), !.

update_model_exit(Spatially, At, From, To, _Timestamp, M0, M2) :-
 model_recent((h(Spatially, exit(At), From, _To)), M0, M1),
 model_prepend([(h(Spatially, exit(At), From, To))], M1, M2).


% Model exits from Here.
update_model_exits(_Spatial, [], _From, _T, M, M).
update_model_exits(Spatially, [Exit|Tail], From, Timestamp, M0, M2) :-
 realize_model_exit(Spatially, Exit, From, Timestamp, M0, M1),
 update_model_exits(Spatially, Tail, From, Timestamp, M1, M2).


dumpST_break:- dumpST, break.

update_model(Knower, event3('arrive',Doer,[ In, Here, Walk, ExitNameReversed]), Timestamp, Mem, M0, M2) :-
   \+ in_model(h(_Spatial,exit(ExitNameReversed), Here, _There), M0),
   realize_model_exit(spatial, ExitNameReversed, Here, Timestamp, M0, M1),
 update_model(Knower, event3('arrive',Doer,[ In, Here, Walk, ExitNameReversed]), Timestamp, Mem, M1, M2).

% Match only the most recent Figment in Memory.
%last_thought(Figment, Memory) :- % or member1(F, M), or memberchk(Term, List)
% copy_term(Figment, FreshFigment),
% model_prepend(RecentMemory, [Figment|_Tail], Memory),
% \+ member(FreshFigment, RecentMemory).

update_model(Knower, event3('arrive',Doer,[ At, Here, _, ExitNameReversed]), Timestamp, Mem, M0, M2) :- Knower == Doer,
  % According to model, where was I?
  must_mw(in_model(h(_Was, Doer, There), M0)),
  % TODO: Handle goto(Doer, walk, on, table)
  % reverse_dir(ExitNameReversed, ExitName, advstate),
  % How did I get Here?
 model_prepend(RecentMem, [ attempts(Doer, ( act3('go__dir',Doer,[ _, ExitName])))| OlderMem], Mem),
    % find figment
 \+ member( attempts(Doer,  act3('go__dir',Doer,[ _, _])), RecentMem), % guarrantee recentness
  memberchk(timestamp(_T1, _OldNow), OlderMem), % get associated stamp
  %player_format(Doer, '~p moved: goto(Doer, walk, ~p, ~p) from ~p leads to ~p~n', 
  %       [Doer, AtGo, Dest, There, Here]),
  Spatially = spatial,
  update_model_exit(Spatially, ExitName, There, Here, Timestamp, M0, M11), % Model the path.
  update_model_exit(Spatially, ExitNameReversed, Here, There, Timestamp, M11, M1),
  add_child(Spatially, At, Here, Doer, Timestamp, M1, M2), !. % And update location.

update_model(Knower, event3('arrive',Doer,[ In, Here, Walk, ExitNameReversed]), Timestamp, Mem, M0, M2) :-
  Spatially = spatial,
   \+ in_model(h(Spatially, In, Doer, Here), M0),
   update_children(Spatially,  In, [Doer], Here, Timestamp, M0, M1),
 update_model(Knower, event3('arrive',Doer,[ In, Here, Walk, ExitNameReversed]), Timestamp, Mem, M1, M2).

update_model(_Knower, event3('moved', _Doer, [ _How, Object, _From, At, To]), Timestamp, _Mem, M0, M1) :-
  Spatially = spatial,
  update_children(Spatially, At, Object, To, Timestamp, M0, M1).

/*
update_model(Knower, Event, Timestamp, Memory, M0, M2) :- fail,
  implications(event , Event, Preconds, Postconds),
    (satisfy_each(preCond(_), Preconds, M0, _)  ->
      satisfy_each(postCond(_), Postconds, M0, M1) -> M0\=@= M1), !,
    update_model(Knower, Event, Timestamp, Memory, M1, M2).
*/

update_model(_Knower, carrying(Doer, Objects), Timestamp, _Memory, M0, M1) :- 
  Spatially = spatial, 
  update_children(Spatially,  held_by, Doer, Objects, Timestamp, M0, M1).

update_model(_Knower, wearing(Doer, Objects), Timestamp, _Memory, M0, M1) :- 
  Spatially = spatial, 
  update_children(Spatially,  worn_by, Doer, Objects, Timestamp, M0, M1).

update_model(_Knower, percept_props(_Doer, _Sense, Object, _Depth, PropList), _Stamp, _Mem, M0, M2) :-
 apply_mapl_rest_state(updateprop_from_create(Object), PropList, [], M0, M2).

update_model(_Knower, props(Object, PropList), _Stamp, _Mem, M0, M2) :-
  apply_mapl_rest_state(updateprop(Object), PropList, [], M0, M2).

% Wrong Doer !
update_model(Knower, percept(Doer2, _, _, _Info), _Timestamp, _Mem, M0, M0):- Knower \=@= Doer2, !.
% Model exits from Here.
update_model(Knower, percept(Doer, _, _, exit_list(in, Here, ExitRelations)), Timestamp, _Mem, M0, M4) :- must_be_same(Knower, Doer),
  Spatially = spatial, 
  update_model_exits(Spatially, ExitRelations, Here, Timestamp, M0, M4).

% Model objects seen Here.. This is no longer used right?
update_model(Knower, percept(Doer, _Sense, child_list(Spatially, _Depth, There, Prep, Objects)), Timestamp, _Mem, M0, M3):- must_be_same(Knower, Doer),
   dumpST_break, !,
   update_children(Spatially, Prep, Objects, There, Timestamp, M0, M3).
% Model objects seen Here ... this replaces the above code
update_model(Knower, percept(Doer, _Sense, _Depth, child_list(Spatially, Object, At, Children)), Timestamp, _Mem, M0, M2) :- must_be_same(Knower, Doer),
   update_children(Spatially,  At, Children, Object, Timestamp, M0, M2).
% Copy objects props Here
update_model(Knower, percept(Doer, _Sense, _Depth, props(Object, PropList)), _Stamp, _Mem, M0, M2) :- must_be_same(Knower, Doer),
  apply_mapl_rest_state(updateprop_from_create(Object), PropList, [], M0, M2).

update_model(_Knower, [], _Timestamp, _Memory, M, M).
update_model( Knower, [Percept|Tail], Timestamp, Memory, M0, M2) :-
 update_model(Knower, Percept, Timestamp, Memory, M0, M1),
 update_model(Knower, Tail, Timestamp, Memory, M1, M2), !.
update_model(_Knower, failure(_, _), _Timestamp, _Mem, M0, M0) :- !.
update_model(_Knower, success(_, _), _Timestamp, _Mem, M0, M0) :- !.
update_model(_Knower, failure(_), _Timestamp, _Mem, M0, M0) :- !.
update_model(_Knower, event3('emote',_,[ _, _, _]), _Timestamp, _Mem, M0, M0) :- !.
update_model(_Knower, act3('emote',_,[ _, _, _]), _Timestamp, _Mem, M0, M0) :- !.
update_model(_Knower, msg(_), _Timestamp, _Mem, M0, M0) :- !.

update_model(Knower, time_passes(Target), Timestamp, _Memory, M, M):-
 nop(dbug1(unused_update_model(Knower, time_passes(Target), Timestamp, M))).

update_model(Knower, Percept, Timestamp, _Memory, M, M):-
 nop(dbug1(failed_update_model(Knower, Percept, Timestamp), model)).


is_stored_at_all(none).

maybe_store(Percept, M0, M0):- safe_functor(Percept, F, _), is_stored_at_all(F), !.
%maybe_store(percept_props(Whom, see, What, Depth, _List), M0, M1):- maybe_store(percept_props(Whom, see, WhatDepth, ), M0, M1), !.
maybe_store(Percept, M0, M1):- model_prepend([Percept], M0, M1).

each_update_model(_Knower, [], _Timestamp, _Memory, M, M):- !.
each_update_model( Knower, [Percept|Tail], Timestamp, Memory, M0, M3) :-
 must_mw1(maybe_store(Percept, M0, M1)),
 must_mw1(apply_to_goal(update_model(Knower, Percept, Timestamp, Memory), M1, M2)),
 must_mw1(each_update_model( Knower, Tail, Timestamp, Memory, M2, M3)).


