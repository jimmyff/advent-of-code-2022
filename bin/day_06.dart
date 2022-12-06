import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Puzzle: https://adventofcode.com/2022/day/6
void main(List<String> arguments) {
  // stream
  var processed = [];

  final datastream = File('assets/day_06_datastream.txt').readAsStringSync();

  // find start-of-packet marker
  var data = datastream.split('').takeWhile((value) {
    processed = [value, ...processed].take(4).toList();
    return processed.toSet().length != 4;
  });
  print('Part 1: Marker appears after ${data.length + 1} character arrives');

  // find message
  data = datastream.split('').takeWhile((value) {
    processed = [value, ...processed].take(14).toList();
    return processed.toSet().length != 14;
  });

  print('Part 2: Message appears after ${data.length + 1} character arrives');

  exitCode = 0;
}
