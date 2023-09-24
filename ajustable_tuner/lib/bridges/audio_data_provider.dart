import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../audio_processing/volume_measure.dart';
import '../audio_processing/yin_pitch_detector.dart';
import '../model/audio_data.dart';
import '../utils/list_converter.dart';

AudioData topLevelProcessAudioStream(Uint8List audioByteStream) {
  var int16Representation = uInt8ListToInt16List(audioByteStream);
  double frequency = YinPitchDetector().detectPitch(int16Representation);
  double intensity = VolumeMeasure.computeVolume(int16Representation);
  return AudioData(intensity, frequency);
}

class AudioDataProvider {
  final YinPitchDetector _pitchDetector = YinPitchDetector();
  static const EventChannel _audioStreamChannel = EventChannel('com.matheusdev.adjustable_tuner/audio_stream');
  static const EventChannel _audioProcessingChannel = EventChannel('com.matheusdev.adjustable_tuner/audio_processing');

  final bool useIsolates;
  final bool useTopLevelFunction;
  final bool flutterProcessing;

  final StreamController<AudioData> _audioStreamController = StreamController<AudioData>();
  Stream<AudioData> get audioStream => _audioStreamController.stream;

  AudioDataProvider({this.flutterProcessing = false, this.useIsolates = false, this.useTopLevelFunction = true}) {
    if(flutterProcessing) {
      _streamListenerInitializing();
    } else {
      _nativeProcessingListenerInitializing();
    }
  }

  void _streamListenerInitializing() {
    _audioStreamChannel.receiveBroadcastStream().listen((event) async {
      try {
        var audioByteStream = Uint8List.fromList(event);
        AudioData audioData;

        //Start measuring time
        final stopwatch = Stopwatch()
          ..start();

        if (useIsolates) {
          audioData =
          await compute(topLevelProcessAudioStream, audioByteStream);
        } else if (useTopLevelFunction) {
          audioData = topLevelProcessAudioStream(audioByteStream);
        } else {
          audioData = _processAudioStream(audioByteStream);
        }

        //End measuring time
        stopwatch.stop();
        final elapsedTimeMs = stopwatch.elapsedMilliseconds;
        print('frequency ${audioData.frequency} - intensity ${audioData.intensity} - taken: $elapsedTimeMs ms');

        _audioStreamController.sink.add(audioData);
      } catch (error) {
        _audioStreamController.sink.addError(error);
      }
    });
  }

  void _nativeProcessingListenerInitializing() {
    _audioProcessingChannel.receiveBroadcastStream().listen((dynamic event) {
      var audioData = AudioData(event['intensity'], event['frequency']);
      _audioStreamController.sink.add(audioData);
    },
        onError: (dynamic error) {
          _audioStreamController.sink.addError(error);
        }
    );
  }

  AudioData _processAudioStream(Uint8List audioByteStream) {
    var int16Representation = uInt8ListToInt16List(audioByteStream);
    double frequency = _pitchDetector.detectPitch(int16Representation);
    double intensity = VolumeMeasure.computeVolume(int16Representation);
    return AudioData(intensity, frequency);
  }

  void dispose() {
    _audioStreamController.close();
  }
}
