import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getSchedules();
  Future<void> addSchedule(Schedule schedule);
  Future<void> deleteSchedule(String time, String day);
}

class LocalScheduleRepository implements ScheduleRepository {
  static const String schedulesKey = 'schedules';

  @override
  Future<List<Schedule>> getSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final schedulesData = prefs.getString(schedulesKey);

    if (schedulesData != null) {
      final List<dynamic> schedulesList = json.decode(schedulesData);
      return schedulesList.map((map) => Schedule.fromMap(map)).toList();
    }
    return [];
  }

  @override
  Future<void> addSchedule(Schedule schedule) async {
    final prefs = await SharedPreferences.getInstance();
    List<Schedule> schedules = await getSchedules();
    schedules.add(schedule);

    final List<Map<String, String>> schedulesList =
        schedules.map((s) => s.toMap()).toList();
    await prefs.setString(schedulesKey, json.encode(schedulesList));
  }

  @override
  Future<void> deleteSchedule(String time, String day) async {
    final prefs = await SharedPreferences.getInstance();
    List<Schedule> schedules = await getSchedules();
    schedules.removeWhere((s) => s.time == time && s.day == day);

    final List<Map<String, String>> schedulesList =
        schedules.map((s) => s.toMap()).toList();
    await prefs.setString(schedulesKey, json.encode(schedulesList));
  }
}
