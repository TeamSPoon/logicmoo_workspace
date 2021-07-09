% -*- mode: Prolog -*-

%% Parse the output of protoc --decode=FileDescriptorSet
%% It does not handle the general output of protoc --decode ... for
%% that, use protoc --descriptor_set_out [--include_imports] and
%% process that protobuf.

% This code is reversible -- that is, you can do this, where
% `Term` is ground but `Codes` isn't, e.g., to round-trip descriptor.proto.dump:
% see test_parse_round_trip.

:- module(parse_descriptor_proto_dump,
          [parse_descriptor/0,
           parse_descriptor/1,
           parse_file/2,
           test_parse_round_trip/0,
           file//1]).

:- use_module(library(dcg/basics),
              [whites//0,
               digits//1,
               nonblanks//1,
               string_without//2,
               blanks_to_nl//0]).
:- use_module(library(dcg/high_order),
              [sequence//2,
               optional//2]).
:- use_module(library(debug), [debug/3, debug/1]).

:- meta_predicate bidi(3, 2, ?, ?, ?).

% :- debug(dcg_trace).

% Use one of these to process the file:

parse_descriptor :-
    parse_descriptor(Term),
    print_term(Term, []), nl.

parse_descriptor(Term) :-
    parse_file('descriptor.proto.dump', Term).

parse_file(File, Term) :-
    read_file_to_codes(File, Codes, [encoding(octet),type(binary)]),
    phrase(file(Term), Codes).

test_parse_round_trip :-
    parse_descriptor(Term),
    phrase(file(Term), Codes),
    string_codes(String, Codes),
    write(String), nl.


% The parser:
% All the rules have an Indent parameter. For parsing, this is ignored.
% For output, it's a list of 32 (ascii blank) that's put at the beginning
% of each line, to produce nicely indented output.

file(File) -->
    file([], File).

file(Indent0, file{name:Name,
                   package:Package,
                   message_type:MessageType,
                   options:Options}) -->
    left_brace(Indent0, Indent, "file"), !,
    tag_colon_string(Indent, "name", Name),
    optional_tag_colon_string(Indent, "package", Package),
    sequence(message_type(Indent), MessageType),
    options_file(Indent, Options),
    right_brace(Indent0), !.

message_type(Indent0, message_type{name:Name, field:Field, nested_type:NestedType,
                                   enum_type:EnumType, extension_range:ExtensionRange,
                                   reserved_range:ReservedRange}) -->
    left_brace(Indent0, Indent, "message_type"), !,
    tag_colon_string(Indent, "name", Name),
    sequence(field(Indent), Field),
    sequence(nested_type(Indent), NestedType),
    sequence(enum_type(Indent), EnumType),
    sequence(extension_range(Indent), ExtensionRange),
    sequence(reserved_range(Indent), ReservedRange),
    right_brace(Indent0), !.

field(Indent0, field{name:Name, number:Number, label:Label, type:Type, type_name:TypeName,
                     default_value:DefaultValue, options:Options, json_name:JsonName}) -->
    left_brace(Indent0, Indent, "field"), !,
    optional_tag_colon_string(Indent, "name", Name),
    optional_tag_colon_number(Indent, "number", Number),
    optional_tag_colon_id(Indent, "label", Label),
    optional_tag_colon_id(Indent, "type", Type),
    optional_tag_colon_string(Indent, "type_name", TypeName),
    optional_tag_colon_string(Indent, "default_value", DefaultValue),
    optional(options(Indent, Options), {Options=options{}}),
    optional_tag_colon_string(Indent, "json_name", JsonName),
    right_brace(Indent0), !.

nested_type(Indent0, nested_type{name:Name, field:Field}) -->
    left_brace(Indent0, Indent, "nested_type"), !,
    optional_tag_colon_string(Indent, "name", Name),
    sequence(field(Indent), Field),
    right_brace(Indent0), !.

enum_type(Indent0, enum_type{name:Name, value:Value}) -->
    left_brace(Indent0, Indent, "enum_type"), !,
    tag_colon_string(Indent, "name", Name),
    sequence(value(Indent), Value),
    right_brace(Indent0), !.

value(Indent0, value{name:Name, number:Number}) -->
    left_brace(Indent0, Indent, "value"), !,
    tag_colon_string(Indent, "name", Name),
    tag_colon_number(Indent, "number", Number),
    right_brace(Indent0), !.

extension_range(Indent0, extension_range{start:Start, end:End}) -->
    left_brace(Indent0, Indent, "extension_range"), !,
    tag_colon_number(Indent, "start", Start),
    tag_colon_number(Indent, "end", End),
    right_brace(Indent0), !.

reserved_range(Indent0, reserved_range{start:Start, end:End}) -->
    left_brace(Indent0, Indent, "reserved_range"), !,
    tag_colon_number(Indent, "start", Start),
    tag_colon_number(Indent, "end", End),
    right_brace(Indent0), !.

options(Indent0, options{deprecated:Deprecated, packed:Packed}) -->
    left_brace(Indent0, Indent, "options"), !,
    optional_tag_colon_id(Indent, "deprecated", Deprecated),
    optional_tag_colon_id(Indent, "packed", Packed),
    right_brace(Indent0), !.

options_file(Indent0, options{java_package: V_java_package,
                              java_outer_classname: V_java_outer_classname,
                              optimize_for: V_optimize_for,
                              go_package: V_go_package,
                              cc_enable_arenas: V_cc_enable_arenas,
                              objc_class_prefix: V_objc_class_prefix,
                              csharp_namespace: V_csharp_namespace}) -->
    left_brace(Indent0, Indent, "options"), !,
    optional_tag_colon_string(Indent, "java_package", V_java_package),
    optional_tag_colon_string(Indent, "java_outer_classname", V_java_outer_classname),
    optional_tag_colon_id(Indent, "optimize_for", V_optimize_for),
    optional_tag_colon_string(Indent, "go_package", V_go_package),
    optional_tag_colon_id(Indent, "cc_enable_arenas", V_cc_enable_arenas),
    optional_tag_colon_string(Indent, "objc_class_prefix", V_objc_class_prefix),
    optional_tag_colon_string(Indent, "csharp_namespace", V_csharp_namespace),
    right_brace(Indent0), !.


left_brace(Indent0, Indent, Type) -->
    indent(Indent0, Indent),
    bidi(nonblanks, atom_codes, Type),
    white_1, whites, "{", blanks_to_nl, !,
    { debug(dcg_trace, '~q {~n', [Type]) }.

right_brace(Indent) -->
    whites(Indent), "}", blanks_to_nl, !.

tag_colon_string(Indent, Tag, StringAsAtom) -->
    whites(Indent),
    bidi(nonblanks, atom_codes, Tag),
    colon_string(Indent, StringAsAtom),
    { debug(dcg_trace, '  ~q : ~q~n', [Tag, StringAsAtom]) }.

tag_colon_number(Indent, Tag, Number) -->
    whites(Indent),
    bidi(nonblanks, atom_codes, Tag),
    colon_number(Indent, Number),
    { debug(dcg_trace, '  ~q : ~q~n', [Tag, Number]) }.

tag_colon_id(Indent, Tag, IdAsAtom) -->
    whites(Indent),
    bidi(nonblanks, atom_codes, Tag),
    colon_id(Indent, IdAsAtom),
    { debug(dcg_trace, '  ~q : ~q~n', [Tag, IdAsAtom]) }.

optional_tag_colon_string(Indent, Tag, StringAsAtom) -->
    optional(tag_colon_string(Indent, Tag, StringAsAtom), {StringAsAtom=''}).

optional_tag_colon_number(Indent, Tag, Number) -->
    optional(tag_colon_number(Indent, Tag, Number), {Number=0}).

optional_tag_colon_id(Indent, Tag, IdAsAtom) -->
    optional(tag_colon_id(Indent, Tag, IdAsAtom), {IdAsAtom=''}).

colon_string(_Indent, StringAsAtom) -->
    whites, ":", white_1, whites,
    "\"",
    bidi(string_without("\""), atom_codes, StringAsAtom),
    "\"",
    blanks_to_nl, !.

colon_number(_Indent, Number) -->
    whites, ":", white_1, whites,
    bidi(digits, number_codes, Number),
    blanks_to_nl, !.

colon_id(_Indent, IdAsAtom) -->
    whites, ":", white_1, whites,
    bidi(nonblanks, atom_codes, IdAsAtom),
    blanks_to_nl, !.

%! indent(Indent0, Indent)// is det.
%! For output, indent by the codes in Indent0; new indent in Indent
indent(Indent, [0' ,0' |Indent], S0, S) :-
    (   var(S0)
    ->  whites(Indent, S0, S)
    ;   whites(S0, S)
    ).

%! white_1// is det.
% For output, add one whitespace.
white_1(S0, S) :-
    (   var(S)
    ->  whites([0' ], S0, S)  % 0' is character code for space (blank).
    ;   S0 = S
    ).

whites([]) --> [].
whites([W|Ws]) -->
    [W],
    whites(Ws).

%! bidi(Element, Conversion, Converted)//2 is det.
% Does call(Element, Codes), { call(Conversion, Converted, Codes) }
% in appropriate order, depending on how the arguments are instantiated.
% ("bidi" for "bidrectional")
bidi(Element, Conversion, Converted) -->
    % Could also be done:
    %    { when( (ground(Converted) ; ground(Codes) ),
    %        call(Convert, Converted, Codes) ) },
    %    call(Element, Codes)
    (   { var(Converted) }
    ->  call(Element, Codes),
        { call(Conversion, Converted, Codes) }
    ;   { call(Conversion, Converted, Codes) },
        call(Element, Codes)
    ).

end_of_file.
