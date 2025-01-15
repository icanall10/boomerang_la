package com.example.boomerang

import android.content.Intent
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class FirebaseService : FirebaseMessagingService() {

    override fun onMessageReceived(message: RemoteMessage) {
        startForegroundService(message)
    }

    private fun startForegroundService(remoteMessage: RemoteMessage) {
        val data = remoteMessage.data
        val intent = Intent(this, LiveActivity::class.java).apply {
            putExtra("fio", data["fio"] ?: "-")
            putExtra("message", data["message"] ?: "-")
            putExtra("timerSeconds", data["timerSeconds"] ?: "-")
            putExtra("price", data["price"] ?: "-")
            putExtra("avatarUrl", data["avatarUrl"])
        }
        startForegroundService(intent)
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d("MyFirebaseMessaging", "New token: $token")

    }
}