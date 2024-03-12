import AVFoundation
import Foundation
import Speech
import SwiftData

class SpeechRecognitionModel: ObservableObject {
    @Published var identifiedLanguage: String
    @Published var lastAutomatedTaskLanguage: String
    
    init(identifiedLanguage: String) {
        self.identifiedLanguage = ""
        self.lastAutomatedTaskLanguage = ""
    }

    private let languageIdentifier = LanguageIdentifier()
    private let audioEngine = AVAudioEngine()
    private var outputFile: AVAudioFile?
    private var isRecording = false
    private let audioFilename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recordedAudio.wav")
    private var recordingTimer: Timer?
    
    func startRecordingProcess() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                DispatchQueue.main.async {
                    // Set up a repeating timer that toggles recording state every 5 seconds
                    self.recordingTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
                        DispatchQueue.global().async {
                            self?.toggleRecording()
                        }
                    }
                    // Ensure recording starts immediately upon this call
                    self.toggleRecording()
                }
            } else {
                print("permission denied")
            }
        }
    }
    
    private func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            // Start recording after a delay to ensure it happens after stopping
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                self.startRecording()
            }
        }
    }
    
    func startRecording() {
        // Ensure any existing file is removed
        deleteExistingAudioFile()
        // set up AVAudioSession to communicate with OS for hardware access
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
            return
        }
        // set up settings to record in .wav format
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            outputFile = try AVAudioFile(forWriting: audioFilename, settings: settings)
        } catch {
            print("Failed to create audio file: \(error.localizedDescription)")
            return
        }
        // set up AVAudioEngine input node to get microphone input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        // install "tap" on input node to listen to audio node's output (audio coming from microphone)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
            do {
                // write to output file buffer
                try self?.outputFile?.write(from: buffer)
            } catch {
                print("Failed to write audio to file: \(error.localizedDescription)")
            }
        }
        // start audio engine to begin flow of audio data from input node (microphone) to the tap, which writes data to file
        do {
            try audioEngine.start()
        } catch {
            print("Could not start audio engine: \(error.localizedDescription)")
            return
        }
        
        isRecording = true
        print("Recording Started")
    }
    
    func stopRecording() {
        // stop audio engine's flow of audio data -> output file
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        // end AVAudioSession as we no longer need to access microphone hardware
        try? AVAudioSession.sharedInstance().setActive(false)
        isRecording = false
        print("Recording Stopped")
        // Check if the audio file exists and is not empty
         do {
             let attributes = try FileManager.default.attributesOfItem(atPath: audioFilename.path)
             let fileSize = (attributes[FileAttributeKey.size] as? UInt64) ?? 0
             if fileSize > 0 {
                 print("Recording stopped. File size: \(fileSize) bytes")
             } else {
                 print("Recording stopped. File is empty.")
                 return
             }
         } catch {
             print("Error accessing file: \(error.localizedDescription)")
             return
         }
        // identify language spoken in audio file
        DispatchQueue.global().async {
            self.languageIdentifier.identifyLanguage(fromAudioFileAt: self.audioFilename) { languageLabel in
                DispatchQueue.main.async {
                    if languageLabel != "nil" {
                        self.identifiedLanguage = languageLabel
                    }
                }
            }
        }
    }
    
    private func deleteExistingAudioFile() {
        if FileManager.default.fileExists(atPath: audioFilename.path) {
            do {
                try FileManager.default.removeItem(at: audioFilename)
                print("Existing audio file deleted.")
            } catch {
                print("Could not delete existing audio file: \(error.localizedDescription)")
            }
        }
    }
}
