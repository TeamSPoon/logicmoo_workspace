% =========================================
% Goal/Plan translating
% =========================================
:- module(lps_pddl_convert,[%load_e/1, needs_proccess/3,process_ec/2,fix_time_args/3,fix_goal/3, 
  %brk_on_bind/1,assert_axiom_2/2,
   assert1_lps_pddl/1,
   test_logicmoo_lps_pddl_reader/0,
   
   test_lps_pddl_ereader/0,
   test_logicmoo_pddl_reader_2/0,
   test_logicmoo_lps_pddl_reader/2,test_logicmoo_lps_pddl_reader/1]).
                     

:- use_module(library(logicmoo_common)).

/*export_transparent(P):-
  export(P),
  module_transparent(P).
*/
:- use_module(library(logicmoo_lps)).
:- use_module(library(ec_planner/ec_lps_convert)).
:- use_module(library(wam_cl/sreader)).
:- use_module(library(hyhtn_pddl/rsasak_pddl_parser)).
% system:pddl_current_domain(X):- wdmsg(pddl_current_domain(X)),fail.
%:- user:use_module(library('pddl_planner/pddl_planner_dmiles')).
%:- use_module(library(pddl_planner/pddl_reader)).

:- use_module(library(lps_corner)).

:- set_prolog_flag(lps_translation_only_HIDE,false).
:- set_prolog_flag(lps_translation_only,false).


assert1_lps_pddl(Stuff):- 
   print_tree_cmt('Translating',green,Stuff),
   assert_pddl([],Stuff).
   

:- export_transparent(with_lps_pddl_operators2/2).
with_lps_pddl_operators2(M,Goal):- 
   setup_call_cleanup(push_operators(M:[op(900, fy, M:not),  op(1200, xfx, M:then), op(1185, fx, M:if), op(1190, xfx, M:if), op(1100, xfy, M:else), op(1050, xfx, M:terminates), op(1050, xfx, M:initiates), op(1050, xfx, M:updates), op(1050, fx, M:observe), op(1050, fx, M:false), op(1050, fx, M:initially), op(1050, fx, M:fluents), op(1050, fx, M:events), op(1050, fx, M:prolog_events), op(1050, fx, M:actions), op(1050, fx, M:unserializable), op(999, fx, M:update), op(999, fx, M:initiate), op(999, fx, M:terminate), op(997, xfx, M:in), op(995, xfx, M:at), op(995, xfx, M:during), op(995, xfx, M:from), op(994, xfx, M:to), op(1050, xfy, M: ::), op(1200, xfx, M:(<-)), op(1050, fx, M:(<-)), op(700, xfx, M: <=)],Undo),
     M:call(Goal),pop_operators(Undo)).

:- export_transparent(with_lps_pddl_operators/1).
with_lps_pddl_operators(MGoal):- 
  strip_module(MGoal,M,Goal),
  with_lps_pddl_operators2(user,lps_pddl_convert:with_lps_pddl_operators2(M,M:Goal)).


print_lps_pddl_syntax(Color,Lps):- 
 with_lps_pddl_operators2(user,
  lps_pddl_convert:with_lps_pddl_operators2(pretty_clauses,pretty_clauses:clause_to_string(Lps,S))),
    real_ansi_format(hfg(Color), '~N~s.~N', [S]),!.


include_e_lps_pddl_file_now(Type,MFile):- strip_module(MFile,M,File), include_e_lps_pddl_file_now(Type,M,File).
include_e_lps_pddl_file_now(Type,M,File):- absolute_file_name(File,AbsFile),File\==AbsFile,exists_file(AbsFile), !,include_e_lps_pddl_file_now(Type,M,AbsFile).

%include_e_lps_pddl_file_now(_Type,_Ctx,File):- 
%   with_lisp_translation(File,pprint_ecp(yellow)),!.
include_e_lps_pddl_file_now(_Type,_Ctx,File):- 
   with_lisp_translation(File,assert1_lps_pddl),!.


load_e_lps_pddl_file(Type,File):- update_changed_files,  
  retractall(etmp:pddl_option(load(_), _)), include_e_lps_pddl_file(Type,File).
