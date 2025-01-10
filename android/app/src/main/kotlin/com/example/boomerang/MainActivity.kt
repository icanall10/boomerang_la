package com.example.boomerang

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "foregroundChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when(call.method) {
                "startForegroundService" -> {
                    val fio = call.argument<String>("fio") ?: "NoName"
                    val message = call.argument<String>("message") ?: "NoMessage"
                    val timerSeconds = call.argument<Int>("timerSeconds") ?: 60
                    val price = call.argument<String>("price") ?: "0"

                    startMyForegroundService(fio, message, timerSeconds, price)
                    result.success(null)
                }
                "stopForegroundService" -> {
                    stopMyForegroundService()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startMyForegroundService(
        fio: String,
        message: String,
        timerSeconds: Int,
        price: String
    ) {
        val intent = Intent(this, LiveActivity::class.java).apply {
            putExtra("fio", fio)
            putExtra("message", message)
            putExtra("timerSeconds", timerSeconds)
            putExtra("price", price)
        }
        startForegroundService(intent)
    }

    private fun stopMyForegroundService() {
        val intent = Intent(this, LiveActivity::class.java)
        stopService(intent)
    }
}
