package com.matheusdev.adjustable_tuner.audio

import kotlin.math.abs
import kotlin.math.ln
import kotlin.math.max
import kotlin.math.min

object IntensityAnalyser {
    fun getIntensity(audioData: ShortArray): Double {
        if (audioData.isEmpty()) {
            return 0.0
        }

        val maxAmplitude = audioData.maxOf { abs(it.toDouble()) }
        val volumeInDb = amplitudeToDb(maxAmplitude)
        return normalizeDb(volumeInDb)
    }

    private fun amplitudeToDb(amplitude: Double): Double =
        20 * (ln(amplitude / Short.MAX_VALUE) / ln(10.0))

    private fun normalizeDb(dB: Double): Double {
        val minDb = -60.0
        val maxDb = 0.0

        val clippedDb = max(minDb, min(dB, maxDb))
        return (clippedDb - minDb) / (maxDb - minDb)
    }
}
