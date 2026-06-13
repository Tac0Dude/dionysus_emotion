package ch.heg.dionysus.emotion.dionysus_emotion.widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import ch.heg.dionysus.emotion.dionysus_emotion.R
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Widget interactif de saisie émotionnelle.
 *
 * La navigation (repos → quadrant → émotion → intensité) est gérée nativement
 * via [RemoteViews] et des broadcasts [ACTION_NAV] : rendu instantané. La
 * sélection d'émotion et d'intensité se fait via un carrousel horizontal
 * (flèches ‹ ›). La sauvegarde finale est déléguée à un isolate Dart (home_widget)
 * pour réutiliser Drift.
 */
class EmotionWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val PREFS = "dionysus_widget"
        private const val ACTION_NAV = "ch.heg.dionysus.emotion.widget.NAV"

        private const val KEY_STEP = "step"
        private const val KEY_QUADRANT = "quadrant"
        private const val KEY_EMOTION = "emotion"
        private const val KEY_IDLE_TEXT = "idle_text"
        private const val KEY_CONFIRM_META = "confirm_meta"
        private const val KEY_LAST_TS = "last_ts"

        // L'état de repos (0) s'affiche soit en mode "repos" (maquette 20) si une
        // saisie est récente, soit en "invitation" (maquette 16) au-delà du seuil.
        private const val STEP_REST = 0
        private const val STEP_QUADRANT = 1
        private const val STEP_EMOTION = 2
        private const val STEP_INTENSITY = 3

        // Délai sans saisie au-delà duquel le widget invite à noter une émotion.
        private const val STALE_AFTER_MS = 3L * 60 * 60 * 1000

        // Doit rester aligné avec le seed (data/database/seed_data.dart).
        private val QUADRANT_LABELS = mapOf(
            1 to "Agréable et en contrôle",
            2 to "Agréable mais dépassé·e",
            3 to "Difficile mais en contrôle",
            4 to "Difficile et dépassé·e",
        )

        private val QUADRANT_EMOTIONS = mapOf(
            1 to listOf("Joie", "Fierté", "Admiration", "Intérêt", "Amusement"),
            2 to listOf("Plaisir", "Contentement", "Amour", "Soulagement", "Compassion"),
            3 to listOf("Colère", "Mépris", "Haine", "Dégoût", "Honte"),
            4 to listOf("Tristesse", "Culpabilité", "Regret", "Déception", "Peur"),
        )

        // Forme du design system propre à chaque quadrant (état de repos).
        private val SHAPE_DRAWABLE = mapOf(
            1 to R.drawable.shape_q1,
            2 to R.drawable.shape_q2,
            3 to R.drawable.shape_q3,
            4 to R.drawable.shape_q4,
        )

        // Fond des tuiles de sélection, teinté à la couleur du quadrant.
        private val TILE_DRAWABLE = mapOf(
            1 to R.drawable.tile_q1,
            2 to R.drawable.tile_q2,
            3 to R.drawable.tile_q3,
            4 to R.drawable.tile_q4,
        )

        private val EMOTION_TILE_IDS = listOf(
            R.id.tile_emotion_1,
            R.id.tile_emotion_2,
            R.id.tile_emotion_3,
            R.id.tile_emotion_4,
            R.id.tile_emotion_5,
        )

        private val INTENSITY_TILE_IDS = listOf(
            R.id.tile_intensity_1,
            R.id.tile_intensity_2,
            R.id.tile_intensity_3,
            R.id.tile_intensity_4,
            R.id.tile_intensity_5,
        )

        private val INTENSITY_LABELS =
            listOf("Légère", "Faible", "Modérée", "Forte", "Intense")

        /**
         * Pousse la dernière saisie dans l'état du widget puis le redessine.
         *
         * Point d'entrée unique partagé par la sauvegarde via le widget et par la
         * synchronisation déclenchée par l'app (MethodChannel) : le widget reflète
         * ainsi la dernière saisie quelle que soit son origine. Le [timestamp]
         * (date réelle de la saisie) pilote le seuil repos → invitation, ce qui
         * laisse le widget basculer correctement quand la saisie devient ancienne.
         */
        fun syncLastEntry(
            context: Context,
            quadrant: Int,
            emotion: String,
            intensity: Int,
            timestamp: Long,
        ) {
            val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val time = SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date(timestamp))
            val intensityLabel = INTENSITY_LABELS.getOrNull(intensity - 1) ?: ""
            prefs.edit()
                .putInt(KEY_QUADRANT, quadrant)
                .putString(KEY_EMOTION, emotion)
                .putString(KEY_IDLE_TEXT, "$emotion · $time")
                .putString(KEY_CONFIRM_META, "$intensityLabel · $time")
                .putLong(KEY_LAST_TS, timestamp)
                .putInt(KEY_STEP, STEP_REST)
                .apply()

            val provider = EmotionWidgetProvider()
            provider.scheduleStaleCheck(context, timestamp + STALE_AFTER_MS)
            provider.updateAll(context)
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val prefs = prefs(context)
        for (id in appWidgetIds) {
            renderWidget(context, appWidgetManager, id, prefs)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_NAV) {
            handleNav(context, intent.data)
            return
        }
        super.onReceive(context, intent)
    }

    // --- Navigation ----------------------------------------------------------

    private fun handleNav(context: Context, uri: Uri?) {
        if (uri == null) return
        val prefs = prefs(context)
        val editor = prefs.edit()

        when (uri.getQueryParameter("do")) {
            "start" -> editor.putInt(KEY_STEP, STEP_QUADRANT)

            "cancel" -> editor.putInt(KEY_STEP, STEP_REST)

            "refresh" -> {
                updateAll(context)
                return
            }

            "quadrant" -> {
                val q = uri.getQueryParameter("q")?.toIntOrNull() ?: return
                editor.putInt(KEY_QUADRANT, q).putInt(KEY_STEP, STEP_EMOTION)
            }

            "emotion" -> {
                val q = prefs.getInt(KEY_QUADRANT, 1)
                val index = uri.getQueryParameter("e")?.toIntOrNull() ?: return
                val emotion = QUADRANT_EMOTIONS[q]?.getOrNull(index - 1) ?: return
                editor.putString(KEY_EMOTION, emotion).putInt(KEY_STEP, STEP_INTENSITY)
            }

            "intensity" -> {
                val q = prefs.getInt(KEY_QUADRANT, 1)
                val emotion = prefs.getString(KEY_EMOTION, "") ?: ""
                val intensity = uri.getQueryParameter("i")?.toIntOrNull() ?: return
                saveEntryInBackground(context, q, emotion, intensity)
                // Le rendu de l'état de repos + l'écriture des prefs + la
                // planification du passage en invitation sont mutualisés avec la
                // synchronisation déclenchée par l'app (cf. syncLastEntry).
                syncLastEntry(context, q, emotion, intensity, System.currentTimeMillis())
                return
            }

            else -> return
        }

        editor.apply()
        updateAll(context)
    }

    private fun saveEntryInBackground(
        context: Context,
        quadrant: Int,
        emotion: String,
        intensity: Int,
    ) {
        val label = QUADRANT_LABELS[quadrant] ?: return
        val uri = Uri.parse(
            "dionysus://save" +
                "?quadrant=${Uri.encode(label)}" +
                "&emotion=${Uri.encode(emotion)}" +
                "&intensity=$intensity",
        )
        HomeWidgetBackgroundIntent.getBroadcast(context, uri).send()
    }

    /**
     * Planifie un re-render unique au moment où la dernière saisie devient
     * "périmée", pour basculer du mode repos vers l'invitation à l'heure exacte.
     * Alarme inexacte tolérante au Doze : aucune permission d'alarme exacte
     * requise.
     */
    private fun scheduleStaleCheck(context: Context, atMillis: Long) {
        val intent = Intent(context, EmotionWidgetProvider::class.java).apply {
            action = ACTION_NAV
            data = Uri.parse("dionysuswidget://nav?do=refresh")
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        val pending = PendingIntent.getBroadcast(context, 99, intent, flags)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.setAndAllowWhileIdle(AlarmManager.RTC, atMillis, pending)
    }

    private fun updateAll(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(
            ComponentName(context, EmotionWidgetProvider::class.java),
        )
        val prefs = prefs(context)
        for (id in ids) {
            renderWidget(context, manager, id, prefs)
        }
    }

    // --- Rendu ---------------------------------------------------------------

    private fun renderWidget(
        context: Context,
        manager: AppWidgetManager,
        widgetId: Int,
        prefs: SharedPreferences,
    ) {
        val views = when (prefs.getInt(KEY_STEP, STEP_REST)) {
            STEP_QUADRANT -> buildQuadrant(context)
            STEP_EMOTION -> buildEmotion(context, prefs)
            STEP_INTENSITY -> buildIntensity(context, prefs)
            else -> buildRest(context, prefs)
        }
        manager.updateAppWidget(widgetId, views)
    }

    /**
     * État de repos : affiche la dernière saisie (maquette 20) si elle est
     * récente, sinon invite à noter une émotion (maquette 16, "+" clignotant).
     */
    private fun buildRest(context: Context, prefs: SharedPreferences): RemoteViews {
        val lastTs = prefs.getLong(KEY_LAST_TS, 0L)
        val isRecent = lastTs > 0L && System.currentTimeMillis() - lastTs < STALE_AFTER_MS
        return if (isRecent) buildRepos(context, prefs) else buildInvitation(context, prefs)
    }

    private fun buildInvitation(context: Context, prefs: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_idle)
        val last = prefs.getString(KEY_IDLE_TEXT, null)
        if (last.isNullOrEmpty()) {
            views.setViewVisibility(R.id.idle_last, View.GONE)
        } else {
            views.setViewVisibility(R.id.idle_last, View.VISIBLE)
            views.setTextViewText(R.id.idle_last, last)
        }
        views.setOnClickPendingIntent(R.id.widget_idle_root, navIntent(context, "start", 10))
        return views
    }

    private fun buildRepos(context: Context, prefs: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_confirm)
        val quadrant = prefs.getInt(KEY_QUADRANT, 1)
        // Forme colorée du quadrant, au-dessus du nom de l'émotion.
        views.setImageViewResource(
            R.id.confirm_circle,
            SHAPE_DRAWABLE[quadrant] ?: R.drawable.shape_q1,
        )
        views.setTextViewText(R.id.confirm_emotion, prefs.getString(KEY_EMOTION, "") ?: "")
        views.setTextViewText(R.id.confirm_meta, prefs.getString(KEY_CONFIRM_META, "") ?: "")
        // Un appui sur l'état de repos relance une nouvelle saisie.
        views.setOnClickPendingIntent(R.id.widget_confirm_root, navIntent(context, "start", 50))
        return views
    }

    private fun buildQuadrant(context: Context): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_quadrant)
        views.setOnClickPendingIntent(R.id.tile_quadrant_1, navIntent(context, "quadrant&q=1", 21))
        views.setOnClickPendingIntent(R.id.tile_quadrant_2, navIntent(context, "quadrant&q=2", 22))
        views.setOnClickPendingIntent(R.id.tile_quadrant_3, navIntent(context, "quadrant&q=3", 23))
        views.setOnClickPendingIntent(R.id.tile_quadrant_4, navIntent(context, "quadrant&q=4", 24))
        return views
    }

    private fun buildEmotion(context: Context, prefs: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_emotion)
        val quadrant = prefs.getInt(KEY_QUADRANT, 1)
        val emotions = QUADRANT_EMOTIONS[quadrant] ?: emptyList()
        val tileBg = TILE_DRAWABLE[quadrant] ?: R.drawable.tile_q1
        views.setTextViewText(R.id.emotion_title, QUADRANT_LABELS[quadrant] ?: "")

        EMOTION_TILE_IDS.forEachIndexed { index, tileId ->
            val name = emotions.getOrNull(index)
            if (name == null) {
                views.setViewVisibility(tileId, View.GONE)
            } else {
                views.setViewVisibility(tileId, View.VISIBLE)
                views.setTextViewText(tileId, name)
                views.setInt(tileId, "setBackgroundResource", tileBg)
                views.setOnClickPendingIntent(
                    tileId,
                    navIntent(context, "emotion&e=${index + 1}", 30 + index),
                )
            }
        }
        return views
    }

    private fun buildIntensity(context: Context, prefs: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_intensity)
        val quadrant = prefs.getInt(KEY_QUADRANT, 1)
        val tileBg = TILE_DRAWABLE[quadrant] ?: R.drawable.tile_q1
        views.setTextViewText(R.id.intensity_subtitle, prefs.getString(KEY_EMOTION, "") ?: "")

        INTENSITY_TILE_IDS.forEachIndexed { index, tileId ->
            views.setInt(tileId, "setBackgroundResource", tileBg)
            views.setOnClickPendingIntent(
                tileId,
                navIntent(context, "intensity&i=${index + 1}", 40 + index),
            )
        }
        return views
    }

    // --- Helpers -------------------------------------------------------------

    private fun navIntent(context: Context, params: String, requestCode: Int): PendingIntent {
        val intent = Intent(context, EmotionWidgetProvider::class.java).apply {
            action = ACTION_NAV
            data = Uri.parse("dionysuswidget://nav?do=$params")
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        return PendingIntent.getBroadcast(context, requestCode, intent, flags)
    }

    private fun prefs(context: Context): SharedPreferences =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
}
