package com.matheusdev.adjustable_tuner.model

data class AudioData(
    val intensity: Double,
    val frequency: Double
) {
    fun toDataMap() = mapOf(
        "intensity" to intensity,
        "frequency" to frequency
    )
}
