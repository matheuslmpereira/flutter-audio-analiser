import 'dart:math';
import 'dart:typed_data';

class VolumeMeasure {
  static double computeVolume(Int16List audioData) {
    if (audioData.isEmpty) {
      return 0;
    }

    double maxAmplitude = audioData
        .reduce((curr, next) => curr.abs() >= next.abs() ? curr : next)
        .abs()
        .toDouble();

    double volumeInDb = amplitudeToDb(maxAmplitude);

    return normalizeDb(volumeInDb);
  }

  // Convert the max amplitude to dB (log scale)
  static double amplitudeToDb(double amplitude) {
    const double reference = 32767.0; // For 16-bit PCM
    return 20 * (log(amplitude / reference) / ln10);
  }

  // Normalize between 0 and 1 with a minDb reference
  static double normalizeDb(double dB) {
    const double minDb = -60.0;
    const double maxDb = 0.0;
    double clippedDb = dB.clamp(minDb, maxDb);
    return (clippedDb - minDb) / (maxDb - minDb);
  }
}
