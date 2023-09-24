package com.matheusdev.adjustable_tuner.audio

import com.matheusdev.adjustable_tuner.model.AudioData
import com.matheusdev.adjustable_tuner.utils.toShortArray
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.nio.ByteBuffer
import java.nio.ByteOrder

class AudioProcessingEngine(
    bufferSize: Int,
    sampleRate: Int
) {
    var audioProcessingListener: ((AudioData) -> Unit)? = null

    private val job = Job()
    private val coroutineScope = CoroutineScope(Dispatchers.Main + job)

    private var pitchDetector = YinPitchDetector(
        bufferSize = bufferSize,
        sampleRate = sampleRate
    )

    fun processAudioBuffer(audioBuffer: ByteArray) {
        coroutineScope.launch {
            audioProcessingJobStart(audioBuffer)
        }
    }

    private suspend fun audioProcessingJobStart(audioBuffer: ByteArray) =
        withContext(Dispatchers.Default) {
            audioBuffer.toShortArray().let { pcmArray ->
                val frequency = pitchDetector.detectPitch(pcmArray)
                val intensity = IntensityAnalyser.getIntensity(pcmArray)

                withContext(Dispatchers.Main) {
                    audioProcessingListener?.invoke(
                        AudioData(
                            intensity = intensity,
                            frequency = frequency
                        )
                    )
                }
            }
        }

    fun cancel() {
        job.cancel()
    }
}
