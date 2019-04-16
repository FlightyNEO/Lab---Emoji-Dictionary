//
//  Emoji.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

class Emoji: Codable {
    
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    init(symbol: String = "", name: String = "", description: String = "", usage: String = "") {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
    }
    
}

extension Emoji: Comparable {
    
    static func == (lhs: Emoji, rhs: Emoji) -> Bool {
        return lhs.symbol == rhs.symbol
    }
    
    static func < (lhs: Emoji, rhs: Emoji) -> Bool {
        return lhs.symbol < rhs.symbol
    }
    
}
