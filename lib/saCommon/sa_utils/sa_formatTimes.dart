String formatTimestamp(int timestampInMilliseconds) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds);
  String year = dateTime.year.toString();
  String month = dateTime.month.toString().padLeft(2, '0'); // 保证两位数格式
  String day = dateTime.day.toString().padLeft(2, '0'); // 保证两位数格式
  return '$year-$month-$day';
}