%load_e_lps_pddl_file(Type,File):- retractall(etmp:pddl_option(load(_), _)), include_e_lps_pddl_file(Type,File).


include_e_lps_pddl_file(Type,File):- is_list(File), !, maplist(include_e_lps_pddl_file(Type),File).
include_e_lps_pddl_file(Type,File):- wdmsg(include_e_lps_pddl_file(Type,File)),fail.
include_e_lps_pddl_file(Type,File):- needs_resolve_local_files(File,Resolved),!,include_e_lps_pddl_file(Type,Resolved).
include_e_lps_pddl_file(Type,File):- absolute_file_name(File,DB), exists_file(DB),!, 
  update_changed_files, was_s_l(File,1),  
  strip_module(_,M,_), prolog_statistics:time(M:include_e_lps_pddl_file_now(Type,File)),!.
include_e_lps_pddl_file(Type,File):- throw(with_abs_paths(include_e_lps_pddl_file(Type),File)).


test_logicmoo_lps_pddl_reader(File):- test_logicmoo_lps_pddl_reader(lps, File).
test_logicmoo_lps_pddl_reader(Proc1,File):- load_e_lps_pddl_file(Proc1,File).

solve_files_w_lps(DomainFile, ProblemFile):- 
  test_logicmoo_lps_pddl_reader(ProblemFile),!,
%  parseProblem(ProblemFile,PStuff),%break,
  %pprint_ecp(blue,PStuff),!, break,
  %parseDomain(DomainFile,Stuff), pprint_ecp(yellow,Stuff),!, % break,
  test_logicmoo_lps_pddl_reader(DomainFile),
  !.

test_logicmoo_lps_pddl_reader:-  
 test_logicmoo_lps_pddl_reader(pddl('orig_pddl_parser/test/blocks/domain-blocks.pddl')),
 test_logicmoo_lps_pddl_reader(pddf('uw-yale-pddl/domains/transplan/domain.pddl')).

:- add_history((cls, test_logicmoo_lps_pddl_reader)).

test_logicmoo_lps_pddl_reader1:- 
   test_logicmoo_lps_pddl_reader(pddl('*/*.pddl')).

test_logicmoo_pddl_reader_2:- 
 test_logicmoo_lps_pddl_reader(pddl('benchmarks/*/*/*/*.pddl')).

:- ensure_loaded(library(logicmoo/util_structs)).
:- ensure_loaded(library(statistics)).
%:- ensure_loaded(library(logicmoo_util_bb_env)).

test_lps_pddl_ereader:- !,
   planner_solve_files(pddl('orig_pddl_parser/test/blocks/domain-blocks.pddl'), 
      pddl('orig_pddl_parser/test/blocks/blocks-03-0.pddl')),!.
    


compound_name_arguments_maybe_zero(F,F,[]):- \+ compound(F), !.
compound_name_arguments_maybe_zero(LpsM,F,ArgsO):- (compound(LpsM);atom(F)),!,compound_name_arguments(LpsM,F,ArgsO),!.
%compound_name_arguments_maybe_zero(LpsM,F,ArgsO):- dumpST,break.


already_lps_pddl(Form):- var(Form),!,throw(var_already_lps_pddl(Form)).
already_lps_pddl(:- _):-!.
already_lps_pddl(option(_,_)):-!.
already_lps_pddl(false(_)):-!.
already_lps_pddl(mpred_prop(_,_)):-!.
already_lps_pddl(sort(_)):-!.
already_lps_pddl(subsort(_,_)):-!.

into_term(I,O):- must_or_rtrace(into_term_0(I,O)),!.
into_term_0(Decl,t(Decl)):- \+ compound(Decl),!.
into_term_0(Compound,Res):- \+ is_list(Compound),!,compound_name_arguments_maybe_zero(Compound,F,Args),!,into_term_0([F|Args],Res).
into_term_0([and,X],Res):- !, into_term_0(X,Res).
into_term_0([and,X|L],and(Res,LRes)):- into_term_0(X,Res), into_term_0(L,[and|LRes]).
into_term_0([or,X],Res):- !, into_term_0(X,Res).
into_term_0([or,X|L],or(Res,LRes)):- into_term_0(X,Res), into_term_0(L,[or|LRes]).
into_term_0([not,X],not(Res)):- !, into_term_0(X,Res).
into_term_0([A|List],Res):- atom(A),is_list(List),!, Res =.. [A|List].
%into_term_0([A|List],Res):- compound(A),is_list(List),!,append_termlist(A,List,Res),!.
into_term_0(List,Res):- Res =..[t|List].
% into_term_0(Decl,t(Decl)).



