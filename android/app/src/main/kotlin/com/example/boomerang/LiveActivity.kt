package com.example.boomerang

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.graphics.Rect
import android.graphics.RectF
import android.net.Uri
import android.os.IBinder
import android.os.SystemClock
import android.widget.RemoteViews
import com.bumptech.glide.Glide
import com.example.boomerang.utils.toUri
import java.util.concurrent.ExecutionException

class LiveActivity : Service() {
    private val CHANNEL_ID = "ForegroundServiceChannel"

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val fio = intent?.getStringExtra("fio").orEmpty()
        val message = intent?.getStringExtra("message").orEmpty()
        val timerSeconds = intent?.getIntExtra("timerSeconds", 60) ?: 60
        val price = intent?.getStringExtra("price").orEmpty()
        val avatarUrl = intent?.getStringExtra("avatarUrl").orEmpty()

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
            setTextViewText(R.id.priceTextView, "$price₽")
        }

        val remoteViewSmallContent = RemoteViews(packageName, R.layout.liva_activity_small_content).apply {
            setTextViewText(R.id.message, message)
        }

        val countdownTimeMs = timerSeconds * 1000L
        val baseTime = SystemClock.elapsedRealtime() + countdownTimeMs

        remoteView.setChronometer(R.id.chronometer, baseTime, null, true)
        remoteViewSmallContent.setChronometer(R.id.chronometerSmall, baseTime, null, true)
        remoteView.setBoolean(R.id.chronometer, "setCountDown", true)
        remoteViewSmallContent.setBoolean(R.id.chronometerSmall, "setCountDown", true)

        Thread {
            try {
                val avatarBitmap = Glide.with(this).asBitmap().load(Uri.parse(avatarUrl)).submit().get()
                val roundedAvatar = getCircularBitmap(avatarBitmap)
                remoteView.setImageViewBitmap(R.id.avatar, roundedAvatar)
                remoteViewSmallContent.setImageViewBitmap(R.id.avatarSmall, roundedAvatar)

                // Обновление уведомления
                val notification = Notification.Builder(this, CHANNEL_ID)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setContentIntent(pendingIntent)
                    .setCustomContentView(remoteViewSmallContent)
                    .setCustomBigContentView(remoteView)
                    .build()

                val notificationManager = getSystemService(NotificationManager::class.java)
                notificationManager?.notify(1, notification)
            } catch (e: ExecutionException) {
                e.printStackTrace()
            } catch (e: InterruptedException) {
                e.printStackTrace()
            }
        }.start()

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

    private fun getCircularBitmap(bitmap: Bitmap): Bitmap {
        val size = minOf(bitmap.width, bitmap.height)
        val x = (bitmap.width - size) / 2
        val y = (bitmap.height - size) / 2
        val squareBitmap = Bitmap.createBitmap(bitmap, x, y, size, size)

        val output = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(output)
        val paint = Paint().apply {
            isAntiAlias = true
        }

        val rect = Rect(0, 0, size, size)
        val rectF = RectF(rect)

        canvas.drawOval(rectF, paint)

        paint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_IN)
        canvas.drawBitmap(squareBitmap, rect, rect, paint)

        return output
    }
}