//
//  File.swift
//  
//
//  Created by Lzzet on 2021/12/24.
//

import Foundation

class Config {
    static let goiCategoryConfig = [
        "自動詞": Goi.Category.jidoushi,
        
        "他動詞": .tadoushi,
        
        "五段動詞": .godanDoushi,
        
        "一段動詞": .ichidanDoushi,
        
        "サ変動詞": .sahenDoushi,
    ]
    
    static let explanationPrefix = "$"
}
