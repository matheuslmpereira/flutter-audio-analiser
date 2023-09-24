import 'package:flutter/services.dart';

class NativeMethodCaller {
  static const MethodChannel _methodChannel = MethodChannel('com.matheusdev.adjustable_tuner/native_methods');

  Future<void> startCounter() async {
    await _methodChannel.invokeMethod('startRecord');
  }

  Future<void> pauseCounter() async {
    await _methodChannel.invokeMethod('pauseRecord');
  }
}
