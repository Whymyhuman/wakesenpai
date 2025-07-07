import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/viewmodels/alarm_viewmodel.dart';
import 'package:wake_senpai/views/alarm_edit_screen.dart';

class AlarmListScreen extends StatelessWidget {
  const AlarmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Alarm'),
      ),
      body: Consumer<AlarmViewModel>(
        builder: (context, alarmViewModel, child) {
          if (alarmViewModel.alarms.isEmpty) {
            return const Center(
              child: Text('Belum ada alarm. Tambahkan alarm baru!'),
            );
          }
          return ListView.builder(
            itemCount: alarmViewModel.alarms.length,
            itemBuilder: (context, index) {
              final alarm = alarmViewModel.alarms[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    '${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    alarm.isRepeatingDaily ? 'Setiap Hari' : 'Satu Kali',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: alarm.isActive,
                        onChanged: (value) {
                          alarmViewModel.toggleAlarm(alarm);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlarmEditScreen(alarm: alarm),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          alarmViewModel.deleteAlarm(alarm.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmEditScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


