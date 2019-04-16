//
//  TableViewCellConfigurator.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

class TableViewCellConfigurator {
    func configure(_ cell: EmojiCell, with emoji: Emoji) {
        cell.emojiSymbolLabel.text = emoji.symbol
        cell.emojiNameLabel.text = emoji.name
        cell.emojiDescriptionLabel.text = emoji.description
    }
}
