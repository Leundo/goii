//
//  GoiController.swift
//  
//
//  Created by Lzzet on 2021/12/24.
//

import Foundation
import ArgumentParser

class GoiController {
    var goi = Goi()
    var focus = Focus.label
    var histories = [(goi: Goi, focus: Focus)]()
    
    static let commands = [
        "\\quit": Command.quit,
        "\\q": .quit,
        "\\undo": .undo,
        "\\u": .undo,
        "\\save": .save,
        "\\s": .save,
        "\\info": .info,
        "\\i": .info,
    ]
    
    enum Focus {
        case label
        case accent
        case spell
        case category
        case unsteadiness
        case explanation(i: Int)
        case origin(i:Int, j: Int)
        case translation(i:Int, j: Int)
    }
    
    enum Command {
        case undo
        case quit
        case save
        case info
    }
    
}

extension GoiController {
    func clear() {
        self.goi = Goi()
        self.histories = []
    }
    
    func undo() {
        if let lastOne = histories.popLast() {
            goi = lastOne.goi
            focus = lastOne.focus
        } else {
            IOController.log("Can not undo because of empty history.", .warning)
        }
    }
    
    func run() {
        var text: String? = nil
        do {
            try text = IOController.scanf()
        } catch {
            IOController.log("\(error)", .error)
            return
        }
        
        if let text = text?.trimmingCharacters(in: .whitespaces) {
            if (GoiController.commands[text] == nil) {
                switch focus {
                case .label:
                    setLabel(text)
                    
                case .spell:
                    setSpell(text)
                    
                case .accent:
                    setAccents(text)
                    
                case .category:
                    setCategories(text)
                    
                case .unsteadiness:
                    handleUnsteadiness(text)
                    
                case .explanation(let i):
                    setExplanation(text, i)
                    
                case .origin(_, _):
                    _ = 0
                    
                case .translation(let i, let j):
                    setTranslation(text, i, j)
                    
                }
            }
            
            if (GoiController.commands[text] == nil) {
                run()
                
            } else if (GoiController.commands[text] == .undo) {
                undo()
                run()
                
            } else if (GoiController.commands[text] == .quit) {
                return
                
            } else if (GoiController.commands[text] == .save) {
                if (goi.label != "") {
                    IOController.log(goi.toInfo())
                    IOController.log("")
                    
                    IOController.write(fileName: "\(goi.label).json", text: goi.toJsonString())
                    IOController.write(fileName: "\(goi.label).txt", text: goi.toInfo())
                    
                } else {
                    IOController.log("Can not save because of empty label", .warning)
                }
                clear()
                focus = .label
                run()
                
            } else if (GoiController.commands[text] == .info) {
                IOController.log(goi.toInfo())
                IOController.log("")
                run()
            }

        } else {
            IOController.log("There is no input.", .warning)
            run()
        }
        
        
    }
}

extension GoiController {
    func setLabel(_ text: String) {
        histories.append((goi: goi, focus: focus))
        goi.setLabel(text)
        focus = .spell
    }
    
    func setSpell(_ text: String) {
        histories.append((goi: goi, focus: focus))
        goi.setSpell(text)
        focus = .accent
    }
    
    func setAccents(_ text: String) {
        histories.append((goi: goi, focus: focus))
        let accents = text.components(separatedBy: " ")
        for item in accents {
            if let accent = Int(item) {
                goi.addAccent(accent)
            } else {
                undo()
                IOController.log("Fail to convert \"\(item)\" to accent. Please try again.", .warning)
                return
            }
        }
        focus = .category
    }
    
    func setCategories(_ text: String) {
        histories.append((goi: goi, focus: focus))
        let categories = text.components(separatedBy: " ")
        for item in categories {
            if let category = Config.goiCategoryConfig[item] {
                goi.addCategory(category)
            } else {
                undo()
                IOController.log("Fail to convert \"\(item)\" to category. Please try again.", .warning)
                return
            }
        }
        focus = .explanation(i: -1)
    }
    
    func handleUnsteadiness(_ text: String) {
        histories.append((goi: goi, focus: focus))
        
        if (text.hasPrefix(Config.explanationPrefix)) {
            goi.newAndSetExplanation(String(text.dropFirst(Config.explanationPrefix.count)).trimmingCharacters(in: .whitespaces))
            focus = .unsteadiness
            
        } else {
            goi.newAndSetOrigin(text)
            focus = .translation(i: -1, j: -1)
        }
    }
    
    func setExplanation(_ text: String, _ i: Int) {
        histories.append((goi: goi, focus: focus))
        if (i == -1) {
            if (text.hasPrefix(Config.explanationPrefix)) {
                goi.newAndSetExplanation(String(text.dropFirst(Config.explanationPrefix.count)).trimmingCharacters(in: .whitespaces))
            } else {
                undo()
                IOController.log("Fail to read the prefix of explanation.", .warning)
                return
            }
        }
        focus = .unsteadiness
    }
    
    func setTranslation(_ text: String, _ i: Int, _ j: Int) {
        histories.append((goi: goi, focus: focus))
        goi.setLastTranslation(text)
        focus = .unsteadiness
    }
}
