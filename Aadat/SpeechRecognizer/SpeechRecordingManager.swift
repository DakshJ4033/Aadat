import AVFoundation
import Foundation
import Speech

class SpeechRecognizerViewModel: ObservableObject {
    private var speechRecognitionManager = SpeechRecordingManager()
    
    func startRecordingProcess() {
        speechRecognitionManager.startRecording()
    }
}

class SpeechRecordingManager: NSObject {
    private let audioEngine = AVAudioEngine()
    private var outputFile: AVAudioFile?
    private var recordingTimer: Timer?
    private var isRecording = false
    private let audioFilename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recordedAudio.m4a")
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
        isRecording.toggle()
    }
    
    func startTimer() {
        // Stop recording if it's already running to ensure a clean start
        if isRecording {
            stopRecording()
        }
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.toggleRecording()
        }
    }
    
    func stopTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        if isRecording {
            stopRecording()
        }
    }
    
    private func startRecording() {
        deleteExistingAudioFile() // Ensure any existing file is removed
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
            return
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
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
    
    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        try? AVAudioSession.sharedInstance().setActive(false)
        isRecording = false
        print("Recording Stopped")
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
