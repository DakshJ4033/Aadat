//
//  LanguageIdentifier.swift
//  Aadat
//
//  Created by Daksh Jain on 3/7/24.
//
import AVFoundation
import AudioToolbox
import Foundation

class LanguageIdentifierViewModel: ObservableObject {
    private let apiUrl = "https://api-inference.huggingface.co/models/facebook/mms-lid-126"
    private let token = "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" // TODO: add token to .env file for security
    
    func identifyLanguage(fromAudioFileAt url: URL) {
        // function to identify language spoken from provided url to .wav audio file
        guard let audioData = try? Data(contentsOf: url) else {
            print("Failed to load file")
            return
        }
        // set up POST request
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = audioData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // completion handler for http request
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
        // start network request defined by URLSessionDataTask
        task.resume()
    }
}
