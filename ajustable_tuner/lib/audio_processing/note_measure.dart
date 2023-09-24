import 'dart:math';

import '../model/note_display.dart';
import '../model/note_symbol.dart';

class NoteMeasure {
  static final NoteMeasure _instance = NoteMeasure._internal();
  static const int numberOfHarmonicNotes = 12;
  static const double _fundamentalFrequencyC = 16.352;
  static const double _tolerance = 0.09;
  static final double _noteInterval = pow(2.0, 1.0 / numberOfHarmonicNotes).toDouble();
  static final double maxHarmonicFrequencyMatch = (_fundamentalFrequencyC * 2.0) / pow(_noteInterval, 1/2);
  final List<double> _baseFrequencyList = [];

  factory NoteMeasure() {
    return _instance;
  }

  NoteMeasure._internal() {
    _initNotes();
  }

  void _initNotes() {
    if (_baseFrequencyList.isEmpty) {
      _baseFrequencyList.add(_fundamentalFrequencyC);
      for (int i = 1; i < numberOfHarmonicNotes; i++) {
        _baseFrequencyList.add(_baseFrequencyList[i - 1] * _noteInterval);
      }
    }
  }

  NoteDisplay closestNote(double originalFrequency) {
    int closestIndex = 0;
    double closestFrequency = 0;
    int harmonic = 0;
    double fundamentalFrequency = originalFrequency;

    while (fundamentalFrequency > maxHarmonicFrequencyMatch) {
      fundamentalFrequency /= 2.0;
      harmonic++;
    }

    double minDist = double.maxFinite;

    for (int i = 0; i < numberOfHarmonicNotes; i++) {
      double dist = (fundamentalFrequency - _baseFrequencyList[i]).abs();
      if (dist < minDist) {
        minDist = dist;
        closestIndex = i;
        closestFrequency = _baseFrequencyList[i];
      }
    }

    // there is a simplification about the distance, cause the distance until forward note is bigger then previous note
    double factor = (fundamentalFrequency - closestFrequency) / (fundamentalFrequency * (pow(_noteInterval, 1/2) - 1));

    if (factor.abs() < _tolerance) {
      factor = 0;
    }

    return NoteDisplay(NoteSymbol.values[closestIndex], originalFrequency, harmonic, factor);
  }

  double getNoteFrequency(NoteSymbol noteSymbol, int harmonic) {
    int index = noteSymbol.index;
    double baseFrequency = _baseFrequencyList[index + 1];
    double frequencyWithHarmonic = baseFrequency * pow(2, harmonic);
    return frequencyWithHarmonic;
  }
}
