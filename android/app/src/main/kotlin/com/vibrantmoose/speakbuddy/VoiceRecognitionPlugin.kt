package com.vibrantmoose.speakbuddy

import android.Manifest
import android.content.Intent
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.util.*

class VoiceRecognitionPlugin: FlutterPlugin, MethodCallHandler, PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var speechRecognizer: SpeechRecognizer? = null
    private var eventSink: EventChannel.EventSink? = null
    private var isListening = false

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "voice_recognition")
        channel.setMethodCallHandler(this)
        
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "speech_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "checkSpeechRecognitionAvailability" -> {
                val isAvailable = SpeechRecognizer.isRecognitionAvailable(flutterPluginBinding.applicationContext)
                result.success(isAvailable)
            }
            "startListening" -> {
                startListening(result)
            }
            "stopListening" -> {
                stopListening(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun startListening(result: Result) {
        try {
            if (isListening) {
                result.success(false)
                return
            }

            // Check if speech recognition is available
            if (!SpeechRecognizer.isRecognitionAvailable(flutterPluginBinding.applicationContext)) {
                result.success(false)
                return
            }

            // Create speech recognizer
            speechRecognizer = SpeechRecognizer.createSpeechRecognizer(flutterPluginBinding.applicationContext)
            
            // Set up recognition listener
            speechRecognizer?.setRecognitionListener(object : RecognitionListener {
                override fun onReadyForSpeech(params: Bundle?) {
                    Log.d("VoiceRecognition", "Ready for speech")
                    isListening = true
                }

                override fun onBeginningOfSpeech() {
                    Log.d("VoiceRecognition", "Beginning of speech")
                }

                override fun onRmsChanged(rmsdB: Float) {
                    // Optional: Handle volume changes
                }

                override fun onBufferReceived(buffer: ByteArray?) {
                    // Optional: Handle audio buffer
                }

                override fun onEndOfSpeech() {
                    Log.d("VoiceRecognition", "End of speech")
                }

                override fun onError(error: Int) {
                    Log.e("VoiceRecognition", "Error: $error")
                    isListening = false
                    eventSink?.error("SPEECH_ERROR", "Speech recognition error: $error", null)
                }

                override fun onResults(results: Bundle?) {
                    val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                    if (!matches.isNullOrEmpty()) {
                        val recognizedText = matches[0]
                        Log.d("VoiceRecognition", "Result: $recognizedText")
                        
                        val event = mapOf(
                            "text" to recognizedText,
                            "isFinal" to true,
                            "confidence" to 0.9 // Android doesn't provide confidence scores
                        )
                        eventSink?.success(event)
                    }
                    isListening = false
                }

                override fun onPartialResults(partialResults: Bundle?) {
                    val matches = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                    if (!matches.isNullOrEmpty()) {
                        val recognizedText = matches[0]
                        Log.d("VoiceRecognition", "Partial result: $recognizedText")
                        
                        val event = mapOf(
                            "text" to recognizedText,
                            "isFinal" to false,
                            "confidence" to 0.5
                        )
                        eventSink?.success(event)
                    }
                }

                override fun onEvent(eventType: Int, params: Bundle?) {
                    // Optional: Handle other events
                }
            })

            // Set up recognition intent
            val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
                putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault())
                putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
                putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3)
            }

            // Start listening
            speechRecognizer?.startListening(intent)
            result.success(true)

        } catch (e: Exception) {
            Log.e("VoiceRecognition", "Error starting speech recognition: ${e.message}")
            result.success(false)
        }
    }

    private fun stopListening(result: Result) {
        try {
            if (speechRecognizer != null) {
                speechRecognizer?.stopListening()
                speechRecognizer?.destroy()
                speechRecognizer = null
            }
            isListening = false
            result.success(true)
        } catch (e: Exception) {
            Log.e("VoiceRecognition", "Error stopping speech recognition: ${e.message}")
            result.success(false)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        stopListening(Result { })
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        // Handle activity results if needed
        return false
    }
}
