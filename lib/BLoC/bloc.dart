import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/firestore.dart';
import 'event.dart';
import 'state.dart';

class WorkLogBloc extends Bloc<WorkLogEvent, WorkLogState> {
  final FirestoreService _firestoreService;

  WorkLogBloc(this._firestoreService) : super(WorkLogInitial()) {
    // Обработчик события: "Загрузи смены"
    on<LoadWorkLogs>((event, emit) async {
      emit(WorkLogLoading()); // Сразу говорим UI: "Покажи спиннер"

      // Блок подписывается на Stream из сервиса
      // emit.forEach - это спец. метод BLoC для работы с потоками данных (Stream)
      await emit.forEach(
        _firestoreService.getWorkLogs(event.date),
        onData: (logs) =>
            WorkLogLoaded(logs), // Если пришли данные -> состояние Loaded
        onError: (_, __) => const WorkLogError('Ошибка загрузки данных'),
      );
    });

    // Обработчик события: "Добавь смену"
    on<AddWorkLog>((event, emit) async {
      try {
        await _firestoreService.addWorkLog(
          event.date,
          event.hours,
          event.comment,
        );
        // После добавления нам не нужно ничего менять вручную,
        // так как stream выше (в LoadWorkLogs) сам увидит обновление в базе
      } catch (e) {
        // Можно обработать ошибку добавления, если нужно
      }
    });
  }
}
