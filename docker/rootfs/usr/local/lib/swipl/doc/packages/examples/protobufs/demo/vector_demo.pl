% Sample code.
% For more explanation of this code, see ../protobufs_overview.md

% TODO: separate out some tests and use plunit for them.

:- module(vector_demo,
          [
           write_as_proto/1,
           read_from_proto/1,
           vector/2,
           send_command/3,
           send_precompiled_command/3,
           protobuf_bag/2,
           make_tmp99/0,
           xml_proto/1,
           test_basic_usage/0,
           test_basic_usage/1,
           test_segment_messages/0,
           test_send_command/0,
           test_send_command/1,
           test_send_precompiled_command/0,
           test_send_precompiled_command/1,
           test_xml/0,
           test_xml/1,
           test_xml/2
          ]).

:- use_module(library(protobufs)).
:- use_module(library(error)).
:- use_module('../eventually_implies'). % For ~>

:- use_module(library(debug)).
:- set_prolog_flag(optimise_debug, false). % assertion/1 always on


% Example: "Basic Usage"
%  (see "Basic Usage" section in ../protobufs_overview.md)

% TODO: move this to ../test_protobufs.pl
% %ODO: There is no associated .proto for this example

%! command(+Term, -Proto) is det.
% Map a Prolog term to a corresponding protobuf term.
command(add(X,Y), Proto) :-
    freeze(X, must_be(integer, X)), % for debugging
    freeze(Y, must_be(integer, Y)), % for debugging
    Proto = protobuf([atom(1, command),
                      atom(2, add),
                      integer(3, X),
                      integer(4, Y)
                     ]).
command2(Command, Op, X, Y, Extra, Proto) :-
    command2_item(Command, atom, Commands),
    command2_item(Op, atom, Ops),
    command2_item(X, integer, Xs),
    command2_item(Y, integer, Ys),
    command2_item(Extra, atom, Extras),
    Proto = protobuf([repeated(1, atom(Commands)),
                      repeated(2, atom(Ops)),
                      repeated(3, integer(Xs)),
                      repeated(4, integer(Ys)),
                      repeated(5, atom(Extras))
                     ]).

command2_item(Item, MustBe, Items) :-
    freeze(Item, must_be(MustBe, Item)),
    (   var(Item)
    ->  freeze(Items, ( Items = [] ; Items = [Item] ) ) % or: last(Items, Item)
    ;   Items = [Item]
    ).

test_basic_usage :-
    forall(test_basic_usage(Term),
           ( print_term(Term, []), nl )).

test_basic_usage(['X'=X,
                  'X2'=X2,
                  'Y'=Y,
                  'Y2'=Y2,
                  'Command2'=Command2,
                  'Op2'=Op2,
                  'Extra2'=Extra2,
                  'Proto'=Proto,
                  'WireCodes'=WireCodes,
                  'Segments-raw'=Segments,
                  'CommandCode'=CommandCode,
                  'OpCode'=OpCode,
                  'Xseg'=Xseg,
                  'Yseg'=Yseg]) :-
    X = 666, Y = 123,
    command(add(X,Y), Proto),
    protobuf_message(Proto, WireCodes),
    % and read it back again:
    command(add(X2,Y2), Proto2),
    protobuf_message(Proto2, WireCodes),
    assertion(Proto == Proto2),
    command2(Command2, Op2, X2, Y2, Extra2, Proto3),
    protobuf_message(Proto3, WireCodes),
    protobuf_segment_message(Segments, WireCodes),
    Segments = [string(1,CommandCode),
                string(2,OpCode),
                varint(3,Xzig),
                varint(4,Yzig)],
    % The following conversions are based on our knowledge
    % of the Proto template:
    integer_zigzag(Xseg, Xzig),
    integer_zigzag(Yseg, Yzig),
    protobuf_segment_message(Segments, WireCodes4),
    assertion(WireCodes == WireCodes4).

% ======================

% vector_type/2 corresponds to pb-vector.proto enum VectorType
vector_type(double(_List),    2).
vector_type(float(_List),     3).
vector_type(integer(_List),   4).
vector_type(integer64(_List), 5).
vector_type(integer32(_List), 6).
vector_type(unsigned(_List),  7).
vector_type(codes(_List),     8).
vector_type(atom(_List),      9).
vector_type(string(_List),    10).

