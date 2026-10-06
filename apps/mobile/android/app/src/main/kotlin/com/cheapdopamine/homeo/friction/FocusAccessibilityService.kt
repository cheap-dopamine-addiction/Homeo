package com.cheapdopamine.homeo.friction

import android.accessibilityservice.AccessibilityService
import android.content.SharedPreferences
import android.view.accessibility.AccessibilityEvent
import android.view.inputmethod.InputMethodManager
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/**
 * Detects "a watched app came to the foreground" and WARNS. It never blocks,
 * closes or covers anything.
 *
 * Design rules:
 *  - The watch list is checked FIRST, from memory. Unwatched apps cost one set
 *    lookup: no disk, no notification, no Flutter call, no DB (spec #3).
 *  - Everything runs natively (no EventChannel), so it works with the Flutter
 *    engine dead. Events are queued in SharedPreferences and imported by Dart
 *    when the app next opens.
 *  - It only receives `packageName` (canRetrieveWindowContent=false).
 */
class FocusAccessibilityService : AccessibilityService() {

    @Volatile private var blocked: Set<String> = emptySet()
    @Volatile private var imePackages: Set<String> = emptySet()

    private var lastPackage: String? = null
    private val lastTriggerAt = HashMap<String, Long>()

    // Disk + notification work stays off the event thread.
    private var worker: ExecutorService? = null

    // SharedPreferences keeps listeners in a weak map: hold a strong reference.
    private val prefsListener =
        SharedPreferences.OnSharedPreferenceChangeListener { _, key ->
            if (key == FrictionPrefs.KEY_BLOCKED) blocked = FrictionPrefs.readBlocked(this)
        }

    override fun onServiceConnected() {
        super.onServiceConnected()
        // The service is restarted by the system after the process was killed:
        // never rely on a value Flutter set once, always reload from disk.
        blocked = FrictionPrefs.readBlocked(this)
        imePackages = loadImePackages()
        worker = Executors.newSingleThreadExecutor()
        FrictionPrefs.prefs(this).registerOnSharedPreferenceChangeListener(prefsListener)
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val pkg = event.packageName?.toString() ?: return

        // Keyboards and system UI pop windows over the real app; treating them
        // as "the foreground app" would re-trigger on every keyboard open.
        if (pkg == "com.android.systemui" || pkg == "android" || pkg in imePackages) return

        val previous = lastPackage
        lastPackage = pkg
        if (pkg == previous) return // dialog/screen change inside the same app

        // Cheapest filter first: not watched -> done.
        if (pkg !in blocked) return

        val now = System.currentTimeMillis()
        val last = lastTriggerAt[pkg] ?: 0L
        if (now - last < COOLDOWN_MS) return
        lastTriggerAt[pkg] = now

        worker?.execute {
            if (FrictionPrefs.isMuted(this, pkg, now)) return@execute
            val count = FrictionPrefs.incrementTodayCount(this, pkg)
            FrictionPrefs.appendPending(this, pkg, now)
            FrictionNotifier.showAppOpened(this, pkg, count)
        }
    }

    override fun onInterrupt() = Unit

    override fun onUnbind(intent: android.content.Intent?): Boolean {
        FrictionPrefs.prefs(this).unregisterOnSharedPreferenceChangeListener(prefsListener)
        return super.onUnbind(intent)
    }

    override fun onDestroy() {
        worker?.shutdown()
        worker = null
        super.onDestroy()
    }

    private fun loadImePackages(): Set<String> = try {
        val imm = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
        imm.enabledInputMethodList.map { it.packageName }.toSet()
    } catch (e: Exception) {
        emptySet()
    }

    companion object {
        /** Same app within this window counts as one open. */
        private const val COOLDOWN_MS = 15_000L
    }
}
