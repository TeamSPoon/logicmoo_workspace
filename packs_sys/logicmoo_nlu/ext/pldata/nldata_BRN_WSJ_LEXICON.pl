:- module(nldata_BRN_WSJ_LEXICON,[text_bpos/2]).

:- multifile((text_bpos/2)).
:- dynamic(text_bpos/2).

text_bpos('%...',(':')).
text_bpos('%CHG','nn').
text_bpos('&','cc').
text_bpos('&0C.','nn').
text_bpos('''','''').
text_bpos('','cd').
text_bpos('','sym').
text_bpos('',(')')).
text_bpos('(','(').
text_bpos('(3/26','1991)').
text_bpos('(9/9','1991)').
text_bpos(')',')').
text_bpos(').',')|.').
text_bpos(').','nn').
text_bpos(').','sym').
text_bpos(').',('.')).
text_bpos('+','cc').
text_bpos(',',',').
text_bpos(',.','sym').
text_bpos(',..','nn').
text_bpos(',...',(':')).
text_bpos(',\'cept','in').
text_bpos(',\'t-','prp').
text_bpos('-$',('$')).
text_bpos('$',('$')).
text_bpos('','').
text_bpos('',(':')).
text_bpos('271,124','cd').
text_bpos('33','cd').
text_bpos('4.8','cd').
text_bpos('Boca','nnp').
text_bpos('Bordeaux','nnp').
text_bpos('China','nnp').
text_bpos('Dell','nnp').
text_bpos('Dorothy','nnp').
text_bpos('George','nnp').
text_bpos('Hitachi','nnp').
text_bpos('Mrs','nnp').
text_bpos('Of','in').
text_bpos('Thailand','nnp').
text_bpos('Tokyo','nnp').
text_bpos('William','nnp').
text_bpos('\'cause','jj').
text_bpos('a','dt').
text_bpos('a','in').
text_bpos('a','jj').
text_bpos('about','in').
text_bpos('agreed','nn').
text_bpos('all','dt').
text_bpos('and','cc').
text_bpos('and','in').
text_bpos('and','jj').
text_bpos('and','nn').
text_bpos('are','in').
text_bpos('are','nn').
text_bpos('are','vbp').
text_bpos('at','in').
text_bpos('awarding','vbg').
text_bpos('changed','vbd').
text_bpos('combined','vbn').
text_bpos('complicated','in').
text_bpos('consented','vbd').
text_bpos('considered','vbn').
text_bpos('despite','in').
text_bpos('didn\'t','vbd|rb').
text_bpos('dividends','nns').
text_bpos('especially','rb').
text_bpos('even','jj').
text_bpos('fawning','vbg').
text_bpos('fell','vbd').
text_bpos('for','in').
text_bpos('forcing','jj').
text_bpos('grows','vbz').
text_bpos('had','vbd').
text_bpos('has','vbp').
text_bpos('here','rb').
text_bpos('how','wrb').
text_bpos('if','in').
text_bpos('if','jj').
text_bpos('in','nn').
text_bpos('including','in').
text_bpos('including','vbg').
text_bpos('it','prp').
text_bpos('like','in').
text_bpos('meal','nn').
text_bpos('mortgage-backed','jj').
text_bpos('of','in').
text_bpos('offer','vbp').
text_bpos('one','cd').
text_bpos('players','nns').
text_bpos('plus','rb').
text_bpos('presumably','rb').
text_bpos('products','nns').
text_bpos('since','in').
text_bpos('some','dt').
text_bpos('subjects','nns').
text_bpos('such','jj').
text_bpos('teetering','vbg').
text_bpos('telegraph','vbp').
text_bpos('the','cd').
text_bpos('the','dt').
text_bpos('the','jj').
text_bpos('the','nnp').
text_bpos('they','prp').
text_bpos('those','dt').
text_bpos('to','in').
text_bpos('to','jj').
text_bpos('to','to').
text_bpos('twice','rb').
text_bpos('unlike','jj').
text_bpos('vs.','in').
text_bpos('was','vbd').
text_bpos('were','vbd').
text_bpos('what','wp').
text_bpos('when','wrb').
text_bpos('which','in').
text_bpos('which','wdt').
text_bpos('who','wp').
text_bpos('will','md').
text_bpos('wines','nn').
text_bpos('with','in').
text_bpos('would','md').
text_bpos('you','jj').
text_bpos('-.10','cd').
text_bpos('-.5','cd').
text_bpos('-.50','cd').
text_bpos('-0.06','cd').
text_bpos('-1','cd').
text_bpos('-16-degrees','cd|nns').
text_bpos('-20-degrees','cd|nns').
text_bpos('-20-degrees-C','cd|nn|np').
text_bpos('-300','cd').
text_bpos('-5','cd').
text_bpos('-500','cd').
text_bpos('-57.6','cd').
text_bpos('-78-degrees','cd|nn').
text_bpos('-LCB-',('(')).
text_bpos('-LRB-',('(')).
text_bpos('-RCB-',(')')).
text_bpos('-RRB-',(')')).
text_bpos('-Samuel','nnp').
text_bpos('-Yr.','nn').
text_bpos('-aminometha','nn').
text_bpos('-axis','nn').
text_bpos('-c','nn').
text_bpos('-ing','jj').
text_bpos('-ism','nn').
text_bpos('.','.').
text_bpos('..',('.')).
text_bpos('...',(':')).
text_bpos('.01','cd').
text_bpos('.02','cd').
text_bpos('.025','cd').
text_bpos('.027','cd').
text_bpos('.03','cd').
text_bpos('.05','cd').
text_bpos('.054','cd').
text_bpos('.07','cd').
text_bpos('.076','cd').
text_bpos('.09','cd').
text_bpos('.10-a-minute','jj').
text_bpos('.10.07','cd').
text_bpos('.105','cd').
text_bpos('.12','cd').
text_bpos('.125','cd').
text_bpos('.16','cd').
text_bpos('.23','cd').
text_bpos('.270','cd').
text_bpos('.292','cd').
text_bpos('.30','cd').
text_bpos('.337','cd').
text_bpos('.357','cd').
text_bpos('.375','cd').
text_bpos('.38','cd').
text_bpos('.4','cd').
text_bpos('.40','cd').
text_bpos('.45','cd').
text_bpos('.5','cd').
text_bpos('.50','cd').
text_bpos('.50-caliber','jj').
text_bpos('.500','cd').
text_bpos('.6','cd').
text_bpos('.65','cd').
text_bpos('.75','cd').
text_bpos('.8','cd').
text_bpos('.80','cd').
text_bpos('.86','cd').
text_bpos('.9.76','cd').
text_bpos('.9.82','cd').
text_bpos('.9.92','cd').
text_bpos('.90','cd').
text_bpos('.Not','rb').
text_bpos('.\'crack','nn').

:- include('nldata_BRN_WSJ_LEXICON.nldata').
