//
//  DataManager.swift
//  Emoji Dictionary
//
//  Created by Arkadiy Grigoryanc on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

struct DataManager {
    private init() { }
    
    private struct Path {
        private init() { }
        
        static var component = "emojis_Dictionary"
        static var `extension` = "plist"
    }
    
    private static var url: URL {
        let documentDerictory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDerictory.appendingPathComponent(Path.component).appendingPathExtension(Path.extension)
        
        return archiveURL
    }
    
    enum DataManagerError: Error {
        case canNotFetchEmojis(message: String)
    }
    
    static func writeEmojisDictionary() throws {
        try reWriteEmoji(Emojis.loadSample())
    }
    
    static func fetchEmojis() throws -> Emojis {
        
        do {
            let data = try Data(contentsOf: url)
            guard let emojis = Emojis(from: data) else { throw DataManagerError.canNotFetchEmojis(message: "Can't fetch emojis from derictory")}
            return emojis
        } catch let error {
            throw error
        }
        
    }
    
    static func reWriteEmoji(_ emojis: Emojis) throws {
        
        guard let data = emojis.encoded else { return }
        
        try data.write(to: url, options: .noFileProtection)
        
    }
    
}
