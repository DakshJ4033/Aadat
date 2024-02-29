//
//  LanguageIdentifierView.swift
//  Aadat
//
//  Created by Daksh Jain on 2/27/24.
//

import AVFoundation
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
    
    func convertM4AToWAV(inputURL: URL, outputURL: URL, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        // function to convert .m4a files to .wav
        let asset = AVURLAsset(url: inputURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            completionHandler(false, NSError(domain: "com.yourapp.audioconversion", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cannot create export session"]))
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .wav
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completionHandler(true, nil)
            case .failed:
                print("Conversion failed: \(exportSession.error?.localizedDescription ?? "Unknown error")")
                completionHandler(false, exportSession.error)
            case .cancelled:
                completionHandler(false, NSError(domain: "com.yourapp.audioconversion", code: 1, userInfo: [NSLocalizedDescriptionKey: "Conversion cancelled"]))
            default:
                completionHandler(false, NSError(domain: "com.yourapp.audioconversion", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unknown conversion error"]))
            }
        }
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
            print(inputURL)
            let outputURL = documentsDirectory.appendingPathComponent("SampleClip.wav")
            
            viewModel.convertM4AToWAV(inputURL: inputURL, outputURL: outputURL) { success, error in
                if success {
                    print("Conversion to WAV successful!")
                    // You can now proceed to use the .wav file as needed
                } else {
                    print("Conversion failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
            
            viewModel.identifyLanguage(fromAudioFileAt: outputURL)
        }
    }
}

#Preview {
    LanguageIdentifierView()
}
