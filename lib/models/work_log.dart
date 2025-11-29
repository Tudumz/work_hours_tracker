class WorkLog {
  final String id;
  final DateTime date;
  final double hours;
  final String? comment;
  final String? startTime;
  final String? endTime;
  final bool hasBreak;

  WorkLog({
    required this.id,
    required this.date,
    required this.hours,
    this.comment,
    this.startTime,
    this.endTime,
    this.hasBreak = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'hours': hours,
      'comment': comment,
      'startTime': startTime,
      'endTime': endTime,
      'hasBreak': hasBreak,
    };
  }

  factory WorkLog.fromMap(String id, Map<String, dynamic> map) {
    return WorkLog(
      id: id,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      hours: (map['hours'] as num).toDouble(),
      comment: map['comment'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      hasBreak: map['hasBreak'] ?? false,
    );
  }
}
