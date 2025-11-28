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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final rate = await _settingsService.getHourSalary();
    final lunch = await _settingsService.getLunchSettings();

    setState(() {
      _rateController.text = rate.toString();
      _lunchDurationController.text = lunch['duration'].toString();
    });
  }

  Future<void> _saveSettings() async {
    final rate = double.tryParse(_rateController.text) ?? 0.0;
    //final limit = double.tryParse(_limitController.text) ?? 1680.0;
    final lunchDur = int.tryParse(_lunchDurationController.text) ?? 0;

    await _settingsService.setHourSalary(rate);
    await _settingsService.setLunchSettings(lunchDur, 0);

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
