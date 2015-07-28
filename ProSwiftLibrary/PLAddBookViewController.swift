//
//  PLAddBookViewController.swift
//  ProSwiftLibrary
//
//  Created by Amit Chandel on 7/28/15.
//  Copyright (c) 2015 Amit Chandel. All rights reserved.
//

import UIKit
import Alamofire

class PLAddBookViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var categoriesTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func submitButtonClicked(sender: AnyObject) {
        if(self.isRequiredFieldsEmpty()) {
            println("empty")
        } else {
            self.addBook()
        }
    }
    
    func addBook() {
        let parameters = [
            "author": self.authorTextField.text,
            "title": self.bookTitleTextField.text,
            "publisher": self.publisherTextField.text,
            "categories": self.categoriesTextField.text
        ]
        
        Alamofire.request(Router.PostBook(parameters)).responseString { _, _, string, _ in
            println(string)
        }
    }
    
    func isRequiredFieldsEmpty() -> Bool {
        return (self.bookTitleTextField.text.isEmpty && self.authorTextField.text.isEmpty)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
            if (textField === bookTitleTextField) {
                authorTextField.becomeFirstResponder()
            } else if (textField === authorTextField) {
                publisherTextField.becomeFirstResponder()
            } else if (textField === publisherTextField) {
                categoriesTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            
            return true
    }
}
