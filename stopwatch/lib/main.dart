import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  bool _isRunning = false;
  int _milliseconds = 0;
  late Timer _timer;
  final List<String> _laps = [];

  void _startStop() {
    if (_isRunning) {
      _timer.cancel();
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          _milliseconds += 10;
        });
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _reset() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
      _milliseconds = 0;
      _laps.clear();
    });
  }

  void _addLap() {
    if (_isRunning) {
      setState(() {
        _laps.insert(0, _formatTime(_milliseconds));
      });
    }
  }

  String _formatTime(int milliseconds) {
    int centiseconds = (milliseconds ~/ 10) % 100;
    int seconds = (milliseconds ~/ 1000) % 60;
    int minutes = (milliseconds ~/ 60000) % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '${centiseconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display Time
          Text(
            _formatTime(_milliseconds),
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _startStop,
                child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _reset,
                backgroundColor: Colors.red,
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _addLap,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.flag),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Laps List
          Expanded(
            child: ListView.builder(
              itemCount: _laps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text('#${index + 1}'),
                  title: Text(_laps[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
