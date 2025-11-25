import 'package:equatable/equatable.dart';
import '../models/work_log.dart';

abstract class WorkLogEvent extends Equatable {
  const WorkLogEvent();

  @override
  List<Object> get props => [];
}

// Событие: Пользователь выбрал дату, нужно загрузить данные
class LoadWorkLogs extends WorkLogEvent {
  final DateTime date;

  const LoadWorkLogs(this.date);

  @override
  List<Object> get props => [date];
}

// Событие: Пользователь нажал "Сохранить"
class AddWorkLog extends WorkLogEvent {
  final DateTime date;
  final double hours;
  final String? comment;

  const AddWorkLog({required this.date, required this.hours, this.comment});
}
