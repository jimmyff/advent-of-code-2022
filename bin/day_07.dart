import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Puzzle: https://adventofcode.com/2022/day/7
void main(List<String> arguments) {
  final commands =
      RegExp(r'\$ (?<cmd>[a-z]+) ?(?<arg>[^\n]*)\n(?<output>[^$]*)').allMatches(
          File('assets/day_07_terminal_output.txt').readAsStringSync());

  // parse the filesystem structure
  final fs = <String, int>{};
  var path = '/';
  for (var e in commands) {
    switch (e.namedGroup('cmd')) {
      case 'cd':
        switch (e.namedGroup('arg')) {
          case '..':
            path = path.substring(0, path.lastIndexOf('/'));
            if (path.isEmpty) path = '/';
            break;
          default:
            if (e.namedGroup('arg')!.startsWith('/')) {
              path = e.namedGroup('arg')!;
            } else {
              path += '${path.length <= 1 ? '' : '/'}${e.namedGroup('arg')}';
            }
        }
        break;
      case 'ls':
        fs[path] = RegExp(r'(^\w+) ([^\n]+)(\n|$)', multiLine: true)
            .allMatches(e.namedGroup('output')!)
            .fold(0, (v, e) => v + (e[1] == 'dir' ? 0 : int.parse(e[1]!)));
        break;
    }
  }

  // calculate the totals size of each directory
  final fsTotals = <String, int>{};
  for (var e in fs.entries.toList()
    ..sort((a, b) => b.key.length.compareTo(a.key.length))) {
    fsTotals[e.key] = e.value +
        (fsTotals.entries
            .where((e2) =>
                e2.key != e.key &&
                e2.key.startsWith(e.key) &&
                e2.key.lastIndexOf('/') ==
                    e.key.length - (e.key == '/' ? 1 : 0))
            .map((e3) => e3.value)).fold(0, (p, pe) => p + pe);
  }

  print('Filesystem total size: ${fsTotals['/']!}');

  // Part 1
  final query = fsTotals.keys.where((p) => fsTotals[p]! < 100000);
  print('Part 1: x${query.length} dirs meet criteria with a '
      'total size of: ${query.fold(0, (v, e) => v + fsTotals[e]!)}');

  // Part 2
  final fsSize = 70000000;
  final spaceDesired = 30000000;
  final spaceFree = fsSize - fsTotals['/']!;
  final spaceRequired = spaceDesired - spaceFree;
  final delete = (fsTotals.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value)))
      .firstWhere((d) => d.value > spaceRequired);
  print('Part 2: we have $spaceFree available, need additional $spaceRequired '
      'the smallest dir that would free up the required space is: $delete');

  exitCode = 0;
}
