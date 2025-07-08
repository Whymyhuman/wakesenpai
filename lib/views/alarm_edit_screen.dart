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
  late TimeOfDayCustom _selectedTime;
  late bool _isRepeatingDaily;
  late String _selectedSound;
  late String _selectedChallengeType;

  final List<String> _soundOptions = [
    'default.mp3',
    'senpai_bangun_1.mp3',
    'senpai_bangun_2.mp3',
  ];

  final List<String> _challengeOptions = [
    'puzzle',
    'gesture',
    'none',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _selectedTime = TimeOfDayCustom(
        hour: widget.alarm!.time.hour, 
        minute: widget.alarm!.time.minute
      );
      _isRepeatingDaily = widget.alarm!.isRepeatingDaily;
      _selectedSound = widget.alarm!.soundPath;
      _selectedChallengeType = widget.alarm!.challengeType;
    } else {
      final now = DateTime.now();
      _selectedTime = TimeOfDayCustom(hour: now.hour, minute: now.minute);
      _isRepeatingDaily = false;
      _selectedSound = _soundOptions.first;
      _selectedChallengeType = _challengeOptions.first;
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _selectedTime.hour, minute: _selectedTime.minute),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = TimeOfDayCustom(hour: picked.hour, minute: picked.minute);
      });
    }
  }

  void _saveAlarm() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarm == null ? 'Tambah Alarm' : 'Edit Alarm'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: ListTile(
                title: const Text('Waktu Alarm'),
                subtitle: Text(
                  _selectedTime.toString(),
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(context),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: SwitchListTile(
                title: const Text('Ulangi Setiap Hari'),
                value: _isRepeatingDaily,
                onChanged: (bool value) {
                  setState(() {
                    _isRepeatingDaily = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Suara Alarm'),
                subtitle: Text(_selectedSound),
                trailing: const Icon(Icons.audiotrack),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pilih Suara'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _soundOptions.map((sound) => 
                          RadioListTile<String>(
                            title: Text(sound),
                            value: sound,
                            groupValue: _selectedSound,
                            onChanged: (value) {
                              setState(() {
                                _selectedSound = value!;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Jenis Tantangan'),
                subtitle: Text(_selectedChallengeType),
                trailing: const Icon(Icons.gamepad),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pilih Tantangan'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _challengeOptions.map((challenge) => 
                          RadioListTile<String>(
                            title: Text(challenge.toUpperCase()),
                            value: challenge,
                            groupValue: _selectedChallengeType,
                            onChanged: (value) {
                              setState(() {
                                _selectedChallengeType = value!;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAlarm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.alarm == null ? 'Tambah Alarm' : 'Simpan Perubahan',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}