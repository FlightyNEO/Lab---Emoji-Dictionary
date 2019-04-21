//
//  EmojiDetailViewController.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

protocol EmojiDetailViewControllerDelegate: class {
    func didUpdateEmoji(_ emoji: Emoji)
}

class EmojiDetailViewController: UITableViewController {
    
    // MARK: ... IBOutlets
    @IBOutlet weak var saveAndCancelButton: UIBarButtonItem!
    @IBOutlet weak var cancelAndBackButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var symbolField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var usageField: UITextField!
    
    // MARK: ... Private proprties
    private enum MaxLength: Int {
        case symbol = 1
        case name = 20
        case description = 50
    }
    
    private enum Mode {
        case review
        case edit(readyToSave: Bool)
    }
    
    private var mode: Mode = .review {
        didSet {
            switch mode {
            case .review:
                editButton?.title = "Edit"
                editButton?.isEnabled = true
            case .edit(readyToSave: let isReady):
                editButton?.title = "Save"
                editButton?.isEnabled = isReady ? true : false
            }
        }
    }
    
    private var textFields: [UITextField] {
        guard
            symbolField != nil,
            nameField != nil,
            descriptionField != nil,
            usageField != nil else { return [] }
        
        return [symbolField, nameField, descriptionField, usageField]
    }
    
    private func areFieldsReady(_ textFields: [UITextField]? = nil) -> Bool {
        for textField in textFields ?? self.textFields {
            if textField.isEmpty { return false }
        }
        return true
    }
    
    private lazy var cancelButton: UIBarButtonItem? = {
        return UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(actionCancel))
    }()
    
    // MARK: ... Proprties
    var emoji: Emoji!
    weak var delegate: EmojiDetailViewControllerDelegate?
    
    var isEditable = false {
        didSet {
            mode = isEditable ? .edit(readyToSave: true) : .review
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        if emoji == nil {
            emoji = Emoji()
        }
        
        setupUI()
    }
    
    // MARK: ... Private methods
    private func saveEmoji() {
        emoji.symbol = symbolField.text ?? ""
        emoji.name = nameField.text ?? ""
        emoji.description = descriptionField.text ?? ""
        emoji.usage = usageField.text ?? ""
        
        delegate?.didUpdateEmoji(emoji)
    }
    
    private func setupUI() {
        
        navigationItem.rightBarButtonItems?.removeAll { $0 == (isEditable ? editButton : saveAndCancelButton) }
        
        if isEditable {
            editButton = nil
        } else {
            cancelAndBackButton = nil
            saveAndCancelButton = nil
        }
        
        updateUI()
    }
    
    private func updateUI() {
        
        navigationItem.leftBarButtonItem = isEditable ? (cancelAndBackButton ?? cancelButton) : nil
        
        symbolField?.text = emoji.symbol
        nameField?.text = emoji.name
        descriptionField?.text = emoji.description
        usageField?.text = emoji.usage
        
        saveAndCancelButton?.isEnabled = areFieldsReady()
        textFields.forEach { $0.isEnabled = isEditable }
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

// MARK: - Actions
extension EmojiDetailViewController {
    
    @objc private func actionCancel() {
        isEditable.toggle()
    }
    
    @IBAction func actionEdit(_ sender: UIBarButtonItem) {
        
        switch mode {
        case .review:
            isEditable.toggle()
            symbolField.becomeFirstResponder()
        case .edit:
            saveEmoji()
            title = nameField.text
            isEditable.toggle()
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
            guard newString.count <= MaxLength.symbol.rawValue else { return false }
        case nameField:
            guard newString.count <= MaxLength.name.rawValue else { return false }
        case descriptionField, usageField:
            guard newString.count <= MaxLength.description.rawValue else { return false }
        default:
            break
        }
        
        // check areFieldsReady
        let textFields = self.textFields.filter { $0 != textField }
        saveAndCancelButton?.isEnabled = !newString.isEmpty && areFieldsReady(textFields)
        mode = .edit(readyToSave: !newString.isEmpty && areFieldsReady(textFields))
        
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
