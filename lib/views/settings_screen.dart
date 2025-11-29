import 'package:flutter/material.dart';
import '../services/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();

  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _lunchDurationController =
      TextEditingController();
  bool _salaryIncreased = false;
  TimeOfDay? _nightStartTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final rate = await _settingsService.getHourSalary();
    final lunch = await _settingsService.getLunchSettings();
    final isSalaryIncreased = await _settingsService.getIsSalaryIncreased();
    final nightTimeStart = await _settingsService.getnightTime();
    setState(() {
      _rateController.text = rate.toString();
      _lunchDurationController.text = lunch['duration'].toString();
      _salaryIncreased = isSalaryIncreased;
      if (nightTimeStart != null) {
        final parts = nightTimeStart.split(':');
        _nightStartTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } else {
        _nightStartTime = null;
      }
    });
  }

  Future<void> _pickOvertimeTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _nightStartTime ?? const TimeOfDay(hour: 22, minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (picked != null) {
      setState(() {
        _nightStartTime = picked;
      });
    }
  }

  Future<void> _saveSettings() async {
    final rate = double.tryParse(_rateController.text) ?? 0.0;
    //final limit = double.tryParse(_limitController.text) ?? 1680.0;
    final lunchDur = int.tryParse(_lunchDurationController.text) ?? 0;

    await _settingsService.setHourSalary(rate);
    await _settingsService.setLunchSettings(lunchDur, 0);
    await _settingsService.setIsSalaryIncreased(_salaryIncreased);
    if (_salaryIncreased && _nightStartTime != null) {
      final timeString =
          '${_nightStartTime!.hour.toString().padLeft(2, '0')}:${_nightStartTime!.minute.toString().padLeft(2, '0')}';
      await _settingsService.setnightTime(timeString);
    } else {
      await _settingsService.setnightTime(null);
    }
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Настройки сохранены')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Зарплата в час (Йен)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _limitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Лимит часов в неделю',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lunchDurationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Длина обеда (минут)',
              ),
            ),

            SwitchListTile(
              title: const Text('Учитывать повышенную ставку'),
              subtitle: const Text('Для ночных смен или переработки'),
              value: _salaryIncreased,
              onChanged: (bool value) {
                setState(() {
                  _salaryIncreased = value;
                  if (!value) _nightStartTime = null;
                });
              },
            ),
            if (_salaryIncreased)
              ListTile(
                title: const Text('Начало повышенной ставки'),
                subtitle: Text(
                  _nightStartTime?.format(context) ?? 'Выберите время',
                ),
                trailing: const Icon(
                  Icons.access_time,
                  color: Color.fromARGB(255, 97, 11, 178),
                ),
                onTap: _pickOvertimeTime,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
