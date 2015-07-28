//
//  BooksViewController.swift
//  ProSwiftLibrary
//
//  Created by Amit Chandel on 7/27/15.
//  Copyright (c) 2015 Amit Chandel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class PLBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var booksTableView: UITableView!
    var bookResults = [Book]()
    let kBookTableViewCellIdentifier:NSString = "bookCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBooks()
    }

    func setupBooksTableView() {
        self.booksTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kBookTableViewCellIdentifier as String)
    }
    
    func loadBooks() {
        Alamofire.request(.GET, "http://prolific-interview.herokuapp.com/55a917e9b529b80009b7fe9b/books")
            .responseJSON { _, _, JSON, _ in
                self.bookResults = Mapper<Book>().mapArray(JSON)!
                self.booksTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.booksTableView.dequeueReusableCellWithIdentifier(kBookTableViewCellIdentifier as String) as! UITableViewCell

        cell.textLabel?.text = self.bookResults[indexPath.row].title
        cell.detailTextLabel?.text = self.bookResults[indexPath.row].author
        
        return cell
    }
}
