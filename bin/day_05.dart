import 'dart:io';

// Puzzle: https://adventofcode.com/2022/day/5
void main(List<String> arguments) {
  // puzzle input
  final input = File('assets/day_05_crates.txt').readAsStringSync();

  final stackCount =
      (RegExp(r'\n([0-9 ]*)\n').firstMatch(input)![1]!.length + 1) ~/ 4;

  final stacks = List.generate(
      stackCount,
      (i) => RegExp(
              r'(^|\A|\r|\n|\r\n).{' + (i * 4).toString() + r'}\[([A-Z]{1})\]')
          .allMatches(input)
          .map((e) => e[2])
          .toList()
          .reversed
          .toList());

  final instructions =
      RegExp(r'move ([0-9]+) from ([0-9]+) to ([0-9])($|\r|\n|\r\n)')
          .allMatches(input)
          .map((e) =>
              [int.parse(e[1]!), int.parse(e[2]!) - 1, int.parse(e[3]!) - 1]);

  // Cratemover 9000 only moves one crate at a time
  final stacks1 = [for (var a in stacks) List.of(a)];
  for (var m in instructions) {
    for (var i = 0, l = m[0]; i < l; i++) {
      stacks1[m[2]].add(stacks1[m[1]].removeLast());
    }
  }
  final topCrates9000 = stacks1.fold('', (v, e) => '$v${e.last}');
  print('Part 1: CrateMover 9000, crates on top = $topCrates9000');

  // Cratemover 9001 moves multiple crate at a time
  final stacks2 = [for (var a in stacks) List.of(a)];
  for (var m in instructions) {
    stacks2[m[2]].addAll(stacks2[m[1]].sublist(stacks2[m[1]].length - m[0]));
    stacks2[m[1]]
        .removeRange(stacks2[m[1]].length - m[0], stacks2[m[1]].length);
  }
  final topCrates9001 = stacks2.fold('', (v, e) => '$v${e.last}');
  print('Part 1: CrateMover 9000, crates on top = $topCrates9001');

  exitCode = 0;
}
