package com.matheusdev.adjustable_tuner.event_channel

import com.matheusdev.adjustable_tuner.audio.AudioProcessingEngine
import com.matheusdev.adjustable_tuner.audio.AudioRecorder
import com.matheusdev.adjustable_tuner.audio.AudioRecorderListener
import io.flutter.plugin.common.EventChannel

class AudioProcessingHandler(
    private val audioRecorder: AudioRecorder,
    private val audioProcessingEngine: AudioProcessingEngine
): EventChannel.StreamHandler {
    private var audioRecorderListener: AudioRecorderListener? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        var startTime: Long = 0

        val listener: AudioRecorderListener = { byteArray: ByteArray ->
            startTime = System.currentTimeMillis()
            audioProcessingEngine.processAudioBuffer(byteArray)
        }

        audioProcessingEngine.audioProcessingListener = { audioData ->
            val elapsedTimeMs = System.currentTimeMillis() - startTime
            println("frequency ${audioData.frequency} - intensity ${audioData.intensity} - taken: $elapsedTimeMs ms")
            events?.success(audioData.toDataMap())
        }

        audioRecorder.audioRecorderListeners.add(listener)
        audioRecorderListener = listener
    }

    override fun onCancel(arguments: Any?) {
        audioRecorderListener?.let {
            audioRecorder.audioRecorderListeners.remove(it)
        }
    }
}
