
% Compile the main Regulus code
:- compile('$REGULUS/Prolog/load').

% Compile Regulus grammar to Nuance
:- regulus_batch('$REGULUS/Examples/Toy0/scripts/toy0.cfg',
		 ["NUANCE"]).

:- halt.


