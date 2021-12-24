//
//  File.swift
//  
//
//  Created by Lzzet on 2021/12/24.
//

import Foundation

class IOController {
    static var filePath = "./";
    static var mock = """

"""
    
    static func scanf() -> String? {
        return readLine()
    }
    
    static func log(_ text: String, _ category: IOController.Category? = nil) {
        if let category = category {
            switch category {
            case .warning:
                print("warning: " + text)
            case .error:
                print("error: " + text)
            case .info:
                print("info: " + text)
            }
        } else {
            print(text)
        }
    }
    
    static func write(fileName: String, text: String, filePath: String = IOController.filePath) {
        let fileUrl = URL(fileURLWithPath: filePath).appendingPathComponent(fileName)
        
        do {
            try text.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            IOController.log("Fail to write into \(fileUrl)", .error)
        }
        
    }
    
    enum Category {
        case warning
        case error
        case info
    }
}