into_plus_minus(Conds,Pos,Neg):- 
   into_term(Conds,PostC),
   into_enables(PostC,Pos),
   into_disables(PostC,Neg).
  


into_enables([and|Args],Enables):- !, maplist(into_enables,Args,EnablesL),append(EnablesL,Enables).
into_enables(Effect,Enables):- compound(Effect), compound_name_arguments_maybe_zero(Effect,and,Args),maplist(into_enables,Args,EnablesL),append(EnablesL,Enables).
into_enables(not(_),[]).
into_enables(E,[E]).

into_disables(not(E),Es):- into_enables(E,Es).
into_disables([not,E],Es):- into_enables(E,Es).
into_disables([and|Args],Enables):- !, maplist(into_disables,Args,EnablesL),append(EnablesL,Enables).
into_disables(Effect,Enables):- compound(Effect), compound_name_arguments_maybe_zero(Effect,and,Args),maplist(into_disables,Args,EnablesL),append(EnablesL,Enables).
into_disables(_,[]).




% assert1_lps([constant|Ctx],C):- compound(C),
and_to_comma(Rule0,Rule):- into_term(Rule0,Rule1),and_to_comma_0(Rule1,Rule).

and_to_comma_0(Rule0,Rule):- \+ compound(Rule0), !, Rule=Rule0.
and_to_comma_0(and(A,B),(AA,BB)):- !, and_to_comma_0(A,AA),and_to_comma_0(B,BB).
and_to_comma_0(and(A),AA):- !,and_to_comma_0(A,AA).
and_to_comma_0(ANDA,(AA,BB)):- compound(ANDA), ANDA=..[and,A|As],!,compound_name_arguments(B,and,As),and_to_comma_0(A,AA),and_to_comma_0(B,BB).
and_to_comma_0(A,AA):- 
   compound_name_arguments(A,F,As),
   maplist(and_to_comma_0,As,AAs),
   compound_name_arguments(AA,F,AAs).


%assert_pddl(Ctx,_,include(F)):- include_e_lps_pddl_file_now(Type,Ctx:F).
%assert_pddl(Ctx,_,load(F)):- include_e_lps_pddl_file_now(Type,Ctx:F). 
%assert_pddl(Ctx,_,include(F)):- !, with_e_file(assert_pddl(Ctx),current_output, [pddl(F)]). 
%assert_pddl(Ctx,_,load(X)):- nop(assert_pddl(Ctx,include(X))),!.

%assert_pddl(Ctx,Form):- 
assert_pddl(Ctx,Form):- \+ compound_gt(Form,0),!,assert1_lps(Ctx,Form).
assert_pddl(Ctx,t(Type,Inst)):- atom(Type), M=..[Type,Inst],!,assert_pddl(Ctx,M),!.
%assert_pddl(Ctx,Form):- already_lps_pddl(Form),!,assert1_lps(Ctx,Form).
assert_pddl(Ctx,Form):- \+ is_list(Form),!,assert1_lps(Ctx,Form).

assert_pddl(Ctx,Form):- 
  Form = [ define, Decl|Rest],
  into_term(Decl,Named),
  assert_pddl([Named|Ctx],Rest),!.


assert_pddl(Ctx,Form):- 
  Form = [ action, Decl|Rest],
  into_term(Decl,Named),
  assert_pddl([action|Ctx],[Named|Rest]),!.
                        
assert_pddl(Ctx,[[KW,Data]|Rest]):-
  kw_directive(KW,NewType),
  kw_soon(Rest),
  assert_pddl([NewType|Ctx],Data),
  assert_pddl(Ctx,Rest),!.

