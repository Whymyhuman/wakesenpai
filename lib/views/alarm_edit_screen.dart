
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wake_senpai/models/alarm.dart';
import 'package:wake_senpai/viewmodels/alarm_viewmodel.dart';

class AlarmEditScreen extends StatefulWidget {
  final Alarm? alarm;

  const AlarmEditScreen({super.key, this.alarm});

  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  late TimeOfDay _selectedTime;
  late bool _isRepeatingDaily;
  late String _selectedSound;
  late String _selectedChallengeType;

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _selectedTime = TimeOfDay(hour: widget.alarm!.time.hour, minute: widget.alarm!.time.minute);
      _isRepeatingDaily = widget.alarm!.isRepeatingDaily;
      _selectedSound = widget.alarm!.soundPath;
      _selectedChallengeType = widget.alarm!.challengeType;
    } else {
      _selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
      _isRepeatingDaily = false;
      _selectedSound = 'default.mp3'; // Default sound
      _selectedChallengeType = 'puzzle'; // Default challenge
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _selectedTime.hour, minute: _selectedTime.minute),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = TimeOfDay(hour: picked.hour, minute: picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarm == null ? 'Tambah Alarm' : 'Edit Alarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: const Text('Waktu Alarm'),
              subtitle: Text(
                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () => _pickTime(context),
            ),
            SwitchListTile(
              title: const Text('Ulangi Setiap Hari'),
              value: _isRepeatingDaily,
              onChanged: (bool value) {
                setState(() {
                  _isRepeatingDaily = value;
                });
              },
            ),
            ListTile(
              title: const Text('Suara Alarm'),
              subtitle: Text(_selectedSound),
              trailing: const Icon(Icons.audiotrack),
              onTap: () { /* TODO: Implement sound picker */ },
            ),
            ListTile(
              title: const Text('Jenis Tantangan'),
              subtitle: Text(_selectedChallengeType),
              trailing: const Icon(Icons.gamepad),
              onTap: () { /* TODO: Implement challenge type picker */ },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final alarmViewModel = Provider.of<AlarmViewModel>(context, listen: false);
                  if (widget.alarm == null) {
                    alarmViewModel.addAlarm(
                      _selectedTime,
                      _isRepeatingDaily,
                      _selectedSound,
                      _selectedChallengeType,
                    );
                  } else {
                    final updatedAlarm = Alarm(
                      id: widget.alarm!.id,
                      time: _selectedTime,
                      isActive: widget.alarm!.isActive,
                      isRepeatingDaily: _isRepeatingDaily,
                      soundPath: _selectedSound,
                      challengeType: _selectedChallengeType,
                    );
                    alarmViewModel.updateAlarm(updatedAlarm);
                  }
                  Navigator.pop(context);
                },
                child: Text(widget.alarm == null ? 'Tambah Alarm' : 'Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


