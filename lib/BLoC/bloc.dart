import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/firestore.dart';
import '../models/work_log.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class WorkLogBloc extends Bloc<WorkLogEvent, WorkLogState> {
  final FirestoreService _firestoreService;

  WorkLogBloc(this._firestoreService) : super(WorkLogInitial()) {
    on<LoadWorkLogs>((event, emit) async {
      emit(WorkLogLoading());
      await emit.forEach(
        _firestoreService.getWorkLogs(event.date),
        onData: (logs) => WorkLogLoaded(logs),
        onError: (_, _) => const WorkLogError('Ошибка загрузки данных'),
      );
    });

    on<AddWorkLog>((event, emit) async {
      try {
        await _firestoreService.addWorkLog(
          event.date,
          event.hours,
          event.comment,
        );
      } catch (e) {
        WorkLogError(
          'Ошибка при сохранении в Firebase: $e',
        ); // Можно обработать ошибку добавления, если нужно
      }
    });
  }
}
