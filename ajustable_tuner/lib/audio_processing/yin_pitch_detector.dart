import 'dart:math';
import 'dart:typed_data';

class YinPitchDetector {
  final int bufferSize;
  final int sampleRate;
  final double threshold;
  final double minFrequency;
  final double maxFrequency;
  final int _maxSearchRange;

  late Int16List _audioPcmBuffer;
  final Float32List _hannWindowBuffer;
  final Float32List _yinBuffer;

  YinPitchDetector({
    this.bufferSize = 9600,
    this.sampleRate = 48000,
    this.minFrequency = 32.7,
    this.maxFrequency = 2093.0,
    this.threshold = 0.1,
  })  : _hannWindowBuffer = Float32List(bufferSize),
        _maxSearchRange = sampleRate ~/ minFrequency,
        _yinBuffer = Float32List(sampleRate ~/ minFrequency) {
    for (var i = 0; i < bufferSize; i++) {
      _hannWindowBuffer[i] = (0.5 - 0.5 * cos(2.0 * pi * i / (bufferSize - 1)));
    }
  }

  double detectPitch(Int16List audioPcmArray) {
    _audioPcmBuffer = audioPcmArray;

    _yinBuffer[0] = 1.0;
    var runningSum = 0.0;
    var tauEstimate = -1;
    var crossThreshold = false;

    for (var tau = 1; tau < _maxSearchRange; tau++) {
      _yinBuffer[tau] = 0.0;
      for (var j = 0; j < bufferSize ~/ 2; j++) {
        var delta =
            _getModulatedAudioValue(j) - _getModulatedAudioValue(j + tau);
        _yinBuffer[tau] += delta * delta;
      }
      runningSum += _yinBuffer[tau];
      _yinBuffer[tau] *= tau / runningSum;

      if (crossThreshold) {
        if (_yinBuffer[tau - 1] <= _yinBuffer[tau]) {
          tauEstimate = tau - 1;
          break;
        }
      } else if (_yinBuffer[tau] < threshold) {
        crossThreshold = true;
      }
    }

    if (tauEstimate != -1) {
      var frequency = sampleRate / _parabolicInterpolation(tauEstimate);
      return frequency <= maxFrequency ? frequency : -1.0;
    }
    return -1.0;
  }

  double _getModulatedAudioValue(int j) {
    return _audioPcmBuffer[j] * _hannWindowBuffer[j];
  }

  double _parabolicInterpolation(int tauEstimate) {
    var x0 = (tauEstimate < 1) ? tauEstimate : tauEstimate - 1;
    var x2 =
        (tauEstimate + 1 < _maxSearchRange) ? tauEstimate + 1 : tauEstimate;

    if (x0 == tauEstimate) {
      return (_yinBuffer[tauEstimate] <= _yinBuffer[x2]) ? 0 : x2.toDouble();
    } else if (x2 == tauEstimate) {
      return (_yinBuffer[tauEstimate] <= _yinBuffer[x0])
          ? tauEstimate.toDouble()
          : x0.toDouble();
    } else {
      var s0 = _yinBuffer[x0];
      var s1 = _yinBuffer[tauEstimate];
      var s2 = _yinBuffer[x2];
      return tauEstimate + (s2 - s0) / (2 * (2 * s1 - s2 - s0));
    }
  }
}
