extension NumberFormatter on num {
  String toDotSeparated() {
    return toStringAsFixed(0) // Convert number to string without decimals
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
  }
}