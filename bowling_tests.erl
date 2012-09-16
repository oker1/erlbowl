-module(bowling_tests).
-import(bowling, [scoreGame/1]).
-include_lib("eunit/include/eunit.hrl").

empty_game_scores_zero_test() ->
  ?assertEqual(0, scoreGame([])).

one_strike_scores_10_test() ->
  ?assertEqual(10, scoreGame("X")).

one_strike_and_double_miss_scores_10_test() ->
  ?assertEqual(10, scoreGame("X|--")).

one_strike_and_three_scores_16_test() ->
  ?assertEqual(16, scoreGame("X|3-")).

one_strike_and_miss_and_3_scores_16_test() ->
  ?assertEqual(16, scoreGame("X|-3")).

one_strike_and_3_and_6_scores_28_test() ->
  ?assertEqual(28, scoreGame("X|36")).

strike_and_spare_equals_30_test() ->
  ?assertEqual(30, scoreGame("X|3/")).

spare_and_3spare_equals_23_test() ->
  ?assertEqual(23, scoreGame("4/|3/||-")).

strike_and_two_bonus_strikes_equals_30_test() ->
  ?assertEqual(30, scoreGame("X||XX")).

strike_and_bonus_1_and_5_equals_16_test() ->
  ?assertEqual(16, scoreGame("X||15")).

strike_and_3_and_2_equals_16_test() ->
  ?assertEqual(16, scoreGame("4/|3-")).

spare_and_3_and_5_equals_21_test() ->
  ?assertEqual(21, scoreGame("4/|35")).

spare_and_3_and_6_and_and_one_and_four_and_2_misses_equals_42_test() ->
  ?assertEqual(42, scoreGame("4/|36|X|14|--")).

three_strikes_and_2_misses_equals_60_test() ->
  ?assertEqual(60, scoreGame("X|X|X|--")).

strike_and_2_and_3_and_5_and_miss_equals_25_test() ->
  ?assertEqual(25, scoreGame("X|23|5-")).

almost_perfect_game_but_last_missed_test() ->
  ?assertEqual(290, scoreGame("X|X|X|X|X|X|X|X|X|X||X-")).

almost_perfect_game_but_before_last_missed_test() ->
  ?assertEqual(280, scoreGame("X|X|X|X|X|X|X|X|X|X||-X")).

perfect_game_test() ->
  ?assertEqual(300, scoreGame("X|X|X|X|X|X|X|X|X|X||XX")).

all_nines_test() ->
  ?assertEqual(90, scoreGame("9-|9-|9-|9-|9-|9-|9-|9-|9-|9-||")).

all_fives_test() ->
  ?assertEqual(150, scoreGame("5/|5/|5/|5/|5/|5/|5/|5/|5/|5/||5")).
