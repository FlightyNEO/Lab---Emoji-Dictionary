//
//  EmojiDetailViewController.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class EmojiDetailViewController: UITableViewController {
    
    // MARK: ... IBOutlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var symbolField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var usageField: UITextField!
    
    // MARK: ... Private proprties
    private enum MaxLenght: Int {
        case symbol = 1
        case name = 20
        case description = 80
    }
    
    private var textFields: [UITextField] {
        return [symbolField, nameField, descriptionField, usageField]
    }
    
    private func areFieldsReady(_ textFields: [UITextField]? = nil) -> Bool {
        for textField in textFields ?? self.textFields {
            if textField.isEmpty { return false }
        }
        return true
    }
    
    // MARK: ... Proprties
    var emoji = Emoji()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: ... Private methods
    private func saveEmoji() {
        emoji.symbol = symbolField.text ?? ""
        emoji.name = nameField.text ?? ""
        emoji.description = descriptionField.text ?? ""
        emoji.usage = usageField.text ?? ""
    }
    
    private func setupUI() {
        symbolField.text = emoji.symbol
        nameField.text = emoji.name
        descriptionField.text = emoji.description
        usageField.text = emoji.usage
        
        updateUI()
    }
    
    private func updateUI() {
        saveButton.isEnabled = areFieldsReady()
    }
    
}

// MARK: - Navigation
extension EmojiDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSegue" {
            saveEmoji()
        }
    }
    
}

// MARK: - Text field delegate
extension EmojiDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        switch textField {
        case symbolField:
            guard newString.count <= MaxLenght.symbol.rawValue else { return false }
        case nameField:
            guard newString.count <= MaxLenght.name.rawValue else { return false }
        case descriptionField, usageField:
            guard newString.count <= MaxLenght.description.rawValue else { return false }
        default:
            break
        }
        
        // check areFieldsReady
        let textFields = self.textFields.filter { $0 != textField }
        saveButton.isEnabled = !newString.isEmpty && areFieldsReady(textFields)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let index = textFields.firstIndex(of: textField) else { return false }
            
        let nextIndex = index + 1
            
        guard nextIndex < textFields.count else {
            
            textField.resignFirstResponder()
            return true
        }
        
        textFields[nextIndex].becomeFirstResponder()
        return true
        
    }
    
}
