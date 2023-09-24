package com.matheusdev.adjustable_tuner.method_channel

import com.matheusdev.adjustable_tuner.audio.AudioRecorder
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class NativeMethodHandler(
    private val audioRecorder: AudioRecorder
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            NativeActions.START_RECORD.method -> {
                audioRecorder.startRecording()
                result.success(null)
            }

            NativeActions.PAUSE_RECORD.method -> {
                audioRecorder.stopRecording()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    enum class NativeActions(val method: String) {
        START_RECORD("startRecord"),
        PAUSE_RECORD("pauseRecord")
    }
}