assert_pddl(Ctx,[[KW|Data]|Rest]):- Data\==[],
  kw_directive(KW,NewType),
  kw_soon(Rest),
  assert_pddl([NewType|Ctx],Data),
  assert_pddl(Ctx,Rest),!.
/*
assert_pddl(Ctx,[KW,Data|Rest]):- Data\==[],
  kw_directive(KW,NewType),
  kw_soon(Rest),
  assert_pddl([NewType|Ctx],Data),
  assert_pddl(Ctx,Rest),!.
*/

assert_pddl([init|Ctx],Data):-  map_pddl_list(assert_pddl([s(initially)|Ctx]),Data).

assert_pddl(Ctx,Data):- \+ is_list(Data),!,assert_pddl(Ctx,[Data]).
assert_pddl([AtomS|Ctx],Data):- atom(AtomS),atom_concat(Atom,'s',AtomS),!, map_pddl_list(assert_pddl([Atom|Ctx]),Data).
assert_pddl([s(Pred)|Ctx],SData):- sterm2pterm(SData,Data), !,assert1_lps([Pred|Ctx],Data).
assert_pddl([One,Ctx],SData):- atom(One),!, sterm22pterm(SData,Data),!,assert1_lps([One,Ctx],Data).

assert_pddl(Ctx,Form):- wdmsg(assert_pddl(Ctx,Form)),fail.
assert_pddl(Ctx,Form):- assert1_lps(Ctx,Form).


assert_pddl_pairs(Ctx,[N,SV|Form]):- sterm2pterm(SV,V), assert1_lps([N|Ctx],V),assert_pddl_pairs(Ctx,Form).
assert_pddl_pairs(_,[]).

 
sterm22pterm(SData,Data):- SData=Data,!.
sterm22pterm(SData,Data):- sterm2pterm(SData,SSData),sterm2pterm(SSData,Data).

kw_soon(Rest):- 
  (Rest ==[] ; 
  (Rest = [KW2|_],kw_directive(KW2,_)); 
  (Rest = [[KW2|_]|_],kw_directive(KW2,_))).

kw_directive(KW,NewType):- atom(KW), atom_concat(':',Stuff,KW), downcase_atom(Stuff,NewType),!.


pddl_type_of(typed(T,_),T).
pddl_type_of(G,F):- compound(G),compound_name_arguments_maybe_zero(G,F,[_]),!.
pddl_type_of(F,F).

as_isa_list([],[]).
as_isa_list([typed(T,V)|L],[isa(V,T)|LL]):- as_isa_list(L,LL).
as_isa_list([G|L],[isa(V,T)|LL]):- compound(G), compound_name_arguments_maybe_zero(G,T,[V]), as_isa_list(L,LL).
as_isa_list([_|L],LL):- as_isa_list(L,LL).

pddl_value_of(typed(_,V),V).
pddl_value_of(G,F):- compound(G),compound_name_arguments_maybe_zero(G,_,[F]),!.
pddl_value_of(F,F).

preplace_conds(PreConds,Conds):- sterm2pterm(PreConds,Conds).

into_kwu(N,KW):- freeze(KW,same_symbol(KW,N)).
select_within(N,V,Form,NForm):- nonvar(N), into_kwu(N,KW),!, select_within(KW,V,Form,NForm).
select_within(N,V,Form,NForm):- select([N,V],Form,NForm),!.
select_within(N,V,Form,NForm):- select([N|V],Form,NForm),!.
select_within(N,V,Form,NForm):- append(Left,[N,V|Right],Form),append(Left,Right,NForm),!.
select_within(N,V,Form,NForm):- append(NForm,[N|V],Form),!.

pddl_param_type(Why,_):-var(Why),!,fail.
pddl_param_type(':vars',typed).
pddl_param_type(':parameters',typed).
pddl_param_type(Why,WhyO):-nonvar(Why),Why=WhyO.

maybe_convert(N,V0,V,Else):- member(Why,[N,Else,V0]),pddl_param_type(Why,typed),!,into_typed_params(V0,V),!.
maybe_convert(N,V0,V,Else):- member(Why,[N,Else,V0]),pddl_param_type(Why,['and']),!,preplace_conds(V0,V),!.
maybe_convert(_,V,V,_):-!.

