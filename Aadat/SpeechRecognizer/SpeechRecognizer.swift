//
//  File.swift
//  Aadat
//
//  Created by Daksh Jain on 3/1/24.
//

import Foundation
import Speech

class SpeechRecognitionManager: NSObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }
    
    func startRecording() {
        // Check if a recognition task is already running
        if recognitionTask != nil {
            stopRecording()
            startRecording() // Restart recording after stopping
            return
        }
        
        // Setup audio engine and speech recognizer
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // Check if the recognizer is available for the device and locale.
        guard let recognitionRequest = recognitionRequest, let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("Speech recognition is not available.")
            return
        }
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Use result.bestTranscription.formattedString to get the recognized text
                print("Recognized speech: \(result.bestTranscription.formattedString)")
                isFinal = result.isFinal
//                if result.bestTranscription.formattedString.contains("some Japanese text") { // Implement your own logic to determine if it's Japanese
//                    // Detected Japanese, perform your task here
//                }
                print("test")
            }
            
            if error != nil || isFinal {
                // Stop the current recognition task and audio engine, then restart if needed
                self.stopRecording()
                self.startRecording() // Restart recording
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

