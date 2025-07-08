import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alarm.dart';
import '../viewmodels/alarm_viewmodel.dart';

class AlarmEditScreen extends StatefulWidget {
  final Alarm? alarm;

  const AlarmEditScreen({super.key, this.alarm});

  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isRepeatingDaily;
  late String _selectedSound;
  late String _selectedChallengeType;

  final List<String> _soundOptions = [
    'default.mp3',
    'senpai_bangun_1.mp3',
    'senpai_bangun_2.mp3',
  ];

  final List<String> _challengeOptions = [
    'none',
    'puzzle',
    'gesture',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _selectedHour = widget.alarm!.hour;
      _selectedMinute = widget.alarm!.minute;
      _isRepeatingDaily = widget.alarm!.isRepeatingDaily;
      _selectedSound = widget.alarm!.soundPath;
      _selectedChallengeType = widget.alarm!.challengeType;
    } else {
      final now = DateTime.now();
      _selectedHour = now.hour;
      _selectedMinute = now.minute;
      _isRepeatingDaily = false;
      _selectedSound = _soundOptions.first;
      _selectedChallengeType = _challengeOptions.first;
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
    );
    if (picked != null) {
      setState(() {
        _selectedHour = picked.hour;
        _selectedMinute = picked.minute;
      });
    }
  }

  void _saveAlarm() {
    final viewModel = Provider.of<AlarmViewModel>(context, listen: false);
    
    if (widget.alarm == null) {
      viewModel.addAlarm(
        hour: _selectedHour,
        minute: _selectedMinute,
        isRepeatingDaily: _isRepeatingDaily,
        soundPath: _selectedSound,
        challengeType: _selectedChallengeType,
      );
    } else {
      final updatedAlarm = Alarm(
        id: widget.alarm!.id,
        hour: _selectedHour,
        minute: _selectedMinute,
        isActive: widget.alarm!.isActive,
        isRepeatingDaily: _isRepeatingDaily,
        soundPath: _selectedSound,
        challengeType: _selectedChallengeType,
      );
      viewModel.updateAlarm(updatedAlarm);
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
          children: [
            Card(
              child: ListTile(
                title: const Text('Waktu Alarm'),
                subtitle: Text(
                  '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: SwitchListTile(
                title: const Text('Ulangi Setiap Hari'),
                value: _isRepeatingDaily,
                onChanged: (value) {
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
                onTap: () => _showSoundDialog(),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Jenis Tantangan'),
                subtitle: Text(_selectedChallengeType.toUpperCase()),
                trailing: const Icon(Icons.gamepad),
                onTap: () => _showChallengeDialog(),
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

  void _showSoundDialog() {
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
  }

  void _showChallengeDialog() {
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
  }
}