unkw_s(N,KW):- atom(N),atom_concat(':',M,N), !, unkw_s(M,KW).
unkw_s(N,KW):- downcase_atom(N,KW).

get_1pair_value( N,V,Form,NForm,Else, zzz(KW,V)):- unkw_s(N,KW),select_within(N,V0,Form,NForm),maybe_convert(N,V0,V,Else),!.
get_1pair_value( N,V,Form, Form,Else, zzz(KW,V)):- unkw_s(N,KW), V = Else,!.

get_pair_values([],Form,Form):-!.
get_pair_values(ndv(N,E,V),Form,FormOut):-get_1pair_value(N,V,Form, FormOut, E, _ZZZ),!.
get_pair_values([Op|Rest],Form,FormOut):-
  get_pair_values(Op,Form,FormM),
  get_pair_values(Rest,FormM,FormOut).

assert1_lps(Lps):- assert1_lps(lps_test_mod,Lps).

never:- set_prolog_flag(debugger_write_options,
  [quoted(true), max_depth(100), spacing(next_argument)]).
% assert1_lps([_Ctx],Form):- Form ==[], 

assert1_lps(Ctx,Form):- pprint_ecp_cmt(white,assert1_lps(Ctx,Form)),fail.

assert1_lps([action|Ctx],[Name|Form]):-
 must_or_rtrace((get_pair_values([
     ndv(':name',Name,NameF),
     ndv(':vars',[],Vars),
     ndv(':only-in-expansions',nil,_OiEs),
     ndv(':parameters',[],Params),
     ndv(':duration',1,Dur),
     ndv(':precondition',['and'],Pre),
     ndv(':effect',['and'],Effect)],Form,Form0),
 % assert1_lps([t,act|Ctx],),
   maplist(pddl_value_of,Params,VParams),
   as_isa_list(Params,PreConds0),
   as_isa_list(Vars,PreConds1),
   append([[and],PreConds0,PreConds1],Types0),
   into_term(Types0,Types1),and_to_comma(Types1,Types),
   must(into_plus_minus(Pre,PrePos,PreNeg)),
   into_plus_minus(Effect,Enables,Disables),  
   compound_name_arguments_maybe_zero(Action,NameF,VParams),
   Rule0 = if(initiates(Action, at(Effect, T2)), at(T1, (Pre, Types, T2>T1))),
   and_to_comma(Rule0,Rule),
   (PreNeg\==[] -> assert1_lps(Ctx, false((PreNeg , Action))) ; true),
   (PrePos\==[] -> assert1_lps(Ctx, false((not(PrePos) , Action))) ; true),
   assert1_lps(Rule),
   RES = action(Action,[types=Types,requires=PrePos,cant_be=PreNeg,initiates=Enables,terminates=Disables, dir=Dur]),
   assert1_lps([RES|Ctx],[]),
   assert1_lps([Rule|Ctx],[]),
   assert_pddl_pairs(Ctx,Form0))).

assert1_lps([predicate|Ctx],[Name|Params]):- 
  must(atom(Name)),
  must_or_rtrace((
    into_typed_params(Params,RParams),
    maplist(pddl_type_of,RParams,TParams),!,
    compound_name_arguments_maybe_zero(Lps,Name,TParams),
  assert1_lps([':predicate'|Ctx],Lps))).

assert1_lps([domain(_)],[]):- !.

assert1_lps([axiom|Ctx],Form):-     
  get_1pair_value(':vars',Value1,Form,Form0,[]),
  get_1pair_value(':context',Value2,Form0,Form1,['and']),
  get_1pair_value(':implies',Value3,Form1,Form2,'$error'),
  assert1_lps([implication(Value1,Value2,Value3)|Ctx],[]),
  assert_pddl_pairs([implication|Ctx],Form2).

 

assert1_lps([KW,action(N,RParams)|Ctx],PreConds):- kw_directive(KW,Directive),
   maplist(pddl_value_of,RParams,VParams),
   assert1_lps([action_types(N,TParams)|Ctx],[]),
   maplist(pddl_type_of,RParams,TParams),
   preplace_conds(PreConds,Conds),
   assert1_lps([Directive,action(N,VParams)|Ctx],Conds).
  
