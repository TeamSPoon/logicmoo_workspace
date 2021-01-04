/*
% NomicMUD: A MUD server written in Prolog
% Maintainer: Douglas Miles
% Dec 13, 2035
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
*/

:- ensure_loaded(adv_axiom).

:- dynamic(mu_global:agent_last_action/3).

time_since_last_action(Agent, When):-
 (mu_global:agent_last_action(Agent, _Action, Last), clock_time(T), When is T - Last) *-> true; clock_time(When).

set_last_action(Agent, Action):-
 clock_time(T),
 retractall(mu_global:agent_last_action(Agent, _, _)),
 assertz(mu_global:agent_last_action(Agent, Action, T)).



cmd_workarround(VerbObj, VerbObj2):-
 VerbObj=..VerbObjL,
 quietly(cmd_workarround_l(VerbObjL, VerbObjL2)),
 VerbObj2=..VerbObjL2.

cmd_workarround_l([Verb|ObjS], [Verb|ObjS2]):- append(ObjS2, ['.'], ObjS).
% look at screendoor -> look screendoor 
cmd_workarround_l([Verb, Relation|ObjS], [Verb|ObjS]):- is_ignorable(Relation), !.
% look at screendoor -> look_at screendoor 
cmd_workarround_l(ObjS, ObjS2):- fail,
 append(Left, [L, R, M|More], ObjS), atom(L), atom(R),
 current_atom(Atom), atomic_list_concat([L, RR], Atom, '_'), RR==R,
 append(Left, [Atom, M|More], ObjS2).
% intend('look', Agent, Spatial) at screen door
cmd_workarround_l( ObjS1, ObjS2):- append(L,[Verb1|R],ObjS1), verb_alias(Verb1, Verb2), append(L,[Verb2|R],ObjS2).
cmd_workarround_l( [Verb|ObjS], [intend,Verb|ObjS]):-  Verb\==intend.

is_ignorable(Var):- var(Var), !, fail.
is_ignorable(at). is_ignorable(in). is_ignorable(to). is_ignorable(the). is_ignorable(a). is_ignorable(spatial).

verb_alias(look, examine) :- fail.



% drop -> move -> touch
subsetof(touch, touch).
subsetof(move, touch).
subsetof(drop, move).
subsetof(eat, touch).
subsetof(hit, touch).
subsetof(put, drop).
subsetof(give, drop).
subsetof(take, move).
subsetof(throw, drop).
subsetof(open, touch).
subsetof(close, touch).
subsetof(lock, touch).
subsetof(unlock, touch).
subsetof(switch, touch).

subsetof(walk, goto).

% feel <- taste <- smell <- look <- listen (by distance)
subsetof(listen, examine).
% subsetof(examine, examine).
subsetof(look, examine).
% in order to smell it you have to at least be in sight distance
subsetof(smell, look).
subsetof(eat, taste).
subsetof(taste, smell).
subsetof(taste, feel).
subsetof(feel, examine).
subsetof(feel, touch).
subsetof(X, Y):- ground(subsetof(X, Y)), X=Y.

subsetof(SpatialVerb1, SpatialVerb2):- compound(SpatialVerb1), compound(SpatialVerb2), !,
 SpatialVerb1=..[Verb1, Arg1|_],
 SpatialVerb2=..[Verb2, Arg2|_],
 subsetof(Verb1, Verb2),
 subsetof(Arg1, Arg2).

subsetof(SpatialVerb, Verb2):- compound(SpatialVerb), safe_functor(SpatialVerb, Verb, _), !,
 subsetof(Verb, Verb2).

subsetof(Verb, SpatialVerb2):- compound(SpatialVerb2), safe_functor(SpatialVerb2, Verb2, _), !,
 subsetof(Verb, Verb2).

% proper subset - C may not be a subset of itself.
psubsetof(A, B):- A==B, !, fail.
psubsetof(A, B) :- subsetof(A, B).
psubsetof(A, C) :-
 subsetof(A, B),
 subsetof(B, C).


maybe_pause(Agent):- stdio_player(CP), (Agent==CP -> wait_for_input([user_input], _, 0) ; true).

