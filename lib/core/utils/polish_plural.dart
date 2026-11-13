String pluralize(int count, String one, String few, String many) {
  if (count == 1) return one;

  final lastDigit = count % 10;
  final lastTwoDigits = count % 100;

  final endsWithTwoToFour = lastDigit >= 2 && lastDigit <= 4;
  final isTeen = lastTwoDigits >= 12 && lastTwoDigits <= 14;

  if (endsWithTwoToFour && !isTeen) return few;
  return many;
}
