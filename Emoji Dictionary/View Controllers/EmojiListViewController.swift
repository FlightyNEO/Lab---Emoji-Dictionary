//
//  EmojiListViewController.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class EmojiListViewController: UITableViewController {
    
    // MARK: ... IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: ... Private properties
    private let cellID = "EmojiCell"
    
    private let configurator = TableViewCellConfigurator()
    private var emojis = Emojis()
    private var searchedEmojis = Emojis()
    
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
    
    private var isSearchResult: Bool {
        guard let text = searchBar.text else { return false }
        return !text.isEmpty
    }
    
    // MARK: ... Life cicle
    override func viewDidLoad() {
        navigationItem.title = emojis.title
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        guard let emojis = try? DataManager.fetchEmojis() else { return }
        self.emojis = emojis
        
    }
    
    // MARK: ... Private methods
    private func fillDetailController(_ controller: EmojiDetailViewController, emoji: Emoji?, title: String?, isEditable: Bool) {
        controller.emoji = emoji
        controller.title = title ?? emoji?.name
        controller.isEditable = isEditable
    }
    
}

// MARK: - Tble view data source & delegate
extension EmojiListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchResult ? searchedEmojis.count : emojis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emoji = isSearchResult ? searchedEmojis[indexPath.row] : emojis[indexPath.row]
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
        searchBar.resignFirstResponder()
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
                let emoji = isSearchResult ? searchedEmojis[row] : emojis[row]
                fillDetailController(emojiDetailViewController, emoji: emoji, title: "Edit", isEditable: true)
                mode = .edit
            case Mode.add.identifier:
                fillDetailController(emojiDetailViewController, emoji: nil, title: "Add", isEditable: true)
                mode = .add
            case Mode.show.identifier:
                guard let row = tableView.indexPathForSelectedRow?.row else { return }
                let emoji = isSearchResult ? searchedEmojis[row] : emojis[row]
                fillDetailController(emojiDetailViewController, emoji: emoji, title: nil, isEditable: false)
                mode = .show
            default: break
            }
            
        }
        
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        self.editingIndexPath = nil
        self.mode = nil
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Emoji detail view controller delegate
extension EmojiListViewController: EmojiDetailViewControllerDelegate {
    
    func didUpdateEmoji(_ emoji: Emoji) {
        
        guard let mode = mode else { return }
        
        switch mode {
        case .add:
            
            let indexOfEmojis = emojis.insertionIndexOf(emoji, <)
            let indexPath = IndexPath(row: indexOfEmojis, section: 0)
            emojis.insert(emoji, at: indexOfEmojis)
            
            if isSearchResult {
                searchBar.text = nil
                tableView.reloadData()
            } else {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        case .edit, .show:
            
            guard let editingIndexPath = editingIndexPath else { return }
            
            if isSearchResult {
                let modifiedEmoji = searchedEmojis[editingIndexPath.row]
                guard let index = emojis.firstIndex(of: modifiedEmoji) else { return }
                emojis[index] = emoji
                searchBar.text = nil
                tableView.reloadData()
            } else {
                emojis[editingIndexPath.row] = emoji
                tableView.reloadRows(at: [editingIndexPath], with: .automatic)
            }
            
        }
        
        try? DataManager.reWriteEmoji(emojis)
        
    }
    
}

// MARK: - Text field delegate
extension EmojiListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        
//        searchBar.showsScopeBar.toggle()
//        searchBar.sizeToFit()
//        searchBar.setShowsCancelButton(searchBar.showsScopeBar, animated: true)
//        
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        
//        return true
//    }
//    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//        
//        searchBar.showsScopeBar.toggle()
//        searchBar.sizeToFit()
//        searchBar.setShowsCancelButton(searchBar.showsScopeBar, animated: true)
//        
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        
//        return true
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searched = emojis.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        
        searchedEmojis = searched
        tableView.reloadData()
        
    }
    
}
