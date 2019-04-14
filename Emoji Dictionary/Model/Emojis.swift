//
//  Emojis.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

typealias Emojis = [Emoji]

extension Emojis {
    
    var title: String {
        return "Словарь Эмодзи"
    }
    
    static func loadSample() -> Emojis {
        
        let emojis = [
            Emoji(symbol: "👻", name: "Привидение", description: "Серенькое привидение", usage: "Напуган"),
            Emoji(symbol: "🌏", name: "Земля", description: "Земной шар", usage: "Глобальность"),
            Emoji(symbol: "🤓", name: "Ботаник", description: "Смайлик в очках", usage: "Умный"),
            Emoji(symbol: "⭐️", name: "Звезда", description: "Жёлтая пятиконечная звезда с очень длинным описанием", usage: "Выше только звёзды"),
        ]
        
        return emojis.sorted()
        
    }
    
}
