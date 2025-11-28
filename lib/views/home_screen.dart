import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../BLoC/bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenShow();
}

class _HomeScreenShow extends State<HomeScreen> {
  DateTime today = DateTime.now();
  DateTime? selectedday = DateTime.now();
  final TextEditingController hourseinput = TextEditingController();
  final TextEditingController comm = TextEditingController();

  @override
  void AddDialog() {
    hourseinput.clear();
    comm.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Смена на ${selectedday.toString().split(' ')[0]}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: hourseinput,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Часы',
                  hintText: '8.5',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: comm,
                decoration: const InputDecoration(
                  labelText: 'Комментарий',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                ),
              ),
            ],
          ),
          actions: [
            // cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),

            ElevatedButton(
              onPressed: () async {
                if (hourseinput.text.isEmpty) return;
                final hours =
                    double.tryParse(hourseinput.text.replaceAll(',', '.')) ??
                    0.0;
                if (selectedday != null) {
                  context.read<WorkLogBloc>().add(
                    AddWorkLog(
                      date: selectedday!,
                      hours: hours,
                      comment: comm.text,
                    ),
                  );
                  log('Успешно сохранено!');
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    hourseinput.dispose();
    comm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Hours Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: today,

            //style
            // Стиль календаря
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(selectedday, day),
            onDaySelected: (chosenday, focusedDay) {
              if (!isSameDay(selectedday, chosenday)) {
                setState(() {
                  selectedday = chosenday;
                  today = focusedDay;
                });
                context.read<WorkLogBloc>().add(LoadWorkLogs(chosenday));
              }
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),

          // выывод списка смен
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<WorkLogBloc, WorkLogState>(
              builder: (context, state) {
                if (state is WorkLogLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WorkLogError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is WorkLogLoaded) {
                  if (state.logs.isEmpty) {
                    return const Center(child: Text('Нет записей'));
                  }
                  return ListView.builder(
                    itemCount: state.logs.length,
                    itemBuilder: (context, index) {
                      final shift = state.logs[index];
                      return ListTile(
                        leading: const Icon(Icons.work, color: Colors.purple),
                        title: Text('${shift.hours} ч.'),
                        subtitle: Text(shift.comment ?? ''),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: AddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
