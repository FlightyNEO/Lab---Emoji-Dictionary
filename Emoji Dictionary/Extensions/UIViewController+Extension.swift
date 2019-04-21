//
//  UIViewController+Extension.swift
//  Emoji Dictionary
//
//  Created by Arkadiy Grigoryanc on 21/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
