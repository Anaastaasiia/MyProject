class Schedule {
  final String subject;
  final String teacher;
  final String time;
  final String day;

  Schedule({
    required this.subject,
    required this.teacher,
    required this.time,
    required this.day,
  });

  // Конвертація об'єкта в Map для збереження у SharedPreferences
  Map<String, String> toMap() {
    return {
      'subject': subject,
      'teacher': teacher,
      'time': time,
      'day': day,
    };
  }

  // Конвертація Map в об'єкт Schedule
  static Schedule fromMap(Map<String, dynamic> map) {
    return Schedule(
      subject: map['subject'],
      teacher: map['teacher'],
      time: map['time'],
      day: map['day'],
    );
  }
}
