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

    var bookURLEndpoint:String!

    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookPublisherLabel: UILabel!
    @IBOutlet weak var bookTagsLabel: UILabel!
    @IBOutlet weak var bookLastCheckedOutLabel: UILabel!
    var userName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.fetchBookData()
    }
    
    func setupNavigationBar() {
        let shareBar: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.Action, target: self, action: Selector("shareButtonTapped"))
        
        self.navigationItem.rightBarButtonItem = shareBar
    }
    
    func fetchBookData() {
        Alamofire.request(Router.GetABook(bookURLEndpoint))
            .responseJSON { _, _, JSON, _ in
                var bookObj:Book = Mapper<Book>().map(JSON)!
                self.setupLabels(bookObj)
        }
    }
    
    func setupLabels(bookObj:Book) {
        self.bookTitleLabel.text = bookObj.title
        self.bookAuthorLabel.text = bookObj.author
        self.bookPublisherLabel.text = bookObj.publisher
        self.bookLastCheckedOutLabel.text = bookObj.lastCheckedOutBy
    }

    @IBAction func checkoutButtonTapped(sender: AnyObject) {
        self.promtForUserName()
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        self.deleteBook()
    }
    
    func checkout() {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let date = NSDate()
        let dateString = dateFormatter.stringFromDate(date)
        
        let parameters = [
            "lastCheckedOut": dateString,
            "lastCheckedOutBy": self.userName,
        ]
        
        let request = Alamofire.request(Router.UpdateBook(bookURLEndpoint, parameters))
        request.responseJSON { request, response, json, error in
            println(error)
        }
    }
    
    func deleteBook() {
        let request = Alamofire.request(Router.DeleteBook(bookURLEndpoint))
        request.responseJSON { request, response, json, error in
            println(error)
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
    
    func shareButtonTapped() {
        
        var titleString:String = self.bookTitleLabel.text!
        var authorString:String = self.bookAuthorLabel.text!
        
        let objectsToShare = [titleString, authorString]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
}
