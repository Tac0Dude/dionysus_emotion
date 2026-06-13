package ch.heg.dionysus.emotion.dionysus_emotion

import ch.heg.dionysus.emotion.dionysus_emotion.widget.EmotionWidgetProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private companion object {
        const val CHANNEL = "dionysus/widget"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Synchronise la dernière saisie de l'app vers le widget natif.
                    "syncLastEntry" -> {
                        val quadrant = call.argument<Int>("quadrant") ?: 1
                        val emotion = call.argument<String>("emotion") ?: ""
                        val intensity = call.argument<Int>("intensity") ?: 1
                        val timestamp = call.argument<Number>("timestamp")?.toLong()
                            ?: System.currentTimeMillis()
                        EmotionWidgetProvider.syncLastEntry(
                            applicationContext,
                            quadrant,
                            emotion,
                            intensity,
                            timestamp,
                        )
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
