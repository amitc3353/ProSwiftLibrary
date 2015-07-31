//
//  BookDetailViewController.swift
//  ProSwiftLibrary
//
//  Created by Amit Chandel on 7/28/15.
//  Copyright (c) 2015 Amit Chandel. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class PLBookDetailViewController: UIViewController {

    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookPublisherLabel: UILabel!
    @IBOutlet weak var bookTagsLabel: UILabel!
    @IBOutlet weak var bookLastCheckedOutLabel: UILabel!
    var userName:String!
    var bookURLEndpoint:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.fetchBookData()
    }
    
// MARK: Private Methods
    
    func setupNavigationBar() {
        let shareBar: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.Action, target: self, action: Selector("shareButtonTapped"))
        
        self.navigationItem.rightBarButtonItem = shareBar
    }
    
    func fetchBookData() {
        self.showLoadingIndicator()
        Alamofire.request(Router.GetABook(self.bookURLEndpoint))
            .responseJSON { _, _, JSON, _ in
                var bookObj:Book = Mapper<Book>().map(JSON)!
                self.setupLabels(bookObj)
                self.hideLodingIndicator()
        }
    }
    
    func setupLabels(bookObj:Book) {

        self.bookTitleLabel.text = bookObj.title
        self.bookAuthorLabel.text = bookObj.author
        if(bookObj.publisher.isEmpty) {
            self.bookPublisherLabel.text = "Not available"
        } else {
            self.bookPublisherLabel.text = bookObj.publisher
        }
        if(bookObj.categories.isEmpty) {
            self.bookTagsLabel.text = "Not available"
        } else {
            self.bookTagsLabel.text = bookObj.categories
        }
        if(bookObj.lastCheckedOut.isEmpty) {
            self.bookLastCheckedOutLabel.text = "Not available"
        } else {
            self.bookLastCheckedOutLabel.text = "\(bookObj.lastCheckedOutBy) @ \(bookObj.lastCheckedOut)"
        }
    }

    func promtForUserName() {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Please enter your name.", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        let doneAction: UIAlertAction = UIAlertAction(title: "Done", style: .Default) { action -> Void in
            self.checkout()
        }
        doneAction.enabled = false
        
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.textColor = UIColor.blueColor()
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                doneAction.enabled = textField.text != ""
                self.userName = textField.text
            }
            actionSheetController.addAction(doneAction)
            actionSheetController.addAction(cancelAction)
        }
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func formatDate() -> NSString {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let date = NSDate()
        let dateString = dateFormatter.stringFromDate(date)
        
        return dateString
    }
    
    func showAlert(message:String) {
        let alertController = UIAlertController(title: "Alert", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
// MARK: IBAction Methods
    
    @IBAction func checkoutButtonTapped(sender: AnyObject) {
        self.promtForUserName()
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        self.deleteBook()
    }
    
    func shareButtonTapped() {
        
        var titleString:String = self.bookTitleLabel.text!
        var authorString:String = self.bookAuthorLabel.text!
        
        let objectsToShare = [titleString, authorString]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
// MARK: API Request Methods
    
    func checkout() {
        var dateString:NSString = self.formatDate()
        
        let parameters = [
            "lastCheckedOut": dateString,
            "lastCheckedOutBy": self.userName,
        ]
        
        self.showLoadingIndicator()
        let request = Alamofire.request(Router.UpdateBook(bookURLEndpoint, parameters))
        request.responseJSON { request, response, json, error in
            if(error == nil) {
                self.showAlert("Checkout Successful.")
                self.fetchBookData()
            } else {
                self.showAlert("Something went wrong. Please try again.")
            }
            self.hideLodingIndicator()
        }
    }
    
    func deleteBook() {
        self.showLoadingIndicator()
        let request = Alamofire.request(Router.DeleteBook(bookURLEndpoint))
        request.responseJSON { request, response, json, error in
            if(error == nil) {
                self.showAlert("Deleted Successful.")
            } else {
                self.showAlert("Something went wrong. Please try again.")
            }
            self.hideLodingIndicator()
        }
    }
}
