package com.matheusdev.adjustable_tuner

import com.matheusdev.adjustable_tuner.audio.AudioProcessingEngine
import com.matheusdev.adjustable_tuner.audio.AudioRecorder
import com.matheusdev.adjustable_tuner.event_channel.AudioProcessingHandler
import com.matheusdev.adjustable_tuner.event_channel.AudioStreamHandler
import com.matheusdev.adjustable_tuner.method_channel.NativeMethodHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var audioRecorder = AudioRecorder(
        context = this
    )
    private var audioProcessingEngine = AudioProcessingEngine(
        bufferSize = audioRecorder.streamBufferSize,
        sampleRate = audioRecorder.sampleRate
    )

    override fun onDestroy() {
        super.onDestroy()
        audioProcessingEngine.cancel()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor, AUDIO_STREAM_CHANNEL).setStreamHandler(
            AudioStreamHandler(
                audioRecorder
            )
        )

        EventChannel(flutterEngine.dartExecutor, AUDIO_PROCESSING_CHANNEL).setStreamHandler(
            AudioProcessingHandler(
                audioRecorder,
                audioProcessingEngine
            )
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHODS).setMethodCallHandler(
            NativeMethodHandler(audioRecorder)
        )
    }

    companion object {
        private const val PREFIX = "com.matheusdev.adjustable_tuner"
        private const val METHODS = "${PREFIX}/native_methods"
        private const val AUDIO_STREAM_CHANNEL = "${PREFIX}/audio_stream"
        private const val AUDIO_PROCESSING_CHANNEL = "${PREFIX}/audio_processing"
    }
}
