//
//  main.swift
//
//
//  Created by Lzzet on 2021/12/24.
//

import ArgumentParser
import Foundation

struct Goii: ParsableCommand {
    
    @Argument(help: "The directory where files are saved.") var filePath: String
    
    func validate() throws {
        if (FileManager.default.fileExists(atPath: filePath) == false) {
            throw ValidationError("'<file-path>' does not exist.")
        }
    }
    
    func run() {
        IOController.filePath = filePath
        let goiController = GoiController()
        goiController.run()
    }
}

Goii.main()