% basic_vector/2 corresponds to pb-vector.proto message Vector
basic_vector(TypedList, Template) :-
    vector_type(TypedList, Tag),
    Template = protobuf([ repeated(Tag, TypedList) ]).

%! vector(+TypedList, -WireCodes:list(int)) is det.
% TypedList is of the form Type(List) - see vector_type/2
% WireCodes is a list of codes to be output
vector(TypedList, WireCodes):-
    basic_vector(TypedList, Proto),
    protobuf_message(Proto, WireCodes).

%! write_as_proto(+TypedList) is det.
% TypedList is of the form Type(List) - see vector_type/2
write_as_proto(TypedList) :-
    vector(TypedList, Z),
    open('tmp99.tmp', write, S, [encoding(octet),type(binary)])
      ~> close(S),
    format(S, '~s', [Z]), % ~s: list of character codes
    !.

read_from_proto(V) :-
    read_file_to_codes('tmp99.tmp', Codes, [encoding(octet),type(binary)]),
    vector(V, Codes).

protobufs:commands(Key, Value) :-
    nth1(Value,
            [ square,
              decimate,
              transform,
              inverse_transform
            ],
         Key).

send_command(Command, Vector, WireCodes) :-
    basic_vector(Vector, Proto1),
    Proto = protobuf([enum(1, commands(Command)), embedded(2, Proto1)]),
    % e.g., if Command=square, Proto1=protobuf([repeated(2,double([1,22,3,4]))])
    %       Proto=protobuf([ enum(1,commands(square)),
    %                        embedded(2,protobuf([repeated(2,double([1,22,3,4]))]))
    %                      ])
    % protobuf:commands/2 is used to expand an enum: the code in
    % library(protobufs) expands an` enum(Tag,Type)` by calling `Type`,
    % so enum(1,commands(square)) gets turned into enum(1,1) by calling
    % protobufs:commands(square,Value) => Value=1
    protobuf_message(Proto, WireCodes).

test_send_command :-
    test_send_command(WireCodes),
    protobuf_segment_message(Seg, WireCodes),
    print_term(Seg, []), nl.

test_send_command(WireCodes) :-
    send_command(square, double([1,22,3,4]), WireCodes).

test_send_precompiled_command :-
    test_send_precompiled_command(WireCodes),
    protobuf_segment_message(Seg, WireCodes),
    print_term(Seg, []), nl.

test_send_precompiled_command(WireCodes) :-
    send_precompiled_command(square, double([1,22,3,4]), WireCodes).

