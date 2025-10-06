class DayUtils {
  static const Map<int, String> _dayMap = {
    1: "Pzt",
    2: "Sal",
    3: "Çar",
    4: "Per",
    5: "Cum",
    6: "Cmt",
    7: "Paz",
  };

  static String formatDays(List<int> days) {
    final sortedDays = days.toList()..sort();
    return sortedDays.map((d) => _dayMap[d] ?? d.toString()).join(", ");
  }
}