invoke_command(Agent, Action) ==>>
 invoke_metacmd(Agent, Action),
  {overwrote_prompt(Agent)}, !.
invoke_command(Agent, Action) ==>>
  {set_last_action(Agent, Action)},
 invoke_action(Agent, Action), !.
invoke_command(Agent, Action) :-
 event_failed(Agent, unknown_comand( Action)),
 player_format(Agent, 'Failed or No Such Command: ~w~n', Action).

% --------

/*
new_do_intent( Agent):-
 get_advstate(S0),
 invoke_intents( Agent, S0, S9),
 set_advstate(S9), !.
*/
:- defn_state_setter( invoke_intents( +agent)).

invoke_intents( Agent) ==>>
 sg(declared(memories(Agent, Mem0))),
 {member( intent(Agent, []), Mem0)}, !.
invoke_intents( Agent, S0, S9) :-
 maybe_undeclare(memories(Agent, Mem0), S0, S1),
 thought_check(Agent, intent(Agent, OldToDo), Mem0), append([Action], NewToDo, OldToDo), replace_thought(Agent, intent(Agent, NewToDo), Mem0, Mem2),
 replace_declare(memories(Agent, Mem2), S1, S2),
 set_last_action(Agent, Action),
 invoke_command(Agent, Action, S2, S9).
invoke_intents( _Agent, S0, S0).



%do_intent_while(Agent, S0, S9) :-
% declared(memories(Agent, Mem0), S0),
% th ought(Agent, intent(Agent, ToDo), Mem0),
% append([Action], NewToDo, OldToDo),



% ---- apply_act( Action, S0, S9)
% where the states also contain Percepts.
% In Inform, actions work in the following order:
% game-wide preconditions
% Player preconditions
% objects-in-vicinity react_before conditions
% room before-conditions
% direct-object before-conditions
% verb
% objects-in-vicinity react_after conditions
% room after-conditions
% direct-object after-conditions
% game-wide after-conditions
% In TADS:
% "verification" methods perferm tests only

invoke_action(Agent, Action, S0, S3) :-
 quietly_must((
 maybe_undeclare(memories(Agent, Mem0), S0, S1),
 memorize_doing(Agent, Action, Mem0, Mem1),
 replace_declare(memories(Agent, Mem1), S1, S2))),
 once(show_failure(must_act( Action, S2, S3));S2=S3), !.

%memorize_doing(_Agent, Action, Mem0, Mem0):- has_depth(Action), !.
memorize_doing(Agent, Action, Mem0, Mem2):-
  copy_term(Action, ActionG),
  mw_numbervars(ActionG, 999, _),
  ( has_depth(Action)
    -> Mem0 = Mem1 ;
    (agent_clock_time_now(Agent, Timestamp, Mem0),
     memorize_prepending(Agent, Timestamp, Mem0, Mem1))),
  DOES = attempts(Agent, ActionG),
  memorize_prepending(Agent, DOES, Mem1, Mem2).




agent_clock_time_prev(Agent, timestamp(T0, OldNow), Mem0):-
 find_clock_time(Agent, T0, OldNow, Mem0), !.

agent_clock_time_now(Agent, timestamp(T1, Now), Mem0):-
  agent_clock_time_prev(Agent, timestamp(T0, _OldNow), Mem0),
  T1 is T0 + 1, clock_time(Now), !.

some_agent_clock_time(Agent, T0, OldNow, Mem):- nonvar(Mem),
  thought_check(Agent, timestamp(T0, OldNow), Mem), !.
 
find_clock_time(Agent, T0, OldNow, _UMem):-
   get_advstate(State), declared(preceptq(Agent, Mem), State),
   some_agent_clock_time(Agent, T0, OldNow, Mem).
find_clock_time(Agent, T0, OldNow, Mem0):- some_agent_clock_time(Agent, T0, OldNow, Mem0).
find_clock_time(Agent, T0, OldNow, _UMem):-
   get_advstate(State), declared(memories(Agent, Mem), State),
   some_agent_clock_time(Agent, T0, OldNow, Mem).
