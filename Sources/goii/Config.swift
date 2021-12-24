//
//  Config.swift
//  
//
//  Created by Lzzet on 2021/12/24.
//

import Foundation

class Config {
    static let goiCategoryConfig = [
        "自動詞": Goi.Category.jidoushi,
        "自动词": .jidoushi,
        "vt": .jidoushi,
        
        "他動詞": .tadoushi,
        "他动词": .tadoushi,
        "vi": .tadoushi,
        
        "五段動詞": .godanDoushi,
        "五段动词": .godanDoushi,
        "一類動詞": .godanDoushi,
        "一类动词": .godanDoushi,
        "v1": .godanDoushi,
        
        "一段動詞": .ichidanDoushi,
        "一段动词": .ichidanDoushi,
        "二類動詞": .ichidanDoushi,
        "二类动词": .ichidanDoushi,
        "v2": .ichidanDoushi,
        
        "サ変動詞": .sahenDoushi,
        "サ变动词": .sahenDoushi,
        "三類動詞": .sahenDoushi,
        "三类动词": .sahenDoushi,
        "v3": .sahenDoushi,
        
        "形容動詞": .keiyouDoushi,
        "形容动词": .keiyouDoushi,
        "na": .keiyouDoushi,
        
        "形容詞": .keiyoushi,
        "形容词": .keiyoushi,
        "a": .keiyoushi,
        
        "名詞": .meishi,
        "名词": .meishi,
        "n": .meishi,
    ]
    
    static let explanationPrefix = "$"
}
