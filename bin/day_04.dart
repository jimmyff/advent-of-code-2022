import 'dart:io';

// Puzzle: https://adventofcode.com/2022/day/4
void main(List<String> arguments) {
  // parse the assigment pairs
  final assigments = RegExp(r'([0-9]+)-([0-9]+),([0-9]+)-([0-9]+)\n');
  final pairs = assigments
      .allMatches(File('assets/day_04_assigments.txt').readAsStringSync())
      .map((m) => [
            List.generate(int.parse(m[2]!) + 1 - int.parse(m[1]!),
                (index) => int.parse(m[1]!) + index),
            List.generate(int.parse(m[4]!) + 1 - int.parse(m[3]!),
                (index) => int.parse(m[3]!) + index)
          ]..sort((a, b) => a.length.compareTo(b.length)));

  final fullyContained =
      pairs.where((p) => p[0].every((n) => p[1].contains(n)));
  print('Part 1: Fully contained pairs= ${fullyContained.length}');

  final withOverlap = pairs.where((p) => p[0].any((n) => p[1].contains(n)));
  print('Part 2: Pairs with overlap= ${withOverlap.length}');

  exitCode = 0;
}
