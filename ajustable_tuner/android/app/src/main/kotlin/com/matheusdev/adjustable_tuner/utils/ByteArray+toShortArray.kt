package com.matheusdev.adjustable_tuner.utils

import java.nio.ByteBuffer
import java.nio.ByteOrder

fun ByteArray.toShortArray(): ShortArray {
    val shortArray = ShortArray(size / 2)
    ByteBuffer.wrap(this).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(shortArray)
    return shortArray
}
