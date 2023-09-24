package com.matheusdev.adjustable_tuner.audio

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioRecord
import android.media.AudioTrack
import android.media.MediaRecorder
import androidx.core.app.ActivityCompat

typealias AudioRecorderListener = (ByteArray) -> Unit

class AudioRecorder(
    private val channelConfig: Int = AudioFormat.CHANNEL_IN_MONO,
    private val audioFormat: Int = AudioFormat.ENCODING_PCM_16BIT,
    private val audioSource: Int = MediaRecorder.AudioSource.MIC,
    private val context: Context,
    intervalSeconds: Float = 0.2f
) {
    val sampleRate: Int = AudioTrack.getNativeOutputSampleRate(AudioManager.STREAM_MUSIC)
    val streamBufferSize: Int

    var audioRecorderListeners = ArrayList<AudioRecorderListener>()

    init {
        val minBufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)
        streamBufferSize = (sampleRate * intervalSeconds).let { intervalBufferSize ->
            if (intervalBufferSize > minBufferSize) intervalBufferSize.toInt() else minBufferSize
        }
    }

    private var audioRecord: AudioRecord? = null

    fun startRecording() {
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO)
            == PackageManager.PERMISSION_GRANTED
        ) {
            audioRecord = AudioRecord(
                audioSource,
                sampleRate,
                channelConfig,
                audioFormat,
                streamBufferSize
            ).apply {
                positionNotificationPeriod = streamBufferSize
                val audioBuffer = ByteArray(streamBufferSize * 2)

                setRecordPositionUpdateListener(
                    object : AudioRecord.OnRecordPositionUpdateListener {
                        override fun onMarkerReached(recorder: AudioRecord?) = Unit

                        override fun onPeriodicNotification(recorder: AudioRecord?) {
                            recorder?.read(audioBuffer, 0, audioBuffer.size)
                            audioRecorderListeners.forEach { it(audioBuffer) }
                        }
                    }
                )
                startRecording()

                // SetRecordPositionUpdateListener needs a kickoff to begins work
                read(audioBuffer, 0, audioBuffer.size)
            }
        }
    }

    fun stopRecording() {
        audioRecord?.let {
            it.stop()
            it.release()
        }
        audioRecord = null
    }
}
