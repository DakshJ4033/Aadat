import AVFoundation
import Foundation
import Speech

class SpeechRecognizerViewModel: ObservableObject {
    private var speechRecognitionManager = SpeechRecordingManager()
    
    func startRecordingProcess() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                DispatchQueue.main.async {
                    self.speechRecognitionManager.startRecording()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.speechRecognitionManager.stopRecording()
                }
            } else {
                print("permission denied")
            }
        }
    }
}

class SpeechRecordingManager: NSObject, AVAudioRecorderDelegate {
    private let languageIdentifier = LanguageIdentifierViewModel()
    private let audioEngine = AVAudioEngine()
    private var outputFile: AVAudioFile?
    private var recordingTimer: Timer?
    private var isRecording = false
    private let audioFilename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recordedAudio.wav")

//    func startRepeatingProcess() {
//        // Ensure recording starts immediately upon this call
//        toggleRecording()
//        
//        // Set up a repeating timer that toggles recording state every 5 seconds
//        recordingTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
//            self?.toggleRecording()
//        }
//    }
//    
//    private func toggleRecording() {
//        if isRecording {
//            stopRecording()
//        } else {
//            // Start recording after a delay to ensure it happens after stopping
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.startRecording()
//            }
//        }
//    }
    
    func startRecording() {
        //deleteExistingAudioFile() // Ensure any existing file is removed
        deleteExistingAudioFile()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
            return
        }
        
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
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
            do {
                try self?.outputFile?.write(from: buffer)
            } catch {
                print("Failed to write audio to file: \(error.localizedDescription)")
            }
        }
        
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
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        try? AVAudioSession.sharedInstance().setActive(false)
        isRecording = false
        print("Recording Stopped")
        
        // Check if the audio file exists and is not empty
         do {
             let attributes = try FileManager.default.attributesOfItem(atPath: audioFilename.path)
             let fileSize = attributes[FileAttributeKey.size] as! UInt64
             if fileSize > 0 {
                 print("Recording stopped. File size: \(fileSize) bytes")
                 // Continue with file processing
             } else {
                 print("Recording stopped. File is empty.")
                 // Handle the case where the file is empty as needed
             }
         } catch {
             print("Error accessing file: \(error.localizedDescription)")
         }
        languageIdentifier.identifyLanguage(fromAudioFileAt: audioFilename)
        // start recording again after identifying language
        //self.toggleRecording()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
