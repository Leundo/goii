//
//  CsvManager.swift
//  
//
//  Created by Lzzet on 2021/12/24.
//

import Foundation

class CsvManager {
    static func convertJsonToLine(jsonString: String, separator: String) -> String {
        let goi = Goi.fromJson(jsonString)
        
        var cookedAccent = ""
        if (goi.accents.count > 0) {
            cookedAccent += "\(goi.accents[0])"
        }
        if (goi.accents.count > 1) {
            for index in 1..<goi.accents.count {
                cookedAccent += ", \(goi.accents[index])"
            }
        }
        
        var cookedDetail = ""

        cookedDetail += "<div class=\"tag-box\">"
        for category in goi.categories {
            cookedDetail += "<span class=\"tag jp-font\">\(category.rawValue)</span>";
        }
        cookedDetail += "</div>";
        
        for meaning in goi.meanings {
            cookedDetail += "<div class=\"tango-card-tab\">";
            cookedDetail += "<div class=\"explain\"><p class=\"explain-word\">\(meaning.explanation)</p></div>";
            for example in meaning.examples {
                cookedDetail += "<div class=\"example\"><div class=\"example-info\"><div class=\"example-jp jp-font\">\(example.origin)</div><div class=\"example-zh zh-font\">\(example.translation)</div></div></div>";
            }
            cookedDetail += "</div>";
        }

        return "\(goi.label)\(separator)\(separator)\(goi.spell)\(separator)\(cookedAccent)\(separator)\(cookedDetail)\n"
    }
}