send_precompiled_command(Command, Vector, WireCodes) :-
    basic_vector(Vector, Proto1),
    precompiled_message(commands(Command), WireCodes, WireCodes1),
    protobuf_message(protobuf([embedded(3, Proto1)]), WireCodes1),

    % Do it again, but without the precompiled message.
    % Above, precompile_commands added
    % [atom(1,command), enum(2,commands(Command)].
    Proto2 = protobuf([atom(1, command),
                       enum(2, commands(Command)),
                       embedded(3, Proto1)]),
    protobuf_message(Proto2, WireCodes2),
    assertion(WireCodes2 == WireCodes).

term_expansion(precompile_commands, Clauses) :-
    findall(precompiled_message(commands(Key), WireCodes, Tail),
            (   protobufs:commands(Key, _),
                Proto = protobuf([atom(1, command),
                                  enum(2, commands(Key))]),
                protobuf_message(Proto, WireCodes, Tail)
            ),
            Clauses).

%
%

compound_protobuf(complex(Real, Img),
                  group(12, [
                             double(1, Real),
                             double(2, Img)])).
compound_protobuf(float(Val),
                  float(13, Val)).
compound_protobuf(double(Val),
                  double(14, Val)).
compound_protobuf((Num rdiv Den),
                  group(15, [
                             integer(1, Num),
                             integer(2, Den)])).
compound_protobuf(integer(Val),
                  integer(16, Val)).

protobuf_bag([], []).

protobuf_bag([Type|More], WireCodes) :-
    compound_protobuf(Type, X),
    Proto = protobuf([embedded(1, protobuf([X]))]),
    protobuf_message(Proto, WireCodes, WireCodes1),
    protobuf_bag(More, WireCodes1),
    !.

make_tmp99 :-
    X is pi,
    write_as_proto(double([-2.2212, -7.6675, X, 0, 1.77e-9, 2.54e222])),
    halt(0).

%
%  Example of adding ornamental message sequences to the parser.
%  In this example we demonstrate managing a recursive structure like
%  XML. The structure shown in xml_proto/1 below, is similar to the
%  structure returned by load_xml_file/2, which is part of the SGML
%  library. We supply three message_sequence decorators: kv_pair,
%  xml_element, and aux_xml_element. These are treated as first class
%  host types.
%
:- multifile protobufs:message_sequence/5.

protobufs:message_sequence(Type, Tag, Value)  -->
    { my_message_sequence(Type, Value, Proto) },
    protobufs:message_sequence(embedded, Tag, Proto),
    !.
%
% On encode, the value type determines the tag. And on decode
% the tag to determines the value type.
%
guard(Type, Value) :-
    (nonvar(Value) -> is_of_type(Type, Value); true).

my_message_sequence(kv_pair, Key=Value, Proto) :-
    Proto = protobuf([ atom(30, Key), X]),
    (   (   guard(integer, Value), X = integer(31, Value));
        (   guard(float, Value),   X = double(32, Value));
        (   guard(atom, Value),    X = atom(33, Value))).

%
%
my_message_sequence(xml_element, element(Name, Attributes, Contents), Proto) :-
    Proto = protobuf([ atom(21, Name),
                       repeated(22, kv_pair(Attributes)),
                       repeated(23, aux_xml_element(Contents))]).
%
%
my_message_sequence(aux_xml_element,  Contents, Proto) :-
    functor(Contents, element, 3),
    Proto = protobuf([xml_element(40, Contents)]).

my_message_sequence(aux_xml_element, Contents, Proto) :-
    Proto = protobuf([atom(43, Contents)]).


xml_proto([element(space1,
                   [foo='1', bar='2'],
                   [fum,
                    bar,
                    element(space2,
                            [fum= 3.1415, bum= -14],
                            ['more stuff for you']),
                    element(space2b,
                            [],
                            [this, is, embedded, also]),
                    to,
                    you])]).

test_xml(X, Y) :-
    Proto = protobuf([repeated(20, xml_element(X))]),
    protobuf_message(Proto, Y).

%! test_xml(-WireCodes:list(int)) is det.
% Tests outputting the data defined by xml_proto/1.
% =WireCodes= is a list of codes to be output
test_xml(['XmlProto'=XmlProto, 'WireCodes'=WireCodes]) :-
    xml_proto(XmlProto),
    test_xml(XmlProto, WireCodes),
    test_xml(XmlProto2, WireCodes),
    XmlProto == XmlProto2.

test_xml :-
    test_xml(['XmlProto'=XmlProto, 'WireCodes'=WireCodes]),
    print_term('XmlProto'=XmlProto, []), nl,
    format('~q~n', ['WireCodes'=WireCodes]).

%! test_segment_messages is det.
% Tests round-trip of segment_protobuf_segment_message/2,
% using the protobuf wire form of descriptor.proto.
% You may wish to compare the contents of =Segments= with
% the output from protoc --decode_raw
test_segment_messages :-
    assertion(test_segment_assertions),
    read_file_to_codes('descriptor.proto.wire', WireStream, [encoding(octet),type(binary)]),
    protobuf_segment_message(Segments, WireStream),
    % Check that it reverses:
    protobuf_segment_message(Segments, WireStream2),
    assertion(WireStream == WireStream2),
    Segments = [message(1, MessageSegments)],
    length(MessageSegments, MessageSegmentsLen),
    format('test_segment_messages succeeded with ~d segment(s) in the message.~n', [MessageSegmentsLen]),
    % And print it out in all its glory (but it's rather long, so don't, for now)
    true. % print_term(Segments, [tab_width(0), right_margin(88)]), nl.

test_segment_assertions :-
    % Check that we can reinterpret a segment that comes out
    % in an unexpected form:
    forall(
           protobuf_segment_convert(message(10, [fixed64(13,[110,112,117,116,84,121,112,101])]), S1),
           assertion(( S1 == string(10, "inputType")
                     ; S1 == length_delimited(10,[105,110,112,117,116,84,121,112,101]) ))).

precompile_commands.  % Trigger the term-expansion precompilation
