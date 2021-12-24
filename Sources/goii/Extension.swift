//
//  File.swift
//  
//
//  Created by Lzzet on 2021/12/24.
//

import Foundation

public extension Array where Element: Equatable {
    func removeDuplicate() -> Array {
       return self.enumerated().filter { (index,value) -> Bool in
            return self.firstIndex(of: value) == index
        }.map { (_, value) in
            value
        }
    }
}

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
