import 'package:equatable/equatable.dart';
import '../models/work_log.dart';

abstract class WorkLogState extends Equatable {
  const WorkLogState();

  @override
  List<Object> get props => [];
}

// 1. Начальное состояние (пока ничего не произошло)
class WorkLogInitial extends WorkLogState {}

// 2. Идет загрузка
class WorkLogLoading extends WorkLogState {}

// 3. Данные загружены (показываем список)
class WorkLogLoaded extends WorkLogState {
  final List<WorkLog> logs;

  const WorkLogLoaded(this.logs);

  @override
  List<Object> get props => [logs];
}

// 4. Ошибка
class WorkLogError extends WorkLogState {
  final String message;

  const WorkLogError(this.message);
}
