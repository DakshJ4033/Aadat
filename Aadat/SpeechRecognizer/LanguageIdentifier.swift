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
    
    private let languageDictionary = [
        "ara": "Arabic",
        "cmn": "Mandarin Chinese",
        "eng": "English",
        "spa": "Spanish",
        "fra": "French",
        "mlg": "Malagasy",
        "swe": "Swedish",
        "por": "Portuguese",
        "vie": "Vietnamese",
        "ful": "Fula",
        "sun": "Sundanese",
        "asm": "Assamese",
        "ben": "Bengali",
        "zlm": "Malay (Standard)",
        "kor": "Korean",
        "ind": "Indonesian",
        "hin": "Hindi",
        "tuk": "Turkmen",
        "urd": "Urdu",
        "aze": "Azerbaijani",
        "slv": "Slovenian",
        "mon": "Mongolian",
        "hau": "Hausa",
        "tel": "Telugu",
        "swh": "Swahili",
        "bod": "Tibetan",
        "rus": "Russian",
        "tur": "Turkish",
        "heb": "Hebrew",
        "mar": "Marathi",
        "som": "Somali",
        "tgl": "Tagalog",
        "tat": "Tatar",
        "tha": "Thai",
        "cat": "Catalan",
        "ron": "Romanian",
        "mal": "Malayalam",
        "bel": "Belarusian",
        "pol": "Polish",
        "yor": "Yoruba",
        "nld": "Dutch",
        "bul": "Bulgarian",
        "hat": "Haitian Creole",
        "afr": "Afrikaans",
        "isl": "Icelandic",
        "amh": "Amharic",
        "tam": "Tamil",
        "hun": "Hungarian",
        "hrv": "Croatian",
        "lit": "Lithuanian",
        "cym": "Welsh",
        "fas": "Persian",
        "mkd": "Macedonian",
        "ell": "Greek",
        "bos": "Bosnian",
        "deu": "German",
        "sqi": "Albanian",
        "jav": "Javanese",
        "nob": "Norwegian Bokmål",
        "uzb": "Uzbek",
        "snd": "Sindhi",
        "lat": "Latin",
        "nya": "Chichewa",
        "grn": "Guaraní",
        "mya": "Burmese",
        "orm": "Oromo",
        "lin": "Lingala",
        "hye": "Armenian",
        "yue": "Cantonese",
        "pan": "Punjabi",
        "jpn": "Japanese",
        "kaz": "Kazakh",
        "npi": "Nepali",
        "kat": "Georgian",
        "guj": "Gujarati",
        "kan": "Kannada",
        "tgk": "Tajik",
        "ukr": "Ukrainian",
        "ces": "Czech",
        "lav": "Latvian",
        "bak": "Bashkir",
        "khm": "Khmer",
        "fao": "Faroese",
        "glg": "Galician",
        "ltz": "Luxembourgish",
        "lao": "Lao",
        "mlt": "Maltese",
        "sin": "Sinhala",
        "sna": "Shona",
        "ita": "Italian",
        "srp": "Serbian",
        "mri": "Maori",
        "nno": "Norwegian Nynorsk",
        "pus": "Pashto",
        "eus": "Basque",
        "ory": "Odia",
        "lug": "Ganda",
        "bre": "Breton",
        "luo": "Luo",
        "slk": "Slovak",
        "fin": "Finnish",
        "dan": "Danish",
        "yid": "Yiddish",
        "est": "Estonian",
        "ceb": "Cebuano",
        "war": "Waray",
        "san": "Sanskrit",
        "kir": "Kyrgyz",
        "oci": "Occitan",
        "wol": "Wolof",
        "haw": "Hawaiian",
        "kam": "Kamba",
        "umb": "Umbundu",
        "xho": "Xhosa",
        "epo": "Esperanto",
        "zul": "Zulu",
        "ibo": "Igbo",
        "abk": "Abkhaz",
        "ckb": "Central Kurdish",
        "nso": "Northern Sotho",
        "gle": "Irish",
        "kea": "Kabuverdianu",
        "ast": "Asturian",
        "sco": "Scots",
        "glv": "Manx",
        "ina": "Interlingua"
    ]
    
    func identifyLanguage(fromAudioFileAt url: URL, completion: @escaping (String) -> Void) {
        guard let audioData = try? Data(contentsOf: url) else {
            print("Failed to load file")
            completion("nil")
            return
        }
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = audioData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion("nil")
                return
            }
            do {
                let languageScores = try JSONDecoder().decode([LanguageData].self, from: data)
                
                if let highestScore = languageScores.first {
                    DispatchQueue.main.async {
                        if let language = self.languageDictionary[highestScore.label], highestScore.score > 0.75 {
                            print("language: \(highestScore.label), score: \(highestScore.score)")
                            completion(language)
                        } else {
                            print("NULL: language: \(highestScore.label), score: \(highestScore.score)")
                            completion("nil")
                        }
                    }
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
                completion("nil")
            }
        }
        task.resume()
    }
}
