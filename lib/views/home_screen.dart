import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/firestore.dart';
import '../models/work_log.dart';
import 'dart:developer';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenShow();
}

class _HomeScreenShow extends State<HomeScreen> {
  DateTime today = DateTime.now();
  DateTime? selectedday = DateTime.now();
  final FirestoreService firestore_serv = FirestoreService();
  final TextEditingController hourseinput = TextEditingController();
  final TextEditingController comm = TextEditingController();

  void _showAddShiftDialog() {
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
              // hours input
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
              // comment input
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

                try {
                  if (selectedday != null) {
                    await FirestoreService().addWorkLog(
                      selectedday!,
                      hours,
                      comm.text,
                    );
                    log('Успешно сохранено в Firebase!');
                  }
                } catch (e) {
                  log('Ошибка при сохранении в Firebase: $e');
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
            // always
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
            child: StreamBuilder<List<WorkLog>>(
              stream: firestore_serv.getWorkLogs(selectedday ?? DateTime.now()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Ошибка загрузки данных'));
                }

                // кружок загрузки
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final shifts = snapshot.data ?? [];
                if (shifts.isEmpty) {
                  return const Center(
                    child: Text(
                      'Нет записей за этот день',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: shifts.length,
                  itemBuilder: (context, index) {
                    final shift = shifts[index];
                    return ListTile(
                      leading: const Icon(Icons.work),
                      title: Text('${shift.hours} ч. работы'),
                      subtitle: Text(shift.comment ?? 'Без комментария'),
                      trailing: Text(
                        'ID: ${shift.id.substring(0, 4)}...', // Показываем ID документа
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddShiftDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
