----------------------------------------------------------------------------------------------------------------------------------
General point of view and a few observations

Requested predicates for the assignment:

sentence_type/2	 -> Successfully implemented
semtrans/3       -> Successfully implemented
chataway/1       -> Successfully implemented
chat_at_aim/4	 -> NOT implemented

A 'simple' chatbot was implemented, using Prolog. The chatbot takes the place of an assistant to a football coach.

Six main types of sentences were implemented, namely:

'greeting', 'introduction', 'who_question', 'where_question', 'subject_change' and 'farewell'

Even though the variety of sentences is limited, there are enough of them to do a good display of the implementation.

The goal was to implement a chat that would simulate a conversation between a coach and an assistant(bot).

Many auxiliary predicates were used. Those are explained in the code file.
----------------------------------------------------------------------------------------------------------------------------------
sentence_type/2: (ARG1, a list) | (ARG2, an atom)

This queries indicates the possible sentences of the greeting type (Coach sentences).

?- sentence_type(X,'greeting').
X = [hello, bot] ;
X = [hello, football, bot] ;
X = [hi, bot] ;
X = [hi, football, bot] ;
X = [hey, bot] ;
X = [hey, football, bot] ;
X = [good, morning, bot] ;
X = [good, morning, football, bot] ;
X = [good, afternoon, bot] ;
X = [good, afternoon, football, bot] ;
X = [good, evening, bot] ;
X = [good, evening, football, bot] ;
X = [good, night, bot] ;
X = [good, night, football, bot].

And this query indicates the possible answers of a greeting type (Assistant sentences),
though only using this query isn't clear that the bot takes in consideration some key words from
the previous sentence.

?- sentence_type(X,'greeting_answer').
X = [hello, coach] ;
X = [hello, mister] ;
X = [hello, sir] ;
X = [hello, manager] ;
X = [hi, coach] ;
X = ...

In the implementation this predicate will be mainly used to generate a list of possible answers, instead
of giving a simple true/false answer, that is why there is no cut(!) included in the predicate.
Even though it will tell the type of a sentence if it is among the possible sentences. 

?- sentence_type([good, night, coach],X).
X = greeting_answer ;
false.

?- sentence_type([hello, bot],X).
X = greeting ;
false.

?- sentence_type([see, you, later],X).
X = farewell ;
X = farewell_answer ;
false.

----------------------------------------------------------------------------------------------------------------------------------
semtrans/3: It gives a probability of going from sentence type A to sentence type B.

This was implemented as a list of facts. Some example of the facts are following.

semtrans('introduction','who_question',0.65).
semtrans('introduction','where_question',0.3).
semtrans('introduction','farewell',0.05).

The next query indicates the possible next stages after a 'who_question' sentence. Also indicates the probability of the event happening.

?- semtrans('who_question',X,P).
X = subject_change,
P = 0.6 ;
X = farewell,
P = 0.4.

The following query is fairly simple. All it answers is the probability of going from a 'subject_change' sentence to a 'where_question' sentence.

̀?- semtrans('subject_change','where_question',P).
P = 0.4.

----------------------------------------------------------------------------------------------------------------------------------
chataway/1: Arg1 is the maximum number of messages in the conversation.

This predicate has the goal to simulate a conversation between a coach and an assistant(bot). 

It was my main focus for this assignment and almost all of the auxiliary predicates were used to make this predicate work well.

Some of the auxiliary predicates goals were to:
-> Act accordingly to the probability of going from sentence type A to B
-> Make the conversation look natural (Using keywords and grammars for that effect)
-> Generate multiply sentences respecting the structure of the grammars
-> Always end the conversation in a natural way when maximum length is reached, though the conversation may end naturally

Some examples of chats are following.

Х?- chataway(10).
Coach: good evening football bot
Bot: good evening sir
Coach: do you have some time ?
Bot: sure i have some time
Coach: who is the best striker for the next game ?
Bot: the best striker is mario
Coach: goodbye
Bot: goodbye
true.

?- chataway(1).
Coach: good night football bot
Bot: sorry i have to go
Coach: goodbye
true.


?- chataway(10).
Coach: good evening bot
Bot: good evening sir
Coach: i need some help
Bot: how can i help ?
Coach: who is the best defender for the next game ?
Bot: the best defender is john
Coach: interesting . there is something else i want to discuss
Bot: sure , what else do you want to discuss ?
Coach: where is henrique hiding ?
Bot: henrique is not hiding . he is at home sick
Coach: goodbye . thanks for the help
Bot: glad i could help
true.

?- chataway(15).
Coach: good afternoon bot
Bot: good afternoon mister
Coach: i need help with the team
Bot: how can i help ?
Coach: who is our new oponent ?
Bot: our new oponent is chelsea
Coach: see you soon . thanks for the help
Bot: glad i could help
true.

?- chataway(15).
Coach: good morning bot
Bot: good morning manager
Coach: i need your help with something
Bot: how can i help ?
Coach: where did fabio travelled to ?
Bot: fabio travelled to barcelona
Coach: thanks . i need something else
Bot: what else do you need ?
Coach: is anyone injured ?
Bot: thomas is injured
Coach: bye . thanks for the help
Bot: glad i could help
true.

----------------------------------------------------------------------------------------------------------------------------------