find_clock_time(Agent, T0, OldNow, _UMem):-
   get_advstate(State), declared(props(Agent, Mem), State),
   some_agent_clock_time(Agent, T0, OldNow, Mem).

   
has_depth(Action):- compound(Action), safe_functor(Action, _, A), arg(A, Action, E), compound(E), E=depth(_), !.

trival_act(V):- \+ callable(V), !, fail.
%trival_act(intend('sub__examine',_, _, _, _, _)).
%trival_act( intend('look', _)).
%trival_act(Action):- has_depth(Action).
trival_act(V):- \+ compound(V), !, fail.
trival_act(_):- !, fail.
trival_act( intend('wait', _)).


satisfy_each_cond(Ctxt, [], success(Ctxt)) ==>> !.
satisfy_each_cond(Context, [Cond|CondList], Out) ==>>
  dmust_tracing(satisfy_each(Context, Cond)), !,
  ((sg(member(failed(Why))) -> Out=failed(Why) ; satisfy_each_cond(Context, CondList, Out))), !.
% satisfy_each_cond(_Context, [Cond|_CondList], failed(Cond)) ==>> !.


satisfy_each(Context, List) ==>> {is_list(List)}, !,
  satisfy_each_cond(Context, List, Out), !,
  {dmust_tracing(Out\=failed(_))}.

satisfy_each(_Ctx, A \= B) ==>> {dif(A, B)}, !.

satisfy_each(Context, believe(Beliver, Cond)) ==>>
   maybe_undeclare(memories(Beliver, Memory)),
   {satisfy_each(Context, Cond, Memory, NewMemory)}, !,
   replace_declare(memories(Beliver, NewMemory)).

satisfy_each(postCond(_Action), event(Event), S0, S9) :-  must_act(Event, S0, S9).

satisfy_each(Context, (C1, C2), S0, S9) :- !,
  satisfy_each(Context, C1, S0, S1),
  satisfy_each(Context, C2, S1, S9).

satisfy_each(Context, foreach(Cond, Event), S0, S9) :- findall(Event, phrase(Cond, S0, _), TODO), satisfy_each(Context, TODO, S0, S9).
satisfy_each(_, percept_local(Where, Event)) ==>> !, queue_local_event([Event], [Where]).
satisfy_each(_, percept(Agent, Event)) ==>> !, send_1percept(Agent, Event).
satisfy_each(postCond(_Action), ~(Cond)) ==>> !, undeclare_always(Cond). % select_always//1
satisfy_each(postCond(_Action), Cond) ==>> !, declare(Cond).
satisfy_each(Context, ~(Cond)) ==>> !, (( \+ satisfy_each(Context, Cond)) ; [failed(Cond)] ).
satisfy_each(_, Cond) ==>> declared(Cond).
satisfy_each(_, Cond) ==>> [failed(Cond)].


oper_splitk(Agent, Action, Preconds, Postconds):-
  oper_db(Agent, Action, PrecondsK, PostcondsK),
  split_k(Agent, PrecondsK, Preconds),
  split_k(Agent, PostcondsK, Postconds).

split_k(_Agent, [], []) :- !.

split_k(Agent, [b(P, [V|VS])|PrecondsK], Preconds):- !,
  split_k(Agent, [b(P, V), b(P, VS)|PrecondsK], Preconds).

split_k(Agent, [~(k(P, X, Y))|PrecondsK], [believe(Agent, ~(h(P, X, Y))), ~(h(P, X, Y))|Preconds]):- !,
  split_k(Agent, PrecondsK, Preconds).
split_k(Agent, [k(P, X, Y)|PrecondsK], [believe(Agent, h(P, X, Y)), h(P, X, Y)|Preconds]):- !,
  split_k(Agent, PrecondsK, Preconds).
split_k(Agent, [~(b(P, X, Y))|PrecondsK], [believe(Agent, ~(h(P, X, Y)))|Preconds]):- !,
  split_k(Agent, PrecondsK, Preconds).
split_k(Agent, [b(P, X, Y)|PrecondsK], [believe(Agent, h(P, X, Y))|Preconds]):- !,
  split_k(Agent, PrecondsK, Preconds).
