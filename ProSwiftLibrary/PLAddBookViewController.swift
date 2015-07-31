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
    
// MARK: Private Methods
    
    func addBook() {
        let parameters = [
            "author": self.authorTextField.text,
            "title": self.bookTitleTextField.text,
            "publisher": self.publisherTextField.text,
            "categories": self.categoriesTextField.text
        ]
        
        Alamofire.request(Router.PostBook(parameters))
            .response { request, response, data, error in
                if(error == nil) {
                    self.showAlert("Added successfully.")
                    self.resetTextFieldContent()
                } else {
                    self.showAlert("Something went wrong. Please try again.")
                }
        }
    }
    
    func isRequiredFieldsEmpty() -> Bool {
        return (self.bookTitleTextField.text.isEmpty && self.authorTextField.text.isEmpty)
    }
    
    func showAlert(message:String) {
        let alertController = UIAlertController(title: "Alert", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func resetTextFieldContent() {
        self.authorTextField.text = ""
        self.bookTitleTextField.text = ""
        self.publisherTextField.text = ""
        self.categoriesTextField.text = ""
    }
    
    // MARK: IBAction Methods
    
    @IBAction func submitButtonClicked(sender: AnyObject) {
        if(self.isRequiredFieldsEmpty()) {
            self.showAlert("Please enter the mandatory 'Author' and 'Title' fields.")
        } else {
            self.addBook()
        }
    }
    
    @IBAction func resetButtonTapped(sender: AnyObject) {
        self.resetTextFieldContent()
    }
    
// MARK: TextField Delegate Methods
    
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
