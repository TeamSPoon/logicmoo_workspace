% -*- mode: Prolog -*-

:- module(scalar_test_read, [scalar_test_read_main/0]).

:- initialization(scalar_test_read_main, main).

:- use_module(library(protobufs)).
:- use_module(scalar_test_common).

% Not needed because we're using plunit:
% :- set_prolog_flag(optimise_debug, false). % ensure assertion/1 is executed

scalar_test_read_main :-
    run_tests.

:- begin_tests(scalar).

test(scalars1a) :-
    template1(Template, Vars),
    Vars = [V_double,
            V_float,
            V_int32,
            V_int64,
            V_uint32,
            V_uint64,
            V_sint32,
            V_sint64,
            V_fixed32,
            V_fixed64,
            V_sfixed32,
            V_sfixed64,
            V_bool,
            V_string,
            V_bytes,
            V_enum],
    read_file_to_codes('scalars1a_from_cc.wire', WireStream, [encoding(octet),type(binary)]),
    % format(user_error, 'WireStream=~q~n', [WireStream]),
    protobuf_message(Template, WireStream),
    % print_term(Template, [output(user_error)]), nl(user_error),
    assertion(V_double   == 1.5),
    assertion(V_float    == 2.5),
    assertion(V_int32    == 3),
    assertion(V_int64    == 4),
    assertion(V_uint32   == 5),
    assertion(V_uint64   == 6),
    assertion(V_sint32   == 7),
    assertion(V_sint64   == 8),
    assertion(V_fixed32  == 9),
    assertion(V_fixed64  == 10),
    assertion(V_sfixed32 == 11),
    assertion(V_sfixed64 == 12),
    assertion(V_bool     == false),
    assertion(V_string   == "écran 網目錦蛇"),
    assertion(V_bytes    == [0xc3, 0x28]),
    assertion(V_enum     ==  'E1').

test(scalars1b) :-
    template1(Template, Vars),
    Vars = [V_double,
            V_float,
            V_int32,
            V_int64,
            V_uint32,
            V_uint64,
            V_sint32,
            V_sint64,
            V_fixed32,
            V_fixed64,
            V_sfixed32,
            V_sfixed64,
            V_bool,
            V_string,
            V_bytes,
            V_enum],
    read_file_to_codes('scalars1b_from_cc.wire', WireStream, [encoding(octet),type(binary)]),
    % format(user_error, 'WireStream=~q~n', [WireStream]),
    protobuf_message(Template, WireStream),
    % print_term(Template, [output(user_error)]), nl(user_error),
    assertion(V_double   ==  -1.5),
    assertion(V_float    ==  -2.5),
    assertion(V_int32    ==  -3),
    assertion(V_int64    ==  -4),
    assertion(V_uint32   =:=  5+10000000),
    assertion(V_uint64   =:=  6+10000000),
    assertion(V_sint32   ==  -7),
    assertion(V_sint64   ==  -8),
    assertion(V_fixed32  =:=  9+1000),
    assertion(V_fixed64  =:= 10+1000),
    assertion(V_sfixed32 == -11),
    assertion(V_sfixed64 == -12),
    assertion(V_bool     ==  true),
    assertion(V_string   ==  "[àmímé níshíkíhéꜜbì] reticulated python"),
    assertion(V_bytes    ==  [0xf0, 0x28, 0x8c, 0x28]),
    assertion(V_enum     ==  'AnotherEnum').

:- end_tests(scalar).
