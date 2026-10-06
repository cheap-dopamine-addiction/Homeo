package com.cheapdopamine.homeo.friction

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import java.util.Locale

/**
 * Posts the "you opened X" warning straight from Kotlin, so it fires even when
 * the Flutter engine is not running (app swiped away, killed by the OEM...).
 */
object FrictionNotifier {
    private const val CHANNEL_ID = "app_opened_warning"
    private const val BASE_ID = 5000

    @SuppressLint("MissingPermission") // checked via areNotificationsEnabled()
    fun showAppOpened(ctx: Context, packageName: String, count: Int) {
        val appContext = ctx.applicationContext
        val th = Locale.getDefault().language == "th"
        val manager = NotificationManagerCompat.from(appContext)

        // Android 13+: without POST_NOTIFICATIONS the call is silently dropped.
        if (!manager.areNotificationsEnabled()) return

        ensureChannel(appContext, th)

        val appName = labelOf(appContext, packageName)
        val title = if (th) "เปิด $appName ครั้งที่ $count วันนี้"
        else "Opening $appName: time $count today"
        val body = if (th) "หยุดสักครู่ — กลับไปโฟกัสกันไหม?"
        else "Pause a moment — head back to focus?"

        val launch = appContext.packageManager.getLaunchIntentForPackage(appContext.packageName)
            ?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        val tapIntent = launch?.let {
            PendingIntent.getActivity(
                appContext, 0, it,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
        }

        val notification = NotificationCompat.Builder(appContext, CHANNEL_ID)
            .setSmallIcon(appContext.applicationInfo.icon)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setAutoCancel(true)
            .setTimeoutAfter(20_000) // a warning, not an inbox item
            .setContentIntent(tapIntent)
            .build()

        // One slot per app: repeated opens replace instead of piling up.
        manager.notify(BASE_ID + (packageName.hashCode() and 0x3FF), notification)
    }

    @Suppress("DEPRECATION")
    private fun labelOf(ctx: Context, packageName: String): String = try {
        val pm = ctx.packageManager
        pm.getApplicationLabel(pm.getApplicationInfo(packageName, 0)).toString()
    } catch (e: Exception) {
        packageName
    }

    private fun ensureChannel(ctx: Context, th: Boolean) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = ctx.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (manager.getNotificationChannel(CHANNEL_ID) != null) return
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                if (th) "เตือนเมื่อเปิดแอปที่ระวัง" else "Watched app warnings",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = if (th) "แจ้งเตือนเมื่อคุณเปิดแอปที่ตั้งไว้ว่าอยากลด"
                else "Tells you when you open an app you want to cut down"
            }
        )
    }
}
