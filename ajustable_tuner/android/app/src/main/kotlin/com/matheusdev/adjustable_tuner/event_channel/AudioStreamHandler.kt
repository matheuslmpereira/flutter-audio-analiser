package com.matheusdev.adjustable_tuner.event_channel

import com.matheusdev.adjustable_tuner.audio.AudioRecorder
import com.matheusdev.adjustable_tuner.audio.AudioRecorderListener
import io.flutter.plugin.common.EventChannel

class AudioStreamHandler(
    private val audioRecorder: AudioRecorder
): EventChannel.StreamHandler {
    private var audioRecorderListener: AudioRecorderListener? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        val listener: AudioRecorderListener = { byteArray: ByteArray ->
            events?.success(byteArray)
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
