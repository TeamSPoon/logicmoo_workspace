
:- compile('$REGULUS/PrologLib/CorpusTools/extract_bicorpus').

go :-
	extract_bicorpus('$ACCEPT/MT/Europarl/Generated/europarl_ez_transformed_orthography_fr.txt',
			 '$ACCEPT/MT/Europarl/Generated/europarl_ez_filtered_en.txt',
			 not("*** NO TRANSFORM - DISCARD ***"),
			 '$ACCEPT/MT/Europarl/Generated/europarl_ez.fr',
			 '$ACCEPT/MT/Europarl/Generated/europarl_ez.en').

:- go.

:- halt.
