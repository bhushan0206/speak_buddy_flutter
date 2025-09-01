package com.vibrantmoose.speakbuddy

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Register custom voice recognition plugin
        VoiceRecognitionPlugin().apply {
            flutterEngine.plugins.add(this)
        }
    }
}
