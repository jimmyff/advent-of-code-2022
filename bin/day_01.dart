import 'dart:io';

// Puzzle: https://adventofcode.com/2022/day/1
void main(List<String> arguments) {
  // Parse intput to List<List<int>> (elf items & calories)
  final elfInventory = File('assets/day_01_items.txt')
      .readAsStringSync()
      .split('\n\n')
      .map((e) => e.split('\n').map((s) => int.parse(s)))
      .toList();

  // Create List<int>: elf total sum of their item calories
  final elfCalories =
      elfInventory.map((e) => e.fold(0, (a, b) => a + b)).toList();

  final elvesSorted = (elfCalories..sort()).reversed;

  // Most Valued Elf: Who is carrying the most calories
  final mveIndex = elfCalories.indexOf(elvesSorted.first);

  print('Elf #$mveIndex (of ${elfInventory.length}) is carrying the most '
      'calories. They have a total of ${elfCalories[mveIndex]} calories '
      'over their ${elfInventory[mveIndex].length} item(s).');

  // Part 2 (find the top 3)
  final top3Calories = elvesSorted.take(3).fold(0, (a, b) => a + b);
  print('The top 3 elves are carrying $top3Calories between them.');

  exitCode = 0;
}
