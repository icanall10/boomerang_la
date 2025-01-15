package com.example.boomerang.utils

import android.net.Uri

fun String.toUri(): Uri {
    return Uri.parse(this)
}
