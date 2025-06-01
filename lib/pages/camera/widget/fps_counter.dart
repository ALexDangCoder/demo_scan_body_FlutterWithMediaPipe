import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FpsCounter extends StatefulWidget {
  const FpsCounter({Key? key}) : super(key: key);

  @override
  State<FpsCounter> createState() => _FpsCounterState();
}

class _FpsCounterState extends State<FpsCounter> with SingleTickerProviderStateMixin {
  int _frames = 0;
  double _fps = 0;
  late Ticker _ticker;
  late DateTime _lastTime;

  @override
  void initState() {
    super.initState();
    _lastTime = DateTime.now();
    _ticker = this.createTicker((_) {
      _frames++;
      final now = DateTime.now();
      final diff = now.difference(_lastTime).inMilliseconds;
      if (diff >= 1000) {
        setState(() {
          _fps = _frames * 1000 / diff;
          _frames = 0;
          _lastTime = now;
        });
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 20,
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(8),
        child: Text(
          'FPS: ${_fps.toStringAsFixed(1)}',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
} 