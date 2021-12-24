//
//  File.swift
//  
//
//  Created by Lzzet on 2021/12/24.
//

import Foundation

struct Goi: Codable {
    var label = String()
    var accents = [Int]()
    var spell = String()
    var categories = [Category]()
    var meanings = [Meaning]();
    
    enum Category: String, Codable {
        case jidoushi = "自動詞"
        case tadoushi = "他動詞"
        case godanDoushi = "五段動詞"
        case ichidanDoushi = "一段動詞"
        case sahenDoushi = "サ変動詞"
        
    }
    
    struct Meaning: Codable {
        var explanation = String()
        var examples = [Example]()
        
        struct Example: Codable {
            var origin = String()
            var translation = String()
        }
    }
}

extension Goi {
    mutating func setLabel(_ label: String) {
        self.label = label
    }
    
    mutating func addAccent(_ accent: Int) {
        self.accents.append(accent)
        self.accents = self.accents.removeDuplicate()
    }
    
    mutating func setSpell(_ spell: String) {
        self.spell = spell
    }
    
    mutating func addCategory(_ category: Category) {
        self.categories.append(category)
        self.categories = self.categories.removeDuplicate()
    }
    
    mutating func addMeaning(_ meaning: Meaning) {
        self.meanings.append(meaning)
    }
    
    mutating func setLastMeaning(_ meaning: Meaning) {
        self.meanings[self.meanings.count - 1] = meaning
    }
    
    func getLastMeaning() -> Meaning {
        return self.meanings[self.meanings.count - 1]
    }
    
    mutating func newAndSetExplanation(_ explanation: String) {
        self.meanings.append(Meaning())
        self.meanings[self.meanings.count - 1].setExplanation(explanation)
    }
    
    mutating func newAndSetOrigin(_ origin: String) {
        self.meanings[self.meanings.count - 1].examples.append(Goi.Meaning.Example())
        self.meanings[self.meanings.count - 1].examples[self.meanings[self.meanings.count - 1].examples.count - 1].setOrigin(origin)
    }
    
    mutating func setLastTranslation(_ translation: String) {
        self.meanings[self.meanings.count - 1].examples[self.meanings[self.meanings.count - 1].examples.count - 1].setTranslation(translation)
    }
}

extension Goi.Meaning {
    mutating func setExplanation(_ explanation: String) {
        self.explanation = explanation
    }
    
    mutating func addExample(_ example: Example) {
        self.examples.append(example)
    }
}

extension Goi.Meaning.Example {
    mutating func setOrigin(_ origin: String) {
        self.origin = origin
    }
    
    mutating func setTranslation(_ translation: String) {
        self.translation = translation
    }
}

extension Goi {
    func toInfo() -> String {
        var info = "\(self.label) \(self.spell) \(self.accents)\n";
        for category in self.categories {
            info += "\(category.rawValue) "
        }
        for meaning in self.meanings {
            info += "\n# \(meaning.explanation)"
            for example in meaning.examples {
                info += "\n\t- \(example.origin)\n\t  \(example.translation)"
            }
        }
        return info
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["label"] = label
        dictionary["spell"] = spell
        dictionary["accents"] = accents
        
        var jsonCategories = [String]()
        for category in categories {
            jsonCategories.append(category.rawValue)
        }
        dictionary["categories"] = jsonCategories
        
        var jsonMeanings = [[String: Any]]()
        for meaning in meanings {
            var jsonExamples = [[String]]()
            for example in meaning.examples {
                jsonExamples.append([example.origin, example.translation])
            }
            jsonMeanings.append(["explanation": meaning.explanation,
                                 "examples": jsonExamples,
                                ])
        }
        dictionary["meanings"] = jsonMeanings
        
        return dictionary
    }
    
    func toJsonString() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        let jsonString = String(data: encodedData,
                                encoding: .utf8)!
        return jsonString
    }
    
    static func fromJson(_ jsonString: String) -> Goi {
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        return try! decoder.decode(Goi.self, from: jsonData)
    }
}
