//
//  IOController.swift
//  
//
//  Created by Lzzet on 2021/12/24.
//

import Foundation

class IOController {
    
    enum Category {
        case warning
        case error
        case info
    }
    
    enum InputMode {
        case keyboard
        case mockData
        case file
    }
    
    static var saveFilePath = "./";
    static var inputFilePath = "";
    static var inputMode = InputMode.mockData
    static var buffer = [String]()
    static var mockData = """
遊ぶ
あそぶ
0
自動詞 五段動詞
$ [楽しく] 玩；游玩；游戏
遊んでいる子供たちが狙われている
正在做游戏的孩子们被锁定为目标
昨日は何をして遊びましたか
昨天玩儿什么了？
$ [仕事せずに] 游荡；赋闲
遊んで暮らすご身分になりたいよ
我真想悠闲自得地过日子
受注が無くて職人が遊んでいる
没有订单, 工匠们都在赋闲
$ [酒色にふける] 吃喝嫖赌
若い時はずいぶん遊んだ
年轻时我可相当放荡
\\s
\\q
"""
}

extension IOController {
    static func initBuffer() {
        if (inputMode == .mockData) {
            buffer = mockData.components(separatedBy: "\n")
        } else if (inputMode == .file) {
            let fileUrl = URL(fileURLWithPath: inputFilePath)
            do {
                buffer = (try String(contentsOf: fileUrl, encoding: .utf8)).components(separatedBy: "\n")
            }
            catch {
                IOController.log("\(error)", .error)
            }
        }
    }
    
    static func scanf() throws -> String? {
        if (inputMode == .keyboard) {
            return readLine()
            
        } else if (buffer.count > 0) {
            return IOController.buffer.removeFirst()
            
        } else {
            throw RuntimeError("There is no input.")
        }
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
    
    static func write(fileName: String, text: String, filePath: String = IOController.saveFilePath) {
        let fileUrl = URL(fileURLWithPath: filePath).appendingPathComponent(fileName)
        
        do {
            try text.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            IOController.log("Fail to write into \(fileUrl)", .error)
        }
    }
    
    static func read(fileName: String, filePath: String) -> String {
        let fileUrl = URL(fileURLWithPath: filePath).appendingPathComponent(fileName)
        var text = ""
        do {
            text = try String(contentsOf: fileUrl, encoding: .utf8)
        }
        catch {
            IOController.log("Fail to write read into \(fileUrl)", .error)
        }
        return text
    }
    
    static func saveJsonAsCsv(csvFileName: String, jsonDirPath: String) {
        var csv = ""
        let csvFileUrl = URL(fileURLWithPath: jsonDirPath).appendingPathComponent(csvFileName)
        let jsonDirUrl =  URL(fileURLWithPath: jsonDirPath)
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: jsonDirUrl, includingPropertiesForKeys: nil)
            let jsonFileUrls = directoryContents.filter{ $0.pathExtension == "json" }
//            let jsonFileNames = jsonFiles.map{ $0.deletingPathExtension().lastPathComponent }
            for jsonFileUrl in jsonFileUrls {
                let jsonString = try String(contentsOf: jsonFileUrl, encoding: .utf8)
                csv += CsvManager.convertJsonToLine(jsonString: jsonString, separator: "\t")
            }
            try csv.write(to: csvFileUrl, atomically: false, encoding: .utf8)
        } catch {
            IOController.log("\(error)", .error)
        }
        
    }
}