assert1_lps(Ctx,Form):- Ctx=[Pred|Rest],atom(Pred),is_list(Rest),NewForm=..Ctx, append_term_pddl(NewForm,Form,Data),assert_prolog(Data).
assert1_lps(Ctx,Form):- Ctx=[NewForm|Rest],is_list(Rest),append_termlist(NewForm,Rest,RData),append_term_pddl(RData,Form,Data),assert_prolog(Data).
assert1_lps(Ctx,Form):- assert_prolog(ctx(Ctx,Form)),!.

into_typed_params([], []):-!.
into_typed_params([Item, -, Type|List], [H|T]) :-  H=..[typed,Type,Item], into_typed_params(List, T).
into_typed_params([Item|List], [H|T]) :- sterm2pterm(Item, H1),!, H =..[typed,any,H1], into_typed_params(List, T).

map_pddl_list(_Pred,[]).
map_pddl_list(Pred1,[Item,'-',Type|List]):- Item1=..[typed,Type,Item], !, 
  map_pddl_list(Pred1,[Item1|List]).
map_pddl_list(Pred1,[[Item,'-',Type]|List]):- Item1=..[typed,Type,Item], !, 
  map_pddl_list(Pred1,[Item1|List]).
map_pddl_list(Pred1,[Item1|List]):- call(Pred1,Item1),map_pddl_list(Pred1,List).



append_term_pddl(X,Y,Z):- compound_gt(X,0),X=..[KW|ARGS],kw_directive(KW,NewType),X2=..[NewType|ARGS],!,append_term_pddl(X2,Y,Z).
append_term_pddl(X,Y,Z):- 
  append_term(X,Y,Z).

assert_prolog(Lps0):- 
   locally(t_l:sreader_options(logicmoo_read_kif,true),to_untyped(Lps0,Lps)),
   assert_prolog_0(Lps).

assert_prolog_0(Lps):- 
    pprint_ecp_cmt(cyan,(Lps)),fail.

assert_prolog_0(Lps):- 
  lps_xform(Lps,Prolog),!,
  must_or_rtrace((Lps\==Prolog->(ignore(( /*(Form\==Prolog,Lps==Prolog)-> */
    print_lps_pddl_syntax(yellow,Lps),
     (pprint_ecp(yellow,Lps)))),
    pprint_ecp_cmt(cyan,Prolog),pprint_ecp_cmt(white,"% ================================="))
   ;assert1_lps_pddl_try_harder(Lps))),!.

lps_xform(Lps,Prolog):- 
 Ctx = db,
 locally(current_prolog_flag(lps_translation_only_HIDE,true),
   locally(t_l:is_lps_program_module(Ctx),
    must_or_rtrace(lps_term_expander:lps_f_term_expansion_now(Ctx,Lps,Prolog)))),!,
  wdmsg(Prolog),!.

:- use_module(library(lps_syntax)).



% [waiter,agent,food,time]
% HoldsAt(BeWaiter1(waiter),time) ->
% Initiates(Order(agent,waiter,food),
%           BeWaiter2(waiter),
%           time).


pddl_to_lps(_Top, X, X):- \+ compound(X),!.
pddl_to_lps(_Top, X, X):- functor(X,_,1), arg(1,X,Var), is_ftVar(Var),!.
pddl_to_lps(_Top,at(X,Y),loc_at(X,Y)).
pddl_to_lps(_Top,metreqs(X),X).
pddl_to_lps(_Top,'->'(at(F1,T1),initiates(E,F2,T2)),Becomes):- T1==T2,  
   Becomes = (F1->initiates(E,F2)).
pddl_to_lps(_Top,'->'(at(F1,T1),terminates(E,F2,T2)),Becomes):- T1==T2,  
  Becomes = (F1->terminates(E,F2)).
pddl_to_lps(_Top,'->'(holds_at(F1,T1),initiates(E,F2,T2)),Becomes):- T1==T2,  
   Becomes = (F1->initiates(E,F2)).
