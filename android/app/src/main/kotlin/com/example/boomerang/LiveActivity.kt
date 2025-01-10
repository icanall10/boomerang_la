package com.example.boomerang

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.widget.RemoteViews


class LiveActivity : Service() {
    private val CHANNEL_ID = "ForegroundServiceChannel"

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val fio = intent!!.getStringExtra("fio").toString()
        val message = intent.getStringExtra("message").toString()
        val timerSeconds = intent.getStringExtra("timerSeconds").toString()
        val price = intent.getStringExtra("price").toString()

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)

        val remoteView = RemoteViews(packageName, R.layout.live_activity)
        remoteView.setTextViewText(R.id.title, fio)
        remoteView.setTextViewText(R.id.message, message)

        val notification: Notification = Notification.Builder(this, CHANNEL_ID)
            .setContentTitle(fio)
            .setContentText(message)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setCustomBigContentView(remoteView)
            .build()

        startForeground(1, notification)
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        val serviceChannel = NotificationChannel(
            CHANNEL_ID,
            "Foreground Service Channel",
            NotificationManager.IMPORTANCE_DEFAULT
        )

        val manager = getSystemService(NotificationManager::class.java)
        manager?.createNotificationChannel(serviceChannel)
    }

}