//
//  LanguageIdentifier.swift
//  Aadat
//
//  Created by Daksh Jain on 3/7/24.
//
import AVFoundation
import AudioToolbox
import Foundation

struct LanguageData: Codable {
    var label: String
    var score: Double
}

class LanguageIdentifier {
    private let apiUrl = "https://api-inference.huggingface.co/models/facebook/mms-lid-126"
    private let token = "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" // TODO: add token to .env file for security
    
    func identifyLanguage(fromAudioFileAt url: URL, completion: @escaping (String?) -> Void) {
        guard let audioData = try? Data(contentsOf: url) else {
            print("Failed to load file")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = audioData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            do {
                let languageScores = try JSONDecoder().decode([LanguageData].self, from: data)
                
                if let highestScore = languageScores.first {
                    DispatchQueue.main.async {
                        print("Highest scoring language: \(highestScore.label) with score \(highestScore.score)")
                        completion(highestScore.label)
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
