% -*- mode: Prolog -*-

%% Term expansion for descriptor_proto.pl
%% (which is used by descriptor_proto.pl to expand a
%% descriptor_proto/1 fact -- see the documentation of
%% descriptor_proto.pl for how this term is created.)

:- module(descriptor_proto_expand, [descriptor_proto_expand_file//1]).

:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).

:- det(descriptor_proto_expand_file//1).
descriptor_proto_expand_file(file{name:FileName,
                                  package:Package,
                                  options:Options,
                                  message_type:MessageType}) -->
    [ proto_package(Package, FileName, Options) ],
    sequence(expand_message_type(Package), MessageType).

:- det(expand_message_type//2).
expand_message_type(Package,
                    message_type{name:Name, field:Field, nested_type:NestedType,
                                 enum_type:EnumType, extension_range:ExtensionRange,
                                 reserved_range:ReservedRange}) -->
    { atomic_list_concat(['',Package,Name], '.', Fqn) },
    [ proto_message_type(Fqn, Package, Name) ],
    sequence(expand_field(Fqn), Field),
    sequence(expand_nested_type(Fqn), NestedType),
    sequence(expand_enum_type(Fqn), EnumType),
    sequence(expand_extension_range(Fqn), ExtensionRange),
    sequence(expand_reserved_range(Fqn), ReservedRange).

:- det(expand_field//2).
expand_field(Fqn, field{name:Name, number:Number, label:Label, type:Type, type_name:TypeName,
                        default_value:DefaultValue, options:Options, json_name:JsonName}) -->
    { atomic_list_concat([Fqn, Name], '.', FqnName) },
    [ proto_field_name(Fqn, Number, Name, FqnName) ],
    [ proto_field_json_name(FqnName, JsonName) ],
    [ proto_field_label(FqnName, Label) ],
    expand_field_options(FqnName, Options),
    [ proto_field_type(FqnName, Type) ],
    [ proto_field_type_name(FqnName, TypeName) ],
    [ proto_field_default_value(FqnName, DefaultValue) ].

:- det(expand_field_options//2).
expand_field_options(FqnName, Options) -->
    true_false(proto_field_option_deprecated(FqnName),
               _{deprecated:Deprecated}, Deprecated, Options, Options1),
    true_false(proto_field_option_packed(FqnName),
               _{packed:Packed}, Packed, Options1, Options2),
    { Options2 = _{} }. % ensure no other option keys

:- det(true_false//5).
true_false(Gen, DictMatch, Option, Dict0, Dict) -->
    (   { select_dict(DictMatch, Dict0, Dict) }
    ->  { true }
    ;   { Option= '', Dict = Dict0 }
    ),
    (   { Option = 'true' }
    ->  [ Gen ]
    ;   { Option = ''; Option = 'false' }
    ->  [ ]
    ;   { fail }
    ).

:- det(expand_nested_type//2).
expand_nested_type(Fqn, nested_type{name:Name, field:Field}) -->
    { atomic_list_concat([Fqn, Name], '.', FqnName) },
    [ proto_nested_type(FqnName, Fqn, Name) ],
    sequence(expand_field(FqnName), Field).

:- det(expand_enum_type//2).
expand_enum_type(Fqn, enum_type{name:Name, value:Value}) -->
    {atomic_list_concat([Fqn, Name], '.', FqnName) },
    [ proto_enum_type(FqnName, Fqn, Name) ],
    sequence(expand_enum_value(FqnName), Value).

:- det(expand_enum_value//2).
expand_enum_value(Fqn, value{name:Name, number:Number}) -->
    [ proto_enum_value(Fqn, Name, Number) ].

:- det(expand_extension_range//2).
expand_extension_range(Fqn, extension_range{start:Start, end:End}) -->
    [ proto_extension_range(Fqn, Start, End) ].

:- det(expand_reserved_range//2).
expand_reserved_range(Fqn, reserved_range{start:Start, end:End}) -->
    [ proto_reserved_range(Fqn, Start, End) ].
