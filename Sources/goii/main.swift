//
//  main.swift
//
//
//  Created by Lzzet on 2021/12/24.
//

import ArgumentParser
import Foundation

struct Goii: ParsableCommand {
    static let configuration = CommandConfiguration(
            abstract: "Randomness utilities.",
            subcommands: [Goii.Kb.self, Goii.Ep.self])
}

extension Goii {
    struct Kb: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Save words entered by the keyboard.")
        
        @Argument(help: "The directory where files are saved.")
        var saveFilePath: String
        
        func validate() throws {
            if (FileManager.default.fileExists(atPath: saveFilePath) == false) {
                throw ValidationError("'<file-path>' does not exist.")
            }
        }
        
        func run() {
            IOController.saveFilePath = saveFilePath
            IOController.initBuffer()
            let goiController = GoiController()
            goiController.run()
        }
    }
}

extension Goii {
    struct Ep: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Export json words to a Csv file.")
        
        @Argument(help: "The directory where files are saved.")
        var jsonFilePath: String
        
        func validate() throws {
            if (FileManager.default.fileExists(atPath: jsonFilePath) == false) {
                throw ValidationError("'<file-path>' does not exist.")
            }
        }
        
        func run() {
            IOController.saveJsonAsCsv(csvFileName: "words.csv", jsonDirPath: jsonFilePath)
        }
    }
}

Goii.main()
