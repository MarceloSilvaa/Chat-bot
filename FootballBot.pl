% -----------------------
% General
% -----------------------

botName --> [bot].
botName --> [football, bot].
name --> [coach]; [mister]; [sir]; [manager].

keywords('greeting') --> greetTime.
keywords('introduction') --> [help]; [have]; [time].
keywords('farewell') --> [help].
keywords('who_question') --> [best]; [striker]; [defender].
keywords('who_question') --> [injured]; [searching]; [oponent].
keywords('who_question') --> [is]; [was]; [our].
keywords('where_question') --> [next]; [training].
keywords('where_question') --> [hiding]; [henrique].
keywords('where_question') --> [fabio]; [travelled].
keywords('where_question') --> [tactics]; [stored].
keywords('where_question') --> [is]; [are].
keywords('subject_change') --> [need]; [else]; [discuss]; [want].

% -----------------------
% ‘greeting’
% -----------------------

greet1 --> [hello]; [hi]; [hey].
greet2 --> [good], greetTime.

greetTime --> [morning]; [afternoon]; [evening]; [night].

greeting --> greet1, botName.
greeting --> greet2, botName. 

greetingAns --> greet1, name.
greetingAns --> greet2, name.

% -----------------------
% ‘introduction’
% -----------------------

introduction --> [i, need, help, with, the, team].
introduction --> [i, need, your, help, with, something].
introduction --> [i, need, some, help].
introduction --> [do, you, have, a, minute, '?'].
introduction --> [do, you, have, some, time, '?'].

introductionAns --> [how, can, i, help, '?'].
introductionAns --> [sure, i, have, some, time].

% -----------------------
% ‘farewell’
% -----------------------

farewellBye --> [see, you, soon].
farewellBye --> [see, you, later].
farewellBye --> [goodbye].
farewellBye --> [bye].

farewellCoach --> [thanks, for, the, help].
farewellAssistant --> [glad, i, could, help].

farewell --> farewellBye.
farewell --> farewellBye, ['.'], farewellCoach.

farewellAns --> farewellBye.
farewellAns --> farewellAssistant.

farewell_forced --> [sorry, i, have, to, go]. 

% -----------------------
% ‘whoquestion’
% -----------------------

who_question --> [who, is, the, best, striker, for, the, next, game, '?'].
who_question --> [who, is, the, best, defender, for, the, next, game, '?'].
who_question --> [is, anyone, injured, '?'].
who_question --> [was, anyone, searching, for, me, '?'].
who_question --> [who, is, our, new, oponent, '?'].

who_answer --> [the, best, striker, is, mario].
who_answer --> [the, best, defender, is, john].
who_answer --> [thomas, is, injured].
who_answer --> [nobody, was, searching, for, you].
who_answer --> [pedro, was, searching, for, you].
who_answer --> [our, new, oponent, is, liverpool].
who_answer --> [our, new, oponent, is, chelsea].
who_answer --> [our, new, oponent, is, porto].

% -----------------------
% ‘wherequestion’
% -----------------------

where_question --> [where, is, the, next, training, '?'].
where_question --> [where, is, henrique, hiding, '?'].
where_question --> [where, are, my, tactics, stored, at, '?'].
where_question --> [where, did, fabio, travelled, to, '?'].

where_answer --> [the, next, training, is, in, algarve].
where_answer --> [henrique, is, not, hiding, '.', he, is, at, home, sick].
where_answer --> [your, tactics, are, stored, at, tacticsfolder].
where_answer --> [fabio, travelled, to, barcelona].

% -----------------------
% ‘subject_change’
% -----------------------

subject_coach --> [thanks, '.', i, need, something, else].
subject_coach --> [interesting, '.', there, is, something, else, i, want, to, discuss].

subject_bot --> [what, else, do, you, need, '?'].
subject_bot --> [sure, ',', what, else, do, you, want, to, discuss, '?'].

% -----------------------
% Main
% -----------------------

% Get type of sentence