split_k(Agent, [isa(X, Y)|PrecondsK], [getprop(X, inherited(Y))|Preconds]):-
  split_k(Agent, PrecondsK, Preconds).
split_k(Agent, [in(X, Y)|PrecondsK], [h(in, X, Y)|Preconds]):-
  split_k(Agent, PrecondsK, Preconds).
split_k(Agent, [Cond|PrecondsK], [Cond|Preconds]):-
  split_k(Agent, PrecondsK, Preconds).

api_invoke( Action) :- get_advstate(S), api_invoke( Action, S, E), set_advstate(E).

api_invoke( Action) ==>> apply_act( Action).

apply_act( Action) ==>> aXiom(Action), !.
apply_act( Act, S0, S9) :- ((cmd_workarround(Act, NewAct) -> Act\==NewAct)), !, apply_act( NewAct, S0, S9).
apply_act( Action, S0, S0) :-
  notrace((dbug(general, failed_aXiom( Action)))), !, fail, \+ tracing.


must_act( Action , S0, S9) :-
  (apply_act( Action, S0, S9)) *-> ! ; fail.
must_act( Action, S0, S1) :- debugging(apply_act), !, rtrace(apply_act( Action, S0, S1)), !.
must_act( Action) ==>>
 action_doer(Action, Agent),
 send_1percept(Agent, [failure(Action, unknown_to(Agent, Action))]).


act_required_posses('lock', 'key', $agent).
act_required_posses('unlock', 'key', $agent).


act_change_opposite(f, t):-!.
act_change_opposite(t, f):-!.
act_change_opposite(F, T):- act_change_opposite_0(T, F), !.
act_change_opposite(T, F):- act_change_opposite_0(T, F), !.

act_change_opposite_0('close', 'open').
act_change_opposite_0(Auto, _):- parsed_as_simple(Auto), !, fail.
act_change_opposite_0(UnOpen, Open):- (atom(Open) -> \+ atom_concat('un', _, Open) ; atom(UnOpen)),
    atom_concat('un', Open, UnOpen).

act_change_state(Auto, _, _):- parsed_as_simple(Auto), !, fail.
act_change_state(Open, Opened, Value):- nonvar(Value), !, act_change_state(Open, Opened, Val), !, Value=Val.
act_change_state('lock', 'locked', t).
act_change_state('open', 'opened', t).
act_change_state( did('switch', on), 'powered', t).
act_change_state( did('switch', off), 'powered', f).
act_change_state( did('switch', Open), Opened, TF):- nonvar(Open), !, act_change_state(Open, Opened, TF).

act_change_state(Close, Opened, Value):-
   act_change_state_0(Close, UnOpened, Val), nonvar(Val), as_true(UnOpened, Opened, TF),
   (TF == f -> once(act_change_opposite(Val, Value)) ; Value = Val).

as_true(UnOpen, Open, f):- atom(UnOpen), var(Open), atom_concat('un', Open, UnOpen), !.
as_true( Opened, Opened, t).

act_change_state_0(Light, Lit, t):- control_changed(Light, Lit), !.
act_change_state_0(Unlock, Locked, FT):-
  act_change_opposite(Unlock, Lock),
  act_change_state(Lock, Locked, TF), act_change_opposite(TF, FT).


act_change_state_or_fallback(Open, Opened, TF):- act_change_state(Open, Opened, TF), !.
act_change_state_or_fallback(UnOpen, Opened, F):- act_change_opposite(Open, UnOpen), act_change_state(Open, Opened, T), act_change_opposite(T, F).

% act_prevented_by(Open, Opened, TF):- act_change_state(Open, Opened, TF).
act_prevented_by('open', 'locked', t).
act_prevented_by('close', 'locked', t).


event_failed(Agent, CUZ):- simplify_reason(CUZ, Msg),
  episodic_mem(Agent, event_failed(Agent, CUZ)),
  player_format(Agent, '~N~p~n', [Msg]).

:- meta_predicate maybe_when(0, 0).
maybe_when(If, Then):- If -> Then ; true.

