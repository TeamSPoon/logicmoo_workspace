% -*- mode: Prolog -*-

% Common stuff for scalar_test_read.pl, scala_test_write.pl

:- module(scalar_test_common, [template1/2]).

% Define the enum callback:
protobufs:enum(Key, Value) :-
    nth0(Value,
         ['E1',
          'Enum2',
          'AnotherEnum'],
         Key).

template1(Template, Vars) :-
    Template = protobuf([
                         double(     1, V_double),
                         float(      2, V_float),
                         signed64(   3, V_int32),  % not signed32, for wire-format compatibility
                         signed64(   4, V_int64),
                         unsigned(   5, V_uint32),
                         unsigned(   6, V_uint64),
                         integer(    7, V_sint32),
                         integer(    8, V_sint64),
                         integer32(  9, V_fixed32),
                         integer64( 10, V_fixed64),
                         integer32( 11, V_sfixed32),
                         integer64( 12, V_sfixed64),
                         boolean(   13, V_bool),
                         string(    14, V_string),
                         codes(     15, V_bytes),
                         enum(      16, enum(V_enum))
                        ]),
    Vars = [                           V_double,
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
                                       V_enum].
