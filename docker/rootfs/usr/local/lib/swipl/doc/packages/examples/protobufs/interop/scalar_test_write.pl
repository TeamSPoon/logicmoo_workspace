% -*- mode: Prolog -*-

% Test of scalar_test.proto, scalar_test.py
% Assumes it is called from scalar_test.pl

:- module(scalar_test, [scalar_test_main/0]).

:- use_module(library(plunit)).

:- initialization(scalar_test_main, main).

:- use_module(library(protobufs)).
:- use_module(scalar_test_common).

scalar_test_main :-
    write1,
    write2.

write1 :-
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
    V_double   = 1.5,
    V_float    = 2.5,
    V_int32    = 3,
    V_int64    = 4,
    V_uint32   = 5,
    V_uint64   = 6,
    V_sint32   = 7,
    V_sint64   = 8,
    V_fixed32  = 9,
    V_fixed64  = 10,
    V_sfixed32 = 11,
    V_sfixed64 = 12,
    V_bool     = false,
    V_string   = "écran 網目錦蛇",
    V_bytes    = [0xc3, 0x28],
    V_enum     = 'E1',
    test_write('scalars1a_from_prolog.wire', Template).

write2 :-
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
    V_double   =  -1.5,
    V_float    =  -2.5,
    V_int32    =  -3,
    V_int64    =  -4,
    V_uint32   is  5+10000000,
    V_uint64   is  6+10000000,
    V_sint32   =  -7,
    V_sint64   =  -8,
    V_fixed32  is  9+1000,
    V_fixed64  is 10+1000,
    V_sfixed32 = -11,
    V_sfixed64 = -12,
    V_bool     = true,
    V_string   = "[àmímé níshíkíhéꜜbì] reticulated python",
    V_bytes    = [0xf0, 0x28, 0x8c, 0x28],
    V_enum     =  'AnotherEnum',
    test_write('scalars1b_from_prolog.wire', Template).

test_write(Path, Template) :-
    protobuf_message(Template, WireStream),
    open(Path, write, Stream, [encoding(octet),type(binary)]),
    format(Stream, '~s', [WireStream]),
    close(Stream).