:- meta_predicate unless_reason(*, '//', *, ?, ?).
unless_reason(_Agent, Then, _Msg) ==>> Then, !.
unless_reason(Agent, _Then, Msg) ==>> {event_failed(Agent, Msg)}, !, {fail}.

:- meta_predicate unless_reason(*, '//', *, '//', ?, ?).
unless_reason(_Agent, Unless, _Msg, Then) ==>> Unless, !, Then.
unless_reason(Agent, _Unless, Msg, _Then) ==>> {event_failed(Agent, Msg)}, !.

:- meta_predicate unless(*, '//', '//', ?, ?).
unless(_Agent, Required, Then) ==>> Required, !, Then.
unless(Agent, Required, _Then) ==>> {simplify_reason(Required, CUZ), event_failed(Agent, cant( cuz(\+ CUZ)))}, !.

:- meta_predicate required_reason(*, 0).
required_reason(_Agent, Required):- Required, !.
required_reason(Agent, Required):- simplify_reason(Required, CUZ), event_failed(Agent, cant( cuz(CUZ))), !, fail.

simplify_reason(_:Required, CUZ):- !, simplify_reason(Required, CUZ).
simplify_reason(Required, CUZ):- simplify_dbug(Required, CUZ).

reverse_dir(north, south, _).
reverse_dir(reverse(ExitName), ExitName, _) :- nonvar(ExitName), !.
reverse_dir(Dir, RDir, S0):-
 h(exit(Dir), Here, There, S0),
 h(exit(RDir), There, Here, S0), !.
reverse_dir(Dir, RDir, S0):-
 h(Dir, Here, There, S0),
 h(RDir, There, Here, S0), !.
reverse_dir(Dir, reverse(Dir), _).


/*
creates:

add_agent_intent( Agent, Action):-
 get_advstate(S0),
 add_agent_intent( Agent, Action, S0, S9),
 get_advstate(S9).
*/
:- defn_state_setter(add_agent_intent( agent, action)).

add_agent_intent( Agent, Action, S0, S9) :-
  maybe_undeclare(memories(Agent, Mem0), S0, S1),
  add_intent( Agent, Action, Mem0, Mem1),
  replace_declare(memories(Agent, Mem1), S1, S9).

add_agent_goal(Agent, Action, S0, S9) :-
  maybe_undeclare(memories(Agent, Mem0), S0, S1),
  add_goal(Agent, Action, Mem0, Mem1),
  replace_declare(memories(Agent, Mem1), S1, S9).

add_intent_look(Agent) ==>>
  h(inside, Agent, _Somewhere),
  add_agent_intent( Agent, intend('look', Agent)).


uses_default_doer(Action):- safe_functor(Action, Verb, _), verbatum_anon(Verb).
uses_default_doer(Action):- \+ compound(Action).
:- defn_state_none(action_doer(action, -agent)).
action_doer(Action, Agent):- uses_default_doer(Action), !, must_mw(mu_current_agent(Agent)), !.
action_doer(Action, Agent):- arg(_, Action, Agent), nonvar(Agent), is_x_instance(Agent), !.
action_doer(Action, Agent):- mu_current_agent(Agent), !, must_mw(Action == Agent).
action_doer(Action, Agent):- trace, throw(missing(action_doer(Action, Agent))).

action_verb_agent_thing(Action, Verb, Agent, Thing):-
  action_verb_agent_args(Action, Verb, Agent, Args),
  (Args=[[Thing]]->true;Args=[Thing]->true;Thing=_), !.

action_verb_agent_args(Action, Verb, Agent, Args):-
  univ_safe(Action, [intend, Verb, Agent|Args]), nonvar(Verb), !,
  univ_safe(VAction, [Verb, Agent|Args]),
  action_verb_agent_args(VAction, Verb, Agent, Args).

action_verb_agent_args(Action, Verb, Agent, Args):-
  univ_safe(Action, [Verb, Agent|Args]),
  act_change_state(Verb, _, _), !.

action_verb_agent_args(Action, Verb, Agent, Args):-
  show_failure(get_functor_types(action, Action, Types)),
  univ_safe(Action, [Verb|Rest]), !,
  ((Types = [agent|_]) -> Rest = [Agent|Args] ; Args=Rest).