pddl_to_lps(_Top,'->'(holds_at(F1,T1),terminates(E,F2,T2)),Becomes):- T1==T2,  
  Becomes = (F1->terminates(E,F2)).

pddl_to_lps(Top,neg(X),Rest):- pddl_to_lps(Top,not(X),Rest).
pddl_to_lps(_Top,holds_at(Fluent, Time),initially(Fluent)):- Time==start, !.
pddl_to_lps(_Top,holds_at(Fluent, Time),initially(Fluent)):- Time==0, !.
%pddl_to_lps(_Top,holds_at(Fluent, Time),at(Fluent, Time)):- !.
pddl_to_lps([],happens_at(Event,Time),(observe Event at Time)):- !.
pddl_to_lps(_Top,happens(Event,Time),(Event at Time)):- !.
% observe(from(muestra_del_general('+86-555000001'),to(2,3)))
pddl_to_lps(  [],initiates_at(Event,Fluent,Time),initiates(Event,Fluent)):- is_ftVar(Time), !.
pddl_to_lps(  [],terminates_at(Event,Fluent,Time),terminates(Event,Fluent)):- is_ftVar(Time), !.

pddl_to_lps(_Top,initiates_at(Event,Fluent,Time),(Event initiates Fluent at Time)):- !.
pddl_to_lps(_Top,terminates_at(Event,Fluent,Time),(Event terminates Fluent at Time)):- !.

pddl_to_lps(_Top, not(exists(_,X)), not(X)):-!.
%pddl_to_lps(_Top, not(initially(X)),(initially not X)):-!.
%pddl_to_lps(_Top, not(holds_at(X,T)),holds_at(not(X),T)).

pddl_to_lps(_Top, holds_at(Fluent, From, To),holds(Fluent, From, To)):- !.



%pddl_to_lps(_Top,happensAt(Event,Time),at(observe(Event),Time)):- !.
pddl_to_lps(_Top,Form,LpsO):- Form=..[EFP,X], argtype_pred(EFP,_), protify(EFP,X,Lps),!,flatten([Lps],LpsO).
pddl_to_lps(_Top,X=Y,Lps):- callable(X),append_term_pddl(X,Y,Lps).
pddl_to_lps(Top,','(X1,X2),(Lps1,Lps2)):- pddl_to_lps(Top,X1,Lps1),pddl_to_lps(Top,X2,Lps2).
pddl_to_lps(Top,'<->'(X1,X2),[Lps1,Lps2]):- simply_atomic_or_conj(X1),simply_atomic_or_conj(X2), pddl_to_lps(Top,'->'(X1,X2),Lps1),pddl_to_lps(Top,'->'(X2,X1),Lps2).
pddl_to_lps(_Top,'->'(X1,X2),(X2 if X1)):- simply_atomic_or_conj(X1),simply_atomic_or_conj(X2),!.
pddl_to_lps(_Top,X1,X1):- simply_atomic(X1),!.
pddl_to_lps(_Top,X1,false(Lps)):- \+ (X1 = false(_)), into_false_conj(X1,Lps),Lps\=not(_),!.
pddl_to_lps(_Top,X,X):-!.

into_false_conj(X1,Lps):- \+ (X1 = false(_)), into_pnf_conj(X1,Lps) -> Lps\=not(_),simply_atomic_or_conj(Lps).
into_pnf_conj(X1,Lps):- pnf(X1,X2),nnf(X2,X3),conjuncts_to_list(X3,X3L),list_to_conjuncts(X3L,X4), Lps = X4.

removes_at(F,_):- sent_op_f(F),!,fail.
removes_at(F,F1):- atom_concat(F1,'_at',F),!.
%removes_at(F,F1):- F=F1.
remove_time_arg(_Time,Holds,Holds):- \+ compound_gt(Holds,0),!.
remove_time_arg(Time,Holds,HoldsMT):- \+ sub_var(Time,Holds),!,Holds=HoldsMT.
remove_time_arg(Time,not(Holds),not(HoldsMT)):-!, remove_time_arg(Time,Holds,HoldsMT).
remove_time_arg(Time,happens_at(Holds,T1),Holds):- T1==Time.
remove_time_arg(Time,holds_at(Holds,T1),Holds):- T1==Time.
remove_time_arg(Time,at(Holds,T1),Holds):- T1==Time.
remove_time_arg(_Time,Holds,Holds):- \+ compound_gt(Holds,1),!.
remove_time_arg(Time,Holds,HoldsMT):- Holds=..[F|Args],append(Left,[T1],Args),T1==Time,removes_at(F,F1),HoldsMT=..[F1|Left],!.
remove_time_arg(Time,Holds,HoldsMT):- Holds=..[F|Args],maplist(remove_time_arg(Time),Args,Left),HoldsMT=..[F|Left],!.

