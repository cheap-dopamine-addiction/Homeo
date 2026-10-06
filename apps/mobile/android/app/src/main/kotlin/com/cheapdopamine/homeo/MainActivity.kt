package com.cheapdopamine.homeo

import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.os.PowerManager
import android.provider.Settings
import com.cheapdopamine.homeo.friction.FocusAccessibilityService
import com.cheapdopamine.homeo.friction.FrictionPrefs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Dart <-> native contract: `com.cheapdopamine.homeo/friction`.
 *
 * Warning-only: nothing here blocks or kills an app.
 */
class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "isAccessibilityEnabled" -> result.success(isAccessibilityEnabled())

                        "openAccessibilitySettings" -> {
                            startActivity(
                                Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            )
                            result.success(null)
                        }

                        "setBlockedPackages" -> {
                            val packages = (call.arguments as? List<*>)
                                ?.filterIsInstance<String>() ?: emptyList()
                            FrictionPrefs.writeBlocked(this, packages)
                            result.success(null)
                        }

                        "drainPendingEvents" -> result.success(FrictionPrefs.peekPending(this))

                        "ackPendingEvents" -> {
                            val upTo = (call.argument<Number>("upTo"))?.toLong() ?: 0L
                            FrictionPrefs.ackPending(this, upTo)
                            result.success(null)
                        }

                        "isIgnoringBatteryOptimizations" -> result.success(isIgnoringBattery())

                        "requestIgnoreBatteryOptimizations" -> {
                            requestIgnoreBattery()
                            result.success(null)
                        }

                        "allow" -> {
                            val pkg = call.argument<String>("packageId")
                            val seconds = (call.argument<Number>("seconds"))?.toLong() ?: 0L
                            if (pkg != null) {
                                FrictionPrefs.setAllowUntil(
                                    this, pkg, System.currentTimeMillis() + seconds * 1000
                                )
                            }
                            result.success(null)
                        }

                        "allowAll" -> {
                            val seconds = (call.argument<Number>("seconds"))?.toLong() ?: 0L
                            FrictionPrefs.setAllowUntil(
                                this, null, System.currentTimeMillis() + seconds * 1000
                            )
                            result.success(null)
                        }

                        "returnHome" -> {
                            // The user tapped "back to focus": leave to the launcher.
                            startActivity(
                                Intent(Intent.ACTION_MAIN)
                                    .addCategory(Intent.CATEGORY_HOME)
                                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            )
                            result.success(null)
                        }

                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("FRICTION_ERROR", e.message, null)
                }
            }
    }

    private fun isAccessibilityEnabled(): Boolean {
        val enabledFlag = Settings.Secure.getInt(
            contentResolver, Settings.Secure.ACCESSIBILITY_ENABLED, 0
        )
        if (enabledFlag != 1) return false

        val list = Settings.Secure.getString(
            contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ) ?: return false

        val expected = ComponentName(this, FocusAccessibilityService::class.java)
        // Entries may be stored short ("pkg/.Cls") or flat ("pkg/pkg.Cls").
        return list.split(':').any { ComponentName.unflattenFromString(it) == expected }
    }

    private fun isIgnoringBattery(): Boolean {
        val pm = getSystemService(POWER_SERVICE) as PowerManager
        return pm.isIgnoringBatteryOptimizations(packageName)
    }

    private fun requestIgnoreBattery() {
        try {
            startActivity(
                Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
                    .setData(Uri.parse("package:$packageName"))
            )
        } catch (e: ActivityNotFoundException) {
            // Some OEM ROMs lack the direct dialog: open the general list.
            startActivity(Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS))
        }
    }

    companion object {
        const val CHANNEL = "com.cheapdopamine.homeo/friction"
    }
}
