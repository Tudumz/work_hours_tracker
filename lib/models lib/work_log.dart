class WorkLog {
  final String id;
  final DateTime date;
  final double hours;
  final String? comment;

  WorkLog({
    required this.id,
    required this.date,
    required this.hours,
    this.comment,
  });

  // Превращение в набор ключей и значений для отправки в Firebase
  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'hours': hours,
      'comment': comment,
    };
  }

  // Создание объекта WorkLog из данных, из Firebase
  factory WorkLog.fromMap(String id, Map<String, dynamic> map) {
    return WorkLog(
      id: id,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      hours: (map['hours'] as num).toDouble(),
      comment: map['comment'],
    );
  }
}
