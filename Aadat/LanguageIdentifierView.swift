//
//  LanguageIdentifierView.swift
//  Aadat
//
//  Created by Daksh Jain on 2/27/24.
//

import Foundation
import SwiftUI

class LanguageIdentifierViewModel: ObservableObject {
    private let apiUrl = "https://api-inference.huggingface.co/models/facebook/mms-lid-126"
    private let token = "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" // Replace with your actual token
    
    func identifyLanguage(fromAudioFileAt url: URL) {
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
}

struct LanguageIdentifierView: View {
    @StateObject private var viewModel = LanguageIdentifierViewModel()
    
    var body: some View {
        Button("Identify Language") {
            // Call the function with the URL of your audio file
            let fileUrl = URL(fileURLWithPath: "/Users/dakshjain/Downloads/SampleClip.flac") // Update with the actual path
            viewModel.identifyLanguage(fromAudioFileAt: fileUrl)
        }
    }
}

#Preview {
    LanguageIdentifierView()
}
