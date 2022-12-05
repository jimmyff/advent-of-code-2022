import 'dart:io';

// Puzzle: https://adventofcode.com/2022/day/3
void main(List<String> arguments) {
  // parse the ruckstacks
  final rucksacks = File('assets/day_03_inventory.txt')
      .readAsStringSync()
      .split('\n')
      .map((e) => Rucksack(e))
      .toList();

  final compartmentPriority =
      rucksacks.fold(0, (v, r) => v + r.compartmentIntersectionsPriority);

  print('Part 1: There are ${rucksacks.length} Elves carrying ruckstacks with '
      'an intersection priority of $compartmentPriority.');

  // create the groups
  final groups = <BadgedGroup>[];
  for (var i = 0, l = rucksacks.length; i < l; i = i + 3) {
    groups.add(BadgedGroup(rucksacks.sublist(i, i + 3)));
  }
  final groupPriority = groups.fold(0, (v, r) => v + r.badgePriority);

  print('Part 2: There are ${groups.length} groups of Elves with a badge '
      'priority of $groupPriority.');

  exitCode = 0;
}

class BadgedGroup {
  final List<Rucksack> ruckstacks;
  late final String badge;

  BadgedGroup(this.ruckstacks) {
    badge = ruckstacks.fold<Set<String>>(
        {},
        (v, r) =>
            v.isEmpty ? r.inventory : (v.intersection(r.inventory))).first;
  }

  int get badgePriority => Rucksack.calcIntersectionsPriority({badge});
}

class Rucksack {
  final Set<String> compartment1;
  final Set<String> compartment2;

  Rucksack(String inventory)
      : assert(inventory.length % 2 == 0, 'Expected even number of items'),
        compartment1 = inventory
            .substring(0, (inventory.length / 2).ceil())
            .split('')
            .toSet(),
        compartment2 = inventory
            .substring((inventory.length / 2).ceil())
            .split('')
            .toSet();

  Set<String> get inventory => compartment1..addAll(compartment2);

  Set<String> get compartmentIntersections =>
      compartment1.intersection(compartment2);

  int get compartmentIntersectionsPriority =>
      calcIntersectionsPriority(compartmentIntersections);

  static String get _intersectionPriority =>
      '_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  static calcIntersectionsPriority(Set<String> intersections) =>
      intersections.fold(0, (v, e) => v + _intersectionPriority.indexOf(e));
}
