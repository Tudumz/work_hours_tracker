//import 'package:equatable/equatable.dart';
//import '../models/work_log.dart';
part of 'bloc.dart';

abstract class WorkLogState extends Equatable {
  const WorkLogState();

  @override
  List<Object> get props => [];
}

class WorkLogInitial extends WorkLogState {}

class WorkLogLoading extends WorkLogState {}

class WorkLogLoaded extends WorkLogState {
  final List<WorkLog> logs;

  const WorkLogLoaded(this.logs);

  @override
  List<Object> get props => [logs];
}

class WorkLogError extends WorkLogState {
  final String message;

  const WorkLogError(this.message);
}