simply_atomic_or_conj(X1):- var(X1),!,fail.
simply_atomic_or_conj((X1,X2)):- !, simply_atomic_or_conj(X1),simply_atomic_or_conj(X2).
simply_atomic_or_conj(X1):- simply_atomic(X1).

simply_atomic(X1):- var(X1),!,fail.
simply_atomic(X1):- \+ compound_gt(X1,0),!.
simply_atomic(not(X1)):-!, simply_atomic(X1).
simply_atomic(at(X1,_)):-!, simply_atomic(X1).
simply_atomic((_;_)):- !, fail.
simply_atomic(X1):- compound_name_arguments_maybe_zero(X1,F,Args), simply_atomic_f(F), maplist(simply_atomic_arg,Args).
simply_atomic_f(F):- \+ sent_op_f(F).

sent_op_f(F):- upcase_atom(F,FU),FU=F.

simply_atomic_arg(A):- var(A);simply_atomic(A). 

assert1_lps_pddl_try_harder_now((X2 if X1),(if X1 then X2)):- simply_atomic_or_conj(X1), simply_atomic_or_conj(X2).
assert1_lps_pddl_try_harder(Prolog):- assert1_lps_pddl_try_harder_now(Prolog,Again),
  lps_xform(lps_test_mod,Again,PrologAgain),Again\==PrologAgain,!, 
   print_lps_pddl_syntax(yellow,Again),
   pprint_ecp_cmt(cyan,PrologAgain),
   pprint_ecp_cmt(white,"% ================================="),
   !.
assert1_lps_pddl_try_harder(Prolog):- pprint_ecp(red,Prolog).

argtype_pred(event,events).
argtype_pred(fluent,fluents).
argtype_pred(action,actions).
argtype_pred(predicate,predicates).
argtype_pred(Action,Actions):- arg_info(domain,Action,arginfo),atom_concat(Action,"s",Actions).

protify(both,Form,[Lps1,Lps2]):- protify(events,Form,Lps1),protify(action,Form,Lps2).
protify(Type,Form,Lps):- is_list(Form),!,maplist(protify(Type),Form,Lps).
protify(Type,Form,Lps):- argtype_pred(Type,LPSType), \+ callable(Form),!,Lps=..[LPSType,[Form]].
protify(Type,Form,Lps):- argtype_pred(Type,LPSType), \+ compound(Form),!,Lps=..[LPSType,[Form/0]].
protify(Type,F/A, Lps):- argtype_pred(Type,LPSType), integer(A),!,Lps=..[LPSType,[F/A]].
protify(Type,(X1,X2),[Lps1,Lps2]):- !, protify(Type,X1,Lps1),protify(Type,X2,Lps2).
%protify(Type,X,Lps):- cfunctor(X,F,A),Lps=(F/A).
protify(Event,X,LPS):- ((event) == Event), compound(X), arg(1,X,Agent),
  is_agent(Agent),
  !,protify(both,X,LPS).
protify(Type,X,[mpred_prop(X,Type),LPS]):- argtype_pred(Type,LPSType),protify(LPSType,X,LPS).
protify(LPSType,X,LPS):- cfunctor(X,F,A),cfunctor(_Lps,F,A),!,Pred=..[LPSType,[F/A]],LPS=[Pred].

is_agent(Agent):- \+ atom(Agent),!,fail.
is_agent(diver).
is_agent(agent).
is_agent(Agent):- call_u(subsort(Agent,agent)),!.

:- fixup_exports.


:- listing(test_lps_pddl_ereader).

%:- break.

