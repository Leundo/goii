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
            subcommands: [Goii.Kb.self, Goii.Ep.self, Goii.Fl.self])
}

extension Goii {
    struct Kb: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Save words entered by the keyboard.")
        
        @Argument(help: "The directory where word files will are saved.")
        var saveDirPath: String
        
        func validate() throws {
            if (FileManager.default.fileExists(atPath: saveDirPath) == false) {
                throw ValidationError("'<save-dir-path>' does not exist.")
            }
        }
        
        func run() {
            IOController.saveFilePath = saveDirPath
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
        
        @Argument(help: "The directory where json files are saved.")
        var jsonDirPath: String
        
        func validate() throws {
            if (FileManager.default.fileExists(atPath: jsonDirPath) == false) {
                throw ValidationError("'<json-dir-path>' does not exist.")
            }
        }
        
        func run() {
            IOController.saveJsonAsCsv(csvFileName: "words.csv", jsonDirPath: jsonDirPath)
        }
    }
}

extension Goii {
    struct Fl: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Save words read by file.")
        
        @Argument(help: "The directory where word files will are saved.")
        var saveDirPath: String
        @Argument(help: "The directory where input files are saved.")
        var inputFilePath: String
        
        func validate() throws {
            if (FileManager.default.fileExists(atPath: saveDirPath) == false) {
                throw ValidationError("'<save-dir-path>' does not exist.")
            }
            if (FileManager.default.fileExists(atPath: inputFilePath) == false) {
                throw ValidationError("'<input-file-path>' does not exist.")
            }
        }
        
        func run() {
            IOController.saveFilePath = saveDirPath
            IOController.inputFilePath = inputFilePath;
            IOController.inputMode = .file
            IOController.initBuffer()
            let goiController = GoiController()
            goiController.run()
        }
    }
}

Goii.main()
