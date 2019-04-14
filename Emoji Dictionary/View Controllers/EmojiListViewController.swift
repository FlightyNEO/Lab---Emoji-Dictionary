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
    private let editEmojiIdentifier = "EditEmojiIdentifier"
    private let addEmojiIdentifier = "AddEmojiIdentifier"
    let configurator = TableViewCellConfigurator()
    var emojis = Emojis.loadSample()
    
    private var editingIndexPath: IndexPath?
    private var condition: Condition?
    
    enum Condition {
        case edit, add
    }
    
    override func viewDidLoad() {
        navigationItem.title = emojis.title
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
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
            self.performSegue(withIdentifier: self.editEmojiIdentifier, sender: indexPath.row)
        }
        
        editAction.backgroundColor = .orange
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            self.emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [deleteAction, editAction]
    }
    
}

// MARK: - Navigation
extension EmojiListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == editEmojiIdentifier {
            
            guard let emojiDetailViewController = segue.destination as? EmojiDetailViewController,
            let row = sender as? Int else { return }
            
            condition = .edit
            
            emojiDetailViewController.emoji = self.emojis[row]
            emojiDetailViewController.title = "Edit"
            
        } else if segue.identifier == addEmojiIdentifier {
            
            guard let emojiDetailViewController = segue.destination as? EmojiDetailViewController else { return }
            
            condition = .add
            
            emojiDetailViewController.title = "Add"
        }
        
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
        guard
            let condition = condition,
            segue.identifier == "SaveSegue" else { return }
        
        if condition == .add {
        
            let controller = segue.source as! EmojiDetailViewController
            let emoji = controller.emoji
            //print(#line, #function, emoji.symbol, emoji.name)
            
            let index = emojis.insertionIndexOf(emoji, <)
            let indexPath = IndexPath(row: index, section: 0)
            
            emojis.insert(emoji, at: index)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
        } else if condition == .edit {
            
            let controller = segue.source as! EmojiDetailViewController
            let emoji = controller.emoji
            
            guard let indexPath = editingIndexPath else { return }
            emojis[indexPath.row] = emoji
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        self.condition = nil
    }
    
}
