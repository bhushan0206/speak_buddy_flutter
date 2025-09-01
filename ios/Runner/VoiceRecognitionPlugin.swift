import Foundation
import Speech
import Flutter

@available(iOS 10.0, *)
class VoiceRecognitionPlugin: NSObject, FlutterPlugin, SFSpeechRecognizerDelegate {
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine: AVAudioEngine?
    private var eventSink: FlutterEventSink?
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "voice_recognition", binaryMessenger: registrar.messenger())
        let instance = VoiceRecognitionPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "speech_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "checkSpeechRecognitionAvailability":
            checkAvailability(result: result)
        case "startListening":
            startListening(result: result)
        case "stopListening":
            stopListening(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func checkAvailability(result: @escaping FlutterResult) {
        let isAvailable = SFSpeechRecognizer.authorizationStatus() == .authorized
        result(isAvailable)
    }
    
    private func startListening(result: @escaping FlutterResult) {
        // Request authorization if not already granted
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self?.startRecognition(result: result)
                case .denied, .restricted, .notDetermined:
                    result(false)
                @unknown default:
                    result(false)
                }
            }
        }
    }
    
    private func startRecognition(result: @escaping FlutterResult) {
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) else {
            result(false)
            return
        }
        
        self.speechRecognizer = speechRecognizer
        speechRecognizer.delegate = self
        
        // Check if audio engine is running
        if audioEngine?.isRunning == true {
            audioEngine?.stop()
            recognitionRequest?.endAudio()
            result(false)
            return
        }
        
        // Set up audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            result(false)
            return
        }
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            result(false)
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Set up audio engine
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else {
            result(false)
            return
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            result(false)
            return
        }
        
        // Start recognition
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            var isFinal = false
            
            if let result = result {
                let transcript = result.bestTranscription.formattedString
                let confidence = result.bestTranscription.segments.map { $0.confidence }.reduce(0, +) / Double(result.bestTranscription.segments.count)
                
                // Send result to Flutter
                let event: [String: Any] = [
                    "text": transcript,
                    "isFinal": result.isFinal,
                    "confidence": confidence
                ]
                
                DispatchQueue.main.async {
                    self?.eventSink?(event)
                }
                
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self?.audioEngine?.stop()
                inputNode.removeTap(onBus: 0)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        }
        
        result(true)
    }
    
    private func stopListening(result: @escaping FlutterResult) {
        audioEngine?.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        recognitionRequest = nil
        recognitionTask = nil
        
        result(true)
    }
    
    // MARK: - SFSpeechRecognizerDelegate
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        // Handle availability changes if needed
    }
}

// MARK: - FlutterStreamHandler

@available(iOS 10.0, *)
extension VoiceRecognitionPlugin: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