%action_verb_agent_args(Action, Verb, Agent, Args):-
% notrace((compound(Action), Action=..[Verb, Agent|Args], \+ verbatum_anon(Verb))), !.
action_verb_agent_args(Action, Verb, Agent, Args):-
  univ_safe(Action, [Verb, Agent|Args]),
  \+ verbatum_anon(Verb),
  Args\==[].



/*
disgorge(Doer, How, Container, At, Here, Vicinity, Msg) :-
  findall(Inner, h(child, Inner, Container), Contents),
  dbug(general, '~p contained ~p~n', [Container, Contents]),
  moveto(Doer, How, Contents, At, Here, Vicinity, Msg).
disgorge(Doer, How, _Container, _At, _Here, _Vicinity, _Msg).
*/
disgorge(Doer, How, Container, Prep, Here, Vicinity, Msg) ==>>
  findall(Inner, h(child, Inner, Container), Contents),
   {dbug(general, '~p contained ~p~n', [Container, Contents])},
  moveto(Doer, How, Contents, Prep, Here, Vicinity, Msg).

:- defn_state_setter(moveto(agent, verb, listof(inst), domrel, dest, list(dest), msg)).
moveto(Doer, Verb, List, At, Dest, Vicinity, Msg) ==>> {is_list(List)}, !,
 apply_mapl_rest_state(moveto(Doer, Verb), List, [At, Dest, Vicinity, Msg]).
moveto(Doer, Verb, Object, At, Dest, Vicinity, Msg) ==>>
  undeclare(h(_, Object, From)),
  declare(h(At, Object, Dest)),
  queue_local_event([moved(Doer, Verb, Object, From, At, Dest), Msg], Vicinity).


event_props( did_throw(Agent, Thing, _Target, Prep, Here, Vicinity),
 [getprop(Thing, breaks_into(NewBrokenType)),
 dbug(general, 'object ~p is breaks_into~n', [Thing]),
 undeclare(h(_, Thing, _)),
 declare(h(Prep, NewBrokenType, Here)),
 queue_local_event([transformed(Thing, NewBrokenType)], Vicinity),
 disgorge(Agent, do_throw, Thing, Prep, Here, Vicinity, 'Something falls out.')]).


setloc_silent(Prep, Object, Dest) ==>>
 undeclare(h(_, Object, _)),
 declare(h(Prep, Object, Dest)).

state_value(Opened=TF, Opened, TF):-!.
state_value(NamedValue, Named, Value):-
  univ_safe(NamedValue, NamedValueL),
  append(NamedL, [Value], NamedValueL),
  univ_safe(Named, NamedL).

change_state(Agent, Action, Thing, OpenedTF, S0, S):-
 action_verb_agent_thing(Action, Open, _, _),
 % must_mw1
 ((
 maybe_when(psubsetof(Open, touch),
   required_reason(Agent, will_need_touch(Agent, Thing, S0, _))),

 %getprop(Thing, can_be(open, S0),
 %\+ getprop(Thing, =(open, t), S0),

 required_reason(Agent, \+ getprop(Thing, can_be(Open, f), S0)),

 ignore(dshow_failure(getprop(Thing, can_be(Open, t), S0))),

 forall(act_prevented_by(Open, Locked, Prevented),
   required_reason(Agent, \+ getprop(Thing, =(Locked, Prevented), S0))),

 %delprop(Thing, =(Open, f), S0, S1),
 %setprop(Thing, =(Open, t), S0, S1),

  open_traverse(Agent, Here, S0),

 apply_forall(
  (getprop(Thing, effect(Open, Term0), S0),
  adv_subst(equivalent, $self, Thing, Term0, Term1),
  adv_subst(equivalent, $agent, Agent, Term1, Term2),
  adv_subst(equivalent, $here, Here, Term2, Term)),
  call(Term), S0, S1),

 setprop(Thing, OpenedTF, S1, S2))),

 queue_local_event([msg([Agent, ensures, Thing, is, OpenedTF])], [Here, Thing], S2, S), !.


