//
//  LanguageIdentifierView.swift
//  Aadat
//
//  Created by Daksh Jain on 2/27/24.
//

import AVFoundation
import AudioToolbox
import Foundation
import SwiftUI

class LanguageIdentifierViewModel: ObservableObject {
    private let apiUrl = "https://api-inference.huggingface.co/models/facebook/mms-lid-126"
    private let token = "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" // TODO: add token to .env file for security
    
    func identifyLanguage(fromAudioFileAt url: URL) {
        // function to identify language spoken from provided url to .wav audio file
        guard let audioData = try? Data(contentsOf: url) else {
            print("Failed to load file")
            return
        }
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = audioData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let responseString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        // Handle your response here. For example, update your UI.
                        print("Response: \(responseString)")
                    }
                }
            } else {
                print("HTTP Error: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            }
        }
        
        task.resume()
    }
    
    func copyFileToDocumentsDirectory(fileName: String, fileExtension: String) {
        // function that checks if the file already exists in the Documents directory (to avoid unnecessary copies) and, if not, copies it there from the app bundle.
        let fileManager = FileManager.default
        guard let sourceUrl = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Source file not found.")
            return
        }
        
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectory.appendingPathComponent("\(fileName).\(fileExtension)")
        
        if fileManager.fileExists(atPath: destinationUrl.path) {
            print("File already exists in Documents directory.")
            return
        }
        
        do {
            try fileManager.copyItem(at: sourceUrl, to: destinationUrl)
            print("File copied to Documents directory.")
        } catch {
            print("Could not copy file to Documents directory: \(error.localizedDescription)")
        }
    }
    
    func convertAudio(_ url: URL, outputURL: URL) {
        var error: OSStatus = noErr
        var destinationFile: ExtAudioFileRef? = nil
        var sourceFile: ExtAudioFileRef? = nil

        var srcFormat: AudioStreamBasicDescription = AudioStreamBasicDescription()
        var dstFormat: AudioStreamBasicDescription = AudioStreamBasicDescription()

        // Check if file exists before attempting to open
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("File does not exist at path: \(url.path)")
            return
        }

        error = ExtAudioFileOpenURL(url as CFURL, &sourceFile)
        guard error == noErr else {
            print("Error opening source file: \(error)")
            return
        }

        var thePropertySize: UInt32 = UInt32(MemoryLayout.stride(ofValue: srcFormat))
        ExtAudioFileGetProperty(sourceFile!,
                                kExtAudioFileProperty_FileDataFormat,
                                &thePropertySize, &srcFormat)

        dstFormat.mSampleRate = 44100  // Set sample rate
        dstFormat.mFormatID = kAudioFormatLinearPCM
        dstFormat.mChannelsPerFrame = 1
        dstFormat.mBitsPerChannel = 16
        dstFormat.mBytesPerPacket = 2 * dstFormat.mChannelsPerFrame
        dstFormat.mBytesPerFrame = 2 * dstFormat.mChannelsPerFrame
        dstFormat.mFramesPerPacket = 1
        dstFormat.mFormatFlags = kLinearPCMFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger

        // Create destination file
        error = ExtAudioFileCreateWithURL(
            outputURL as CFURL,
            kAudioFileWAVEType,
            &dstFormat,
            nil,
            AudioFileFlags.eraseFile.rawValue,
            &destinationFile)
        print("Error 1 in convertAudio: \(error.description)")

        error = ExtAudioFileSetProperty(sourceFile!,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        print("Error 2 in convertAudio: \(error.description)")

        error = ExtAudioFileSetProperty(destinationFile!,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        print("Error 3 in convertAudio: \(error.description)")

        let bufferByteSize: UInt32 = 32768
        var srcBuffer = [UInt8](repeating: 0, count: Int(bufferByteSize))
        var sourceFrameOffset: ULONG = 0

        while true {
            var numFrames: UInt32 = 0

            if dstFormat.mBytesPerFrame > 0 {
                numFrames = bufferByteSize / dstFormat.mBytesPerFrame
            }

            srcBuffer.withUnsafeMutableBytes { ptr in
                var fillBufList = AudioBufferList(
                    mNumberBuffers: 1,
                    mBuffers: AudioBuffer(
                        mNumberChannels: dstFormat.mChannelsPerFrame,
                        mDataByteSize: bufferByteSize,
                        mData: ptr.baseAddress?.assumingMemoryBound(to: UInt8.self)
                    )
                )

                error = ExtAudioFileRead(sourceFile!, &numFrames, &fillBufList)
            }
            print("Error 4 in convertAudio: \(error.description)")

            if numFrames == 0 {
                error = noErr
                break
            }

            sourceFrameOffset += numFrames

            srcBuffer.withUnsafeMutableBytes { ptr in
                var fillBufList = AudioBufferList(
                    mNumberBuffers: 1,
                    mBuffers: AudioBuffer(
                        mNumberChannels: dstFormat.mChannelsPerFrame,
                        mDataByteSize: bufferByteSize,
                        mData: ptr.baseAddress?.assumingMemoryBound(to: UInt8.self)
                    )
                )

                error = ExtAudioFileWrite(destinationFile!, numFrames, &fillBufList)
            }
            print("Error 5 in convertAudio: \(error.description)")
        }

        error = ExtAudioFileDispose(destinationFile!)
        print("Error 6 in convertAudio: \(error.description)")
        error = ExtAudioFileDispose(sourceFile!)
        print("Error 7 in convertAudio: \(error.description)")
    }
}
    
    struct LanguageIdentifierView: View {
        @StateObject private var viewModel = LanguageIdentifierViewModel()
        
        var body: some View {
            Button("Identify Language") {
                // Example of calling the function
                viewModel.copyFileToDocumentsDirectory(fileName: "SampleClip", fileExtension: "m4a")
                
                // After copying, you can retrieve the file URL and pass it to your conversion function
                let fileManager = FileManager.default
                let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let inputURL = documentsDirectory.appendingPathComponent("SampleClip.m4a")
                let outputURL = documentsDirectory.appendingPathComponent("out.wav")
                
                viewModel.convertAudio(inputURL, outputURL: outputURL)
                viewModel.identifyLanguage(fromAudioFileAt: outputURL)
            }
        }
    }
    
    #Preview {
        LanguageIdentifierView()
    }
