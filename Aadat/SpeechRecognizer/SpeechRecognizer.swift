//
//  SpeechRecognizer.swift
//  Aadat
//
//  Created by Daksh Jain on 3/1/24.
//

import Foundation
import Speech

class SpeechRecognizerViewModel: ObservableObject {
    private var speechRecognitionManager = SpeechRecognitionManager()
    
    func startRecording() {
        speechRecognitionManager.startRecording()
    }
    
    func stopRecording() {
        speechRecognitionManager.stopRecording()
    }
}

class SpeechRecognitionManager: NSObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-eng"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private var audioSession: AVAudioSession?
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }
    
    func startRecording() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized by the user")
                    // Proceed with enabling speech recognition features
                case .denied:
                    print("User denied access to speech recognition")
                    // Inform the user that they need to enable permissions
                    // Optionally guide them to the app settings
                case .restricted:
                    print("Speech recognition restricted on this device")
                    // Handle the case where the device restricts speech recognition
                case .notDetermined:
                    print("Speech recognition not yet authorized")
                    // You might want to request permission again or check your logic
                @unknown default:
                    print("Unknown authorization status")
                    // Handle potential future cases
                }
            }
        }
        // Ensure a recognition task isn't already running
        if recognitionTask != nil {
            stopRecording()
            // Consider adding a brief delay or a different logic to avoid immediate restart in case of errors
            startRecording() // Restart recording after stopping
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            // No need to explicitly set the sample rate unless you have a specific requirement
            // The session will use the hardware's default sample rate
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
            return
        }

        // Ensure you have a recognition request ready to use
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0) // Use the input node's default format

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [unowned self] (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start: \(error.localizedDescription)")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let error = error as NSError? {
                print("Speech recognition error: \(error)")
                // Handle specific error codes here if needed
            }
            
            if let result = result {
                print("Recognized speech: \(result.bestTranscription.formattedString)")
                if result.isFinal {
                    // Handle final result
                    print("finished processing audio")
                    self.stopRecording()
                    self.startRecording()
                }
            } else {
                // Handle the case where no result is returned
            }
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    // SFSpeechRecognizerDelegate method to handle availability changes
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            // Speech recognition is available
        } else {
            // Speech recognition is not available
        }
    }
}

