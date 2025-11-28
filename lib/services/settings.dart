//import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String hourSalary = 'hourly_salary';
  static const String nightHourSalary = 'night_hourly_salary';
  static const double weekLimit = 1680.0; //minutes
  static const String lunch = 'lunch_duration_minutes';
  static const String lunchCost = 'lunch_cost';
  static const String checkIsSalaryIncreased = 'is_salary_increased_at_night';
  static const String nightTime = 'night_salary_start_time';

  Future<void> setHourSalary(double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(hourSalary, rate);
  }

  Future<double> getHourSalary() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(hourSalary) ?? 1250.0;
  }

  Future<void> setnightHourSalary(double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(nightHourSalary, rate);
  }

  Future<double> getnightHourSalary() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(nightHourSalary) ?? 1350.0;
  }

  Future<void> setLunchSettings(int durationMinutes, double cost) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lunch, durationMinutes);
    await prefs.setDouble(lunchCost, cost);
  }

  Future<void> setIsRateIncreased(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(checkIsSalaryIncreased, value);
  }

  Future<bool> getIsRateIncreased() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(checkIsSalaryIncreased) ?? false;
  }

  Future<void> setnightTime(String? time) async {
    final prefs = await SharedPreferences.getInstance();
    if (time != null) {
      await prefs.setString(nightTime, time);
    } else {
      await prefs.remove(nightTime);
    }
  }

  Future<String?> getnightTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nightTime);
  }

  Future<Map<String, dynamic>> getLunchSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'duration': prefs.getInt(lunch) ?? 60,
      'cost': prefs.getDouble(lunchCost) ?? 0.0,
    };
  }
}
