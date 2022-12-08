import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Puzzle: https://adventofcode.com/2022/day/8
void main(List<String> arguments) {
  final trees = File('assets/day_08_tree_map.txt')
      .readAsStringSync()
      .split('\n')
      .map((e) => e.split('').map((s) => int.parse(s)).toList().asMap())
      .toList()
      .asMap();

  final visible = trees.map((row, rowTrees) => MapEntry(
      row,
      rowTrees.map((col, tree) => MapEntry(
          col,
          trees.entries // UP
                      .where((rowE) => rowE.value.entries
                          .where((colE) =>
                              colE.key == col &&
                              rowE.key < row &&
                              colE.value < tree)
                          .isNotEmpty)
                      .length ==
                  row ||
              trees.entries // DOWN
                      .where((rowE) => rowE.value.entries
                          .where((colE) =>
                              colE.key == col &&
                              rowE.key > row &&
                              colE.value < tree)
                          .isNotEmpty)
                      .length ==
                  trees.length - 1 - row ||
              trees.entries // LEFT
                  .where((rowE) =>
                      rowE.value.entries
                          .where((colE) =>
                              rowE.key == row &&
                              colE.key < col &&
                              colE.value < tree)
                          .length ==
                      col)
                  .isNotEmpty ||
              trees.entries // RIGHT
                  .where((rowE) =>
                      rowE.value.entries
                          .where((colE) =>
                              rowE.key == row &&
                              colE.key > col &&
                              colE.value < tree)
                          .length ==
                      rowTrees.length - 1 - col)
                  .isNotEmpty))));

  // Pretty map
  print(visible.values
      .map((e) => e.values.map((v) => v ? '🎄' : '⚫').join(''))
      .join('\n'));

  // visible tree height map
  print(visible.keys
      .map((e) => trees[e]!
          .keys
          .map((k) => visible[e]![k]! ? trees[e]![k]! : ' ')
          .join(''))
      .join('\n'));

  final visibleTreeCount = visible.entries.fold(
      0,
      (sum, row) =>
          sum +
          row.value.entries.fold(0, (rowSum, v) => rowSum + (v.value ? 1 : 0)));
  print(' Part 1: There are $visibleTreeCount visible trees');

  exitCode = 0;
}
