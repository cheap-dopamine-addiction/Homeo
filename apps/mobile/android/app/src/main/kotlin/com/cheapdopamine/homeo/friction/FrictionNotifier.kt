package com.cheapdopamine.homeo.friction

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import java.util.Locale

/**
 * Posts the "you opened X" warning straight from Kotlin, so it fires even when
 * the Flutter engine is not running (app swiped away, killed by the OEM...).
 *
 * Tapping it opens Homeo at `homeo://intervention?app=<pkg>&ts=<eventTs>`,
 * which Dart turns into the reflective "pause and think" screen. The user can
 * always continue to the app afterwards: nothing here blocks anything.
 */
object FrictionNotifier {
    private const val CHANNEL_ID = "app_opened_warning"
    private const val BASE_ID = 5000

    @SuppressLint("MissingPermission") // checked via areNotificationsEnabled()
    fun showAppOpened(ctx: Context, packageName: String, count: Int, eventTs: Long) {
        val appContext = ctx.applicationContext
        val th = Locale.getDefault().language == "th"
        val manager = NotificationManagerCompat.from(appContext)

        // Android 13+: without POST_NOTIFICATIONS the call is silently dropped.
        if (!manager.areNotificationsEnabled()) return

        ensureChannel(appContext, th)

        val appName = labelOf(appContext, packageName)
        val title = if (th) "เปิด $appName ครั้งที่ $count วันนี้"
        else "Opening $appName: time $count today"
        val body = if (th) "แตะเพื่อหยุดคิดสักครู่ — หรือจะเปิดต่อก็ได้"
        else "Tap to pause for a moment — or carry on, it's your choice"

        // `ts` is the same timestamp the pending queue uses, so Dart can tie the
        // gate's outcome to this exact event (id = native_<ts>_<package>).
        val uri = Uri.parse("homeo://intervention?app=${Uri.encode(packageName)}&ts=$eventTs")
        val tapIntent = PendingIntent.getActivity(
            appContext,
            (eventTs and 0x7FFFFFFFL).toInt(),
            Intent(Intent.ACTION_VIEW, uri)
                .setPackage(appContext.packageName) // only Homeo can receive it
                .addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
                ),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification = NotificationCompat.Builder(appContext, CHANNEL_ID)
            .setSmallIcon(appContext.applicationInfo.icon)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setAutoCancel(true)
            .setTimeoutAfter(60_000) // a warning, not an inbox item
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
