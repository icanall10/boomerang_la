package com.example.boomerang

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.os.SystemClock
import android.widget.RemoteViews

class LiveActivity : Service() {
    private val CHANNEL_ID = "ForegroundServiceChannel"

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val fio = intent?.getStringExtra("fio").orEmpty()
        val message = intent?.getStringExtra("message").orEmpty()
        val timerSeconds = intent?.getIntExtra("timerSeconds", 60)
        val price = intent?.getStringExtra("price").orEmpty()


        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            PendingIntent.FLAG_IMMUTABLE
        )
        val remoteView = RemoteViews(packageName, R.layout.live_activity).apply {
            setTextViewText(R.id.title, fio)
            setTextViewText(R.id.message, message)
            setTextViewText(R.id.priceTextView, price)
        }
        val remoteViewSmallContent = RemoteViews(packageName, R.layout.liva_activity_small_content).apply {
            setTextViewText(R.id.message, message)
        }
        val countdownTimeMs = timerSeconds!! * 1000L
        val baseTime = SystemClock.elapsedRealtime() + countdownTimeMs

        remoteView.setChronometer(
            R.id.chronometer,
            baseTime,
            null,
            true
        )
        remoteViewSmallContent.setChronometer(
            R.id.chronometerSmall,
            baseTime,
            null,
            true
        )
        remoteView.setBoolean(R.id.chronometer, "setCountDown", true)
        remoteViewSmallContent.setBoolean(R.id.chronometerSmall, "setCountDown", true)

        val notification: Notification = Notification.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setCustomContentView(remoteViewSmallContent)
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
