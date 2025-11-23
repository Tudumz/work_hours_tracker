import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:developer';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // current date
  DateTime _focusedDay = DateTime.now();
  // chosen day. can be null
  DateTime? _selectedDay = DateTime.now();

  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  void _showAddShiftDialog() {
    _hoursController.clear();
    _commentController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Смена на ${_selectedDay.toString().split(' ')[0]}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // hours input
              TextField(
                controller: _hoursController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                decoration: const InputDecoration(
                  labelText: 'Часы',
                  hintText: 'Например: 8.5',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 10),
              // comment input
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Комментарий (опционально)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                ),
              ),
            ],
          ),
          actions: [
            // cencel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),

            ElevatedButton(
              onPressed: () {
                log(
                  'Сохраняем: ${_hoursController.text} часов. Коммент: ${_commentController.text}',
                );
                Navigator.pop(context);
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
    // Важно! Удаляем контроллеры, когда экран закрывается, чтобы не забивать память
    _hoursController.dispose();
    _commentController.dispose();
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
            focusedDay: _focusedDay,

            //style
            // Стиль календаря
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },

            headerStyle: const HeaderStyle(
              // change format button
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),

          const SizedBox(height: 20),

          // test
          /*Text(
            _selectedDay != null
              ? "Выбрано: ${_selectedDay.toString().split(' ')[0]}"
                : "Выберите дату",
            style: const TextStyle(fontSize: 18),
          ),*/
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddShiftDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
