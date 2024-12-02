import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../repository/schedule_repository.dart';
import '../widgets/custom_text_field.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final LocalScheduleRepository scheduleRepository = LocalScheduleRepository();
  List<Schedule> schedules = [];

  final _subjectController = TextEditingController();
  final _teacherController = TextEditingController();
  final _timeController = TextEditingController();
  final _dayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSchedules();  // Завантаження розкладу при запуску
  }

  // Завантаження існуючих записів з локального сховища
  void _loadSchedules() async {
    List<Schedule> loadedSchedules = await scheduleRepository.getSchedules();
    setState(() {
      schedules = loadedSchedules;
    });
  }

  // Додавання нового запису
  void _addSchedule() async {
    if (_subjectController.text.isEmpty ||
        _teacherController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _dayController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заповніть всі поля')),
      );
      return;
    }

    Schedule newSchedule = Schedule(
      subject: _subjectController.text,
      teacher: _teacherController.text,
      time: _timeController.text,
      day: _dayController.text,
    );

    await scheduleRepository.addSchedule(newSchedule);
    _loadSchedules();
    _clearFields();
  }

  // Очищення полів введення
  void _clearFields() {
    _subjectController.clear();
    _teacherController.clear();
    _timeController.clear();
    _dayController.clear();
  }

  // Видалення запису
  void _deleteSchedule(Schedule schedule) async {
    await scheduleRepository.deleteSchedule(schedule.time, schedule.day);
    _loadSchedules();
  }

  // Редагування запису
  void _editSchedule(Schedule schedule) {
    _subjectController.text = schedule.subject;
    _teacherController.text = schedule.teacher;
    _timeController.text = schedule.time;
    _dayController.text = schedule.day;

    // Показ діалогу для редагування
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редагувати розклад'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: _subjectController, labelText: 'Предмет'),
              CustomTextField(controller: _teacherController, labelText: 'Викладач'),
              CustomTextField(controller: _timeController, labelText: 'Час'),
              CustomTextField(controller: _dayController, labelText: 'День'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Видалення старого запису та додавання оновленого
                await scheduleRepository.deleteSchedule(schedule.time, schedule.day);
                _addSchedule();
                Navigator.pop(context);
              },
              child: Text('Зберегти'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Відмінити'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Розклад')),
      body: Column(
        children: [
          // Відображення списку розкладу
          Expanded(
            child: schedules.isEmpty
                ? Center(child: Text('Розклад порожній'))
                : ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      return Card(
                        child: ListTile(
                          title: Text('${schedule.subject} (${schedule.time})'),
                          subtitle: Text('${schedule.teacher}, ${schedule.day}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editSchedule(schedule),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteSchedule(schedule),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Поля введення для додавання нового запису
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(controller: _subjectController, labelText: 'Предмет'),
                SizedBox(height: 8),
                CustomTextField(controller: _teacherController, labelText: 'Викладач'),
                SizedBox(height: 8),
                CustomTextField(controller: _timeController, labelText: 'Час'),
                SizedBox(height: 8),
                CustomTextField(controller: _dayController, labelText: 'День'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addSchedule,
                  child: Text('Додати/Оновити'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
