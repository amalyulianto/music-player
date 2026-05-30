/// Utility class to format [Duration] values into text.
class DurationFormatter {
  /// Formats a [Duration] into a clean 'm:ss' representation.
  static String format(Duration d) {
    final minutes = d.inMinutes;
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
