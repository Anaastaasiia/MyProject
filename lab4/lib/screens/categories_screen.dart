import 'package:flutter/material.dart';
import 'profile_screen.dart'; 
import '../app_colors.dart'; 
import '../services/local_storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Структура для нотатки
class Note {
  final String title;
  final String description;
  final String date;
  final String time;

  Note({required this.title, required this.description, required this.date, required this.time});
}

class CategoriesScreen extends StatelessWidget {
  // Список нотаток
  final List<Note> notes = [
    Note(
      title: 'Лекція з математики',
      description: 'Зустріч з викладачем математики, пояснення матеріалу',
      date: 'Понеділок',
      time: '10:00',
    ),
    Note(
      title: 'Інформатика',
      description: 'Практичне заняття з програмування, мова Python',
      date: 'Вівторок',
      time: '14:00',
    ),
    Note(
      title: 'Фізика',
      description: 'Теоретичне заняття з фізики, закріплення матеріалу',
      date: 'Середа',
      time: '9:00',
    ),
    Note(
      title: 'Англійська мова',
      description: 'Групова робота та обговорення граматики',
      date: 'Четвер',
      time: '12:00',
    ),
    Note(
      title: 'Музика',
      description: 'Урок музики, теорія та практика',
      date: 'П’ятниця',
      time: '13:00',
    ),
  ];

  final LocalStorageService _localStorageService = LocalStorageServiceImpl();

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _localStorageService.saveUserData('', '', '');
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            },
            child: Text('Log out'),
          ),
        ],
      ),
    );
  }

  void _listenToConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are offline. Some features may be limited.')),
        );
      }
    });
  }

  // Перехід до екрану з деталями нотатки
  void _viewNoteDetails(BuildContext context, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailsScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listenToConnectivity(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes', style: TextStyle(color: AppColors.whiteColor)), 
        backgroundColor: const Color.fromARGB(255, 44, 63, 57), 
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.whiteColor), 
            onPressed: () => _showLogoutDialog(context), 
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Text('${notes[index].date} at ${notes[index].time}'),
            onTap: () => _viewNoteDetails(context, notes[index]),  // Перехід до екрану детального перегляду нотатки
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
        child: Icon(Icons.person), 
        tooltip: 'Go to Profile',
      ),
    );
  }
}

// Екран деталей нотатки
class NoteDetailsScreen extends StatelessWidget {
  final Note note;

  NoteDetailsScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title, style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color.fromARGB(255, 50, 71, 66),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              note.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${note.date} | Time: ${note.time}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              note.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Логіка для позначення нотатки як завершеної чи інші дії
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Note marked as complete!')),
                );
              },
              child: Text('Mark as Complete', style: TextStyle(color: AppColors.whiteColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(94, 46, 73, 75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
