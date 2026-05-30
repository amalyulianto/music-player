import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/core/utils/duration_formatter.dart';

void main() {
  group('DurationFormatter.format', () {
    test('format(Duration(seconds:0)) == "0:00"', () {
      expect(DurationFormatter.format(Duration.zero), '0:00');
    });

    test('format(Duration(seconds:65)) == "1:05"', () {
      expect(DurationFormatter.format(const Duration(seconds: 65)), '1:05');
    });

    test('format(Duration(minutes:3, seconds:40)) == "3:40"', () {
      expect(
        DurationFormatter.format(const Duration(minutes: 3, seconds: 40)),
        '3:40',
      );
    });

    test('format(Duration(minutes:10, seconds:5)) == "10:05"', () {
      expect(
        DurationFormatter.format(const Duration(minutes: 10, seconds: 5)),
        '10:05',
      );
    });
  });
}
