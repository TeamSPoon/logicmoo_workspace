:- include(example('SzaboLanguage_insurance_base.pl')).

% would never ends, because the lawyer allowed foreclosing in any later future... but 
% the reactive rule in SzaboLanguage_insurance_base.pl added a limit, so this fails
% observe safeArrival("10 John D. tractors") at "2018-06-21T15:00".
observe choiceOf("TractoR'Us") at 2018/6/25.
% observe to("TractoR'Us",usd(120000)) at 2018/6/25.
% observe to(holder,foreclose("Some key to all Counterparty goods", usd(5000))) at 2018/8/2.
