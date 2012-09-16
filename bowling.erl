-module(bowling).
-export([scoreGame/1]).

scoreGame(String) ->
  {Frames, Bonus} = splitGame(String),
  scoreList(Frames) + scoreBonus(Frames, Bonus).

scoreList([]) ->
  0;
scoreList([strike|[Y]]) ->
  scoreFrame(strike) + 2 * scoreFrame(Y);
scoreList([strike|[strike|[Z|Tail]]]) ->
  2 * scoreFrame(strike) + scoreFrame(Z) + scoreList([strike|[Z|Tail]]);
scoreList([strike|[{X,Y}|[Z|Tail]]]) ->
  scoreFrame(strike) + scoreFrame({X,Y}) + scoreList([{X,Y}|[Z|Tail]]);
scoreList([{_,spare}|[{X,Y}|Tail]]) ->
  scoreFrame(strike) + X + scoreList([{X,Y}|Tail]);
scoreList([H|T]) ->
  scoreFrame(H) + scoreList(T).

scoreFrame(strike) ->
  10;
scoreFrame({miss, miss}) ->
  0;
scoreFrame({_, spare}) ->
  10;
scoreFrame({miss, X}) ->
  X;
scoreFrame({X, miss}) ->
  X;
scoreFrame({X, Y}) ->
  X + Y.

scoreBonus([_], {B}) ->
  scoreBonusRoll(B);
scoreBonus(_, []) ->
  0;
scoreBonus([_], {B1, B2}) ->
  scoreBonusRoll(B1) + scoreBonusRoll(B2);
scoreBonus([strike|[_]], {B1, B2}) ->
  scoreBonusRoll(B1) * 2 + scoreBonusRoll(B2);
scoreBonus([_|T], X) when length(T) > 1 ->
  scoreBonus(T, X);
scoreBonus([_|[_]], B) ->
  scoreBonus([], B);
scoreBonus([], {X,Y}) ->
  scoreBonusRoll(X) + scoreBonusRoll(Y);
scoreBonus([], {X}) ->
  scoreBonusRoll(X);
scoreBonus([], []) ->
  0.

scoreBonusRoll(strike) ->
  10;
scoreBonusRoll(miss) ->
  0;
scoreBonusRoll(X) when X > 0, X < 10 ->
  X.

splitGame([]) ->
  {[], []};
splitGame([Head|Tail]) ->
  {parseGameList(splitGame([Head], Tail)), splitBonus([Head|Tail])}.

splitGame(Previous, []) ->
  [Previous];
splitGame(Previous, [Element]) ->
  [Previous ++ [Element]];
splitGame(Previous, [$||[$||_]]) ->
  [Previous];
splitGame(Previous, [$||Tail]) ->
  [Previous] ++ splitGame([], Tail);
splitGame(Previous, [Head|Tail]) ->
  splitGame(Previous ++ [Head], Tail).

splitBonus([]) ->
  [];
splitBonus([$||[$||Tail]]) ->
  parseBonus(Tail);
splitBonus([_|T]) ->
  splitBonus(T).

parseBonus([B1|[B2]]) ->
  {parseBonusRoll(B1), parseBonusRoll(B2)};
parseBonus([B1]) ->
  {parseBonusRoll(B1)};
parseBonus([]) ->
  [].

parseBonusRoll($X) ->
  strike;
parseBonusRoll($-) ->
  miss;
parseBonusRoll(Y) ->
  list_to_integer([Y]).

parseGameList([]) ->
  [];
parseGameList([H|T]) ->
  [parseFrame(H)|parseGameList(T)].

parseFrame([X]) ->
  parseFrame(X);
parseFrame([X|[Y]]) ->
  {parseFrame(X), parseFrame(Y)};
parseFrame($-) ->
  miss;
parseFrame($X) ->
  strike;
parseFrame($/) ->
  spare;
parseFrame(Y) ->
  list_to_integer([Y]).