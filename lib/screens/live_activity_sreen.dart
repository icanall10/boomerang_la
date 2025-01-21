import 'package:boomerang/classes/foreground_service_helper.dart';
import 'package:flutter/material.dart';

class LiveActivityScreen extends StatefulWidget {
  const LiveActivityScreen({ Key? key }) : super(key: key);

  @override
  State createState() => _LiveActivitySreenState();
}

class _LiveActivitySreenState extends State<LiveActivityScreen> {
  String? _currentActivityId;
  int _counter = 0;

  Future<void> _start() async {
    final id = await LiveActivityHelper.startActivity();
    if (id != null) {
      setState(() {
        _currentActivityId = id;
        _counter = 0;
      });
    }
  }

  Future<void> _update() async {
    if (_currentActivityId != null) {
      setState(() {
        _counter += 1;
      });
      await LiveActivityHelper.updateActivity(_currentActivityId!, _counter);
    }
  }

  Future<void> _end() async {
    if (_currentActivityId != null) {
      await LiveActivityHelper.endActivity(_currentActivityId!);
      setState(() {
        _currentActivityId = null;
        _counter = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLiveActivity = _currentActivityId != null;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Live Activity Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(hasLiveActivity
                  ? 'Activity ID: $_currentActivityId\nCounter: $_counter'
                  : 'Нет активного Live Activity'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: hasLiveActivity ? null : _start,
                child: const Text('Запустить Live Activity'),
              ),
              ElevatedButton(
                onPressed: hasLiveActivity ? _update : null,
                child: const Text('Увеличить счётчик'),
              ),
              ElevatedButton(
                onPressed: hasLiveActivity ? _end : null,
                child: const Text('Остановить Live Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}