sentence_type(Sentence,'greeting'):- greeting(Sentence,[]).
sentence_type(Sentence,'greeting_answer'):- greetingAns(Sentence,[]).
sentence_type(Sentence,'introduction'):- introduction(Sentence,[]).
sentence_type(Sentence,'introduction_answer'):- introductionAns(Sentence,[]).
sentence_type(Sentence,'who_question'):- who_question(Sentence,[]).
sentence_type(Sentence,'who_question_answer'):- who_answer(Sentence,[]).
sentence_type(Sentence,'where_question'):- where_question(Sentence,[]).
sentence_type(Sentence,'where_question_answer'):- where_answer(Sentence,[]).
sentence_type(Sentence,'subject_change'):- subject_coach(Sentence,[]).
sentence_type(Sentence,'subject_change_answer'):- subject_bot(Sentence,[]).
sentence_type(Sentence,'farewell'):- farewell(Sentence,[]). 
sentence_type(Sentence,'farewell_answer'):- farewellAns(Sentence,[]). 
sentence_type(Sentence,'farewell_forced'):- farewell_forced(Sentence,[]). 

% Probability of going from sentence type A to sentence type B

semtrans('greeting','introduction',0.9).
semtrans('greeting','who_question',0.1).
semtrans('introduction','who_question',0.65).
semtrans('introduction','where_question',0.3).
semtrans('introduction','farewell',0.05).
semtrans('who_question','subject_change',0.6).
semtrans('who_question','farewell',0.4).
semtrans('where_question','subject_change',0.3).
semtrans('where_question','farewell',0.7).
semtrans('subject_change','who_question',0.6).
semtrans('subject_change','where_question',0.4).

% Chat with a limited number of sentences

chataway(Length):- L is Length+1, chatCoach(L,'greeting'), !.

% --------------------------
% Auxiliary
% --------------------------

% Get the new type for the next sentence

chatGetType(_, 'farewell'):- !.
chatGetType(Length, PreviousType):- random(1,100,Prob),
									RP is Prob*0.01,
									getProbList(PreviousType, L),
									getTypeProb(RP,0,L,0,P),
									semtrans(PreviousType,NewType,P),
									chatCoach(Length,NewType).


% Generate and write the coach sentence

chatCoach(Length,'farewell'):- getFirstSentence('farewell',Sentence),
							   writeMain('Coach',Sentence),
							   chatBot(Length,Sentence,'farewell').
							   
chatCoach(Length, _):- succ(Prev,Length),
					   Prev=<0,
					   forcedEnd().
					   
chatCoach(Length, Type):- succ(Prev,Length),		  
						  Prev>0,
						  getFirstSentence(Type,Sentence),
						  writeMain('Coach',Sentence),
						  chatBot(Prev,Sentence,Type).


% Generate and write the assistant(bot) sentence


chatBot(Length, Sentence, 'farewell'):- getSecondSentence('farewell', Sentence, Answer),
										writeMain('Bot',Answer),
										chatGetType(Length,'farewell').
							      
chatBot(Length, _, _):- succ(Prev,Length),
						Prev=<0,
						forcedEnd().
						   
chatBot(Length, Sentence, Type):- succ(Prev,Length),		  
								  Prev>0,
								  getSecondSentence(Type, Sentence, Answer),
								  writeMain('Bot',Answer),
							      chatGetType(Prev,Type).


% Choose the new type, get the probability of the new type

getTypeProb(RP,Index,List,TotalP,P):- getElem(Index,List,P), 
									  RP=<P+TotalP, !.
									  
getTypeProb(RP,Index,List,TotalP,P):- getElem(Index,List,Prob), 
									  succ(Index,Next),
									  NewTotal is Prob+TotalP,
									  getTypeProb(RP,Next,List,NewTotal,P).


% Get sorted list of probabilities going from type A to any other type

getProbList(Type,SortedList):- findall(P,semtrans(Type,_,P),L),
							   sort(L,SortedList).


% Get element in a specific index (probability value in this case)

getElem(I,L,P):- length(L, Length), 
				 I<Length, 
				 nth0(I,L,P).	


% Using semtrans indicate the most likely new type and it's probability

