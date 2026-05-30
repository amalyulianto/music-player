import 'package:flutter/material.dart';

/// Dynamically generates color schemes from a song's unique identifier.
class SongColorGenerator {
  /// Generates a two-color palette based on the given song [id].
  static List<Color> forId(int id) {
    final hue = (id * 137.5) % 360;
    final c1 = HSLColor.fromAHSL(1.0, hue, 0.6, 0.4).toColor();
    final c2 = HSLColor.fromAHSL(1.0, (hue + 40) % 360, 0.6, 0.35).toColor();
    return [c1, c2];
  }
}
