//
//  EmojiListViewController.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class EmojiListViewController: UITableViewController {
    
    let cellID = "EmojiCell"
    
    private let configurator = TableViewCellConfigurator()
    private var emojis = Emojis.loadSample()
    
    private var editingIndexPath: IndexPath?
    private var mode: Mode?
    
    private enum Mode {
        case edit, add, show
        
        var identifier: String {
            switch self {
            case .edit: return "EditEmojiIdentifier"
            case .add: return "AddEmojiIdentifier"
            case .show: return "ShowEmojiIdentifier"
            }
        }
    }
    
    override func viewDidLoad() {
        navigationItem.title = emojis.title
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
}

// MARK: - Tble view data source & delegate
extension EmojiListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emoji = emojis[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! EmojiCell
        
        configurator.configure(cell, with: emoji)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (_, indexPath) in
            self.editingIndexPath = indexPath
            self.performSegue(withIdentifier: Mode.edit.identifier, sender: indexPath.row)
        }
        
        editAction.backgroundColor = .orange
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            self.emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editingIndexPath = indexPath
    }
}

// MARK: - Navigation
extension EmojiListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let emojiDetailViewController = segue.destination as? EmojiDetailViewController {
            
            emojiDetailViewController.delegate = self
            
            switch segue.identifier {
            case Mode.edit.identifier:
                guard let row = sender as? Int else { return }
                emojiDetailViewController.emoji = self.emojis[row]
                emojiDetailViewController.title = "Edit"
                emojiDetailViewController.isEditable = true
                mode = .edit
            case Mode.add.identifier:
                emojiDetailViewController.title = "Add"
                emojiDetailViewController.isEditable = true
                mode = .add
            case Mode.show.identifier:
                guard let row = tableView.indexPathForSelectedRow?.row else { return }
                let emoji = self.emojis[row]
                emojiDetailViewController.emoji = emoji
                emojiDetailViewController.title = emoji.name
                emojiDetailViewController.isEditable = false
                mode = .show
            default: break
            }
            
        }
        
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        self.editingIndexPath = nil
        self.mode = nil
    }
    
}

extension EmojiListViewController: EmojiDetailViewControllerDelegate {
    
    func didUpdateEmoji(_ emoji: Emoji) {
        
        guard let mode = mode else { return }
        
        switch mode {
        case .add:
            let index = emojis.insertionIndexOf(emoji, <)
            let indexPath = IndexPath(row: index, section: 0)
            emojis.insert(emoji, at: index)
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .edit, .show:
            guard let indexPath = editingIndexPath else { return }
            emojis[indexPath.row] = emoji
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
}