maxProb(OldType, MaxType, P):- findall(Prob,semtrans(OldType,_,Prob),L), 
							   max_list(L, MAX),
							   semtrans(OldType,MaxType,MAX),
							   P is MAX*100,
							   !.


% Chat achieved the maximum length (End in a natural way)	
		
forcedEnd():- getFirstSentence('farewell_forced',Sentence),
			  writeMain('Bot',Sentence),
			  getSecondSentence('farewell_forced',Sentence,Answer),
			  writeMain('Coach',Answer).	
				
				
% Generate a sentence of a given type	
% Arg1 = Sentence type, Arg2 = Chosen sentence

getFirstSentence(Type,Sentence):- findall(X,sentence_type(X,Type),L),
								  length(L, Length),
								  random(0, Length, Index),
								  nth0(Index, L, Sentence).


% Generate a sentence to answer another sentence
% Arg1 = Sentence type, Arg2 = First sentence, Arg3 = Answer to the first sentence

getSecondSentence(Type,First,Second):- getKeywords(First,Type,KeyList),
									   complementType(Type,Comp),
									   getSentence(KeyList,Comp,Second).

% Get keywords of sentence

getKeywords(Sentence,Type,Lf):- findall(X,(keywords(Type,X,[])),L1),
							    flatten(L1,L2),
							    intersection(Sentence,L2,Lf).

% Get sentence that contain keywords

getSentence(KeyList,Type,Sentence):- findall(X,(sentence_type(X,Type),subset(KeyList,X)),Answers),
									 length(Answers, Length),
								     random(0, Length, Index),
								     nth0(Index, Answers, Sentence). 

% Write a given sentence
% Arg1 = Who spoke the sentence, Arg2 = Sentence

writeMain(Name,Sentence):- write(Name), write(': '), writeSentence(Sentence).
writeSentence([Head]):- writeln(Head), !.
writeSentence([Head|Tail]):- write(Head), write(' '), writeSentence(Tail).


% Give the complement type of a given type

complementType('greeting','greeting_answer').
complementType('introduction','introduction_answer').
complementType('who_question','who_question_answer').
complementType('where_question','where_question_answer').
complementType('subject_change','subject_change_answer').
complementType('farewell','farewell_answer').
complementType('farewell_forced','farewell').


% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% First assignment
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

ans(["Hello","coach"],1).
ans(["Good","morning","coach"],1).
ans(["Good","morning","mister"],0.9).
ans(["Good","morning","sir"],0.8).
ans(["Good","night","coach"],1).
ans(["Good","night","mister"],0.9).
ans(["Good","night","sir"],0.8).

ans(["Statistically","the","best","available","striker","is","John"],1).
ans(["Statistically","the","best","we","have","is","Mario"],0.5).

ans(["Mario","is","injured"],1).
ans(["Thomas","is","injured"],1).

keyword("Hello").
keyword("morning"). % Good morning assistant
keyword("night"). 
keyword("striker"). % Who is the best striker 
keyword("injured"). % Is anyone injured? 
keyword("play"). % I will make John play

% Receives one list (sentence), gives a list of lists (answers)

answers([],[]).
answers([Word], L):- findall(Answer, (ans(Answer,_), member(Word, Answer)), L), !.
answers([Word|Rest], L):- keyword(Word), answers([Word], L1), answers(Rest, L2), append(L1, L2, L), !.
answers([Word|Rest], L):- not(keyword(Word)), answers(Rest, L2), append([], L2, L), !.

% Return a random answer from the list of answers

runifanswer(Sentence,Answer):- answers(Sentence,L),
							   length(L, Length),
							   random(0, Length, Index),
							   nth0(Index, L, Answer).

% Output an answer

writeAnswer(X):- write(X), !. 
writeAnswer([Head|Rest]):- write(Head), write(" "), writeAnswer(Rest).

% Chat with the coach

chat("bye"):- write("Do you want to finish preparation?"), nl,
				write("(yes or no) : "),
				read(Answer), nl,
				((Answer == yes) -> write("We will be champions.") ; (Answer == no) -> chat(["bye"])).
		
		         

