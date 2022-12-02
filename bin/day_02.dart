import 'dart:io';

// Puzzle: https://adventofcode.com/2022/day/2
void main(List<String> arguments) {
  for (final part in [1, 2]) {
    print('Part $part:');
    final rounds = File('assets/day_02_rounds.txt')
        .readAsStringSync()
        .split('\n')
        .map((e) => part == 1
            ? GameRound.fromEncryptedPart1(e[0], e[2])
            : GameRound.fromEncryptedPart2(e[0], e[2]))
        .toList();

    for (final r in rounds) {
      print(
          'Round #${rounds.indexOf(r) + 1}: ${r.opponent.name} vs ${r.me.name} : '
          '${r.scoreShape} + ${r.scoreOutcome} = ${r.scoreTotal}');
    }
    final totalScore = rounds.fold(0, (sum, r) => sum + r.scoreTotal);
    print('Over ${rounds.length} rounds, you scored: $totalScore');
  }

  exitCode = 0;
}

enum GameMove { rock, paper, scissors }

class GameRound {
  final GameMove opponent;
  final GameMove me;
  GameRound(this.opponent, this.me);

  // Where XYZ map to: index of GameMove
  factory GameRound.fromEncryptedPart1(String opponent, String me) => GameRound(
      GameMove.values['ABC'.indexOf(opponent)],
      GameMove.values['XYZ'.indexOf(me)]);

  // Where XYZ map to: lose, draw, win
  factory GameRound.fromEncryptedPart2(String opponent, String outcome) =>
      GameRound(
          GameMove.values['ABC'.indexOf(opponent)],
          //handle draw
          outcome == 'Y'
              ? GameMove.values['ABC'.indexOf(opponent)]
              // calculate our move using the [scoreOutcome] formula
              : (GameMove.values[
                  ('ABC'.indexOf(opponent) - (outcome == 'Z' ? 2 : 1)) % 3]));

  int get scoreTotal => scoreShape + scoreOutcome;
  int get scoreShape => GameMove.values.indexOf(me) + 1;
  int get scoreOutcome =>
      // handle draw
      opponent == me
          ? 3
          // winners will always = 2, losers = 1
          : ((opponent.index - me.index) % 3 == 2 ? 6 : 0);
}
