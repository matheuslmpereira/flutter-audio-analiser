package com.matheusdev.adjustable_tuner.audio

import kotlin.math.cos

/**
 * A pitch detection implementation using the YIN algorithm.
 *
 * @property bufferSize The size of the buffer used for processing the audio signal.
 * @property sampleRate The rate at which audio samples are taken.
 * @property threshold The threshold used in the YIN algorithm to detect pitch.
 * @constructor Initializes the detector with the specified buffer size, sample rate, and threshold.
 */
class YinPitchDetector(
    private val bufferSize: Int,
    private val sampleRate: Int,
    private val threshold: Float = DEFAULT_YIN_THRESHOLD
) {
    private lateinit var audioPcmBuffer: ShortArray

    // Variables optimized for memory usage due to frequent access
    private val hannWindowBuffer: FloatArray = FloatArray(bufferSize)
    private val maxSearchRange = (sampleRate / MIN_FREQUENCY).toInt()
    private val yinBuffer = FloatArray(maxSearchRange)

    init {
        for (i in hannWindowBuffer.indices) {
            hannWindowBuffer[i] = (0.5 - 0.5 * cos(2.0 * Math.PI * i / (bufferSize - 1))).toFloat()
        }
    }

    /**
     * Detects the pitch of a given audio sample.
     *
     * @param audioPcmArray The audio sample used for pitch detection.
     * @return The detected pitch in Hz or -1.0 if no pitch is detected.
     */
    fun detectPitch(audioPcmArray: ShortArray): Double {
        this.audioPcmBuffer = audioPcmArray

        yinBuffer[0] = 1.0f
        var runningSum = 0.0f
        var tauEstimate: Int = -1
        var crossThreshold = false

        for (tau in 1 until maxSearchRange) {
            //computeDifference
            yinBuffer[tau] = 0.0f
            for (j in 0 until bufferSize / 2) {
                val delta = getModulatedAudioValue(j) - getModulatedAudioValue(j + tau)
                yinBuffer[tau] += delta * delta
            }

            // Cumulative mean normalized difference function
            runningSum += yinBuffer[tau]
            yinBuffer[tau] *= tau / runningSum

            // Absolute threshold
            if (crossThreshold) {
                if (yinBuffer[tau - 1] <= yinBuffer[tau]) {
                    tauEstimate = tau - 1
                    break
                }
            } else if (yinBuffer[tau] < threshold) {
                crossThreshold = true
            }
        }

        return if (tauEstimate != -1) {
            val frequency = sampleRate / parabolicInterpolation(tauEstimate)
            if (frequency <= MAX_FREQUENCY) frequency.toDouble() else -1.0
        } else {
            -1.0
        }
    }

    /**
     * Hann window to the input signal which can improve the frequency estimation
     * by reducing spectral leakage
     */
    private fun getModulatedAudioValue(j: Int): Float =
        audioPcmBuffer[j] * hannWindowBuffer[j]

    /**
     * By using parabolic interpolation, you can obtain a more accurate estimate
     * that takes into account values between discrete samples.
     */
    private fun parabolicInterpolation(tauEstimate: Int): Float {
        val x0: Int = if (tauEstimate < 1) tauEstimate else tauEstimate - 1
        val x2: Int = if (tauEstimate + 1 < maxSearchRange) tauEstimate + 1 else tauEstimate

        return when {
            x0 == tauEstimate -> {
                (if (yinBuffer[tauEstimate] <= yinBuffer[x2]) 0 else x2).toFloat()
            }
            x2 == tauEstimate -> {
                (if (yinBuffer[tauEstimate] <= yinBuffer[x0]) tauEstimate else x0).toFloat()
            }
            else -> {
                val s0 = yinBuffer[x0]
                val s1 = yinBuffer[tauEstimate]
                val s2 = yinBuffer[x2]
                tauEstimate + (s2 - s0) / (2 * (2 * s1 - s2 - s0))
            }
        }
    }

    companion object {
        private const val DEFAULT_YIN_THRESHOLD = 0.07f
        /**
         * Frequencies on string instruments spectrum
         */
        private const val MIN_FREQUENCY = 32.7f
        private const val MAX_FREQUENCY = 2093.0f
    }
}
