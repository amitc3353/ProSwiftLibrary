//
//  BooksViewController.swift
//  ProSwiftLibrary
//
//  Created by Amit Chandel on 7/27/15.
//  Copyright (c) 2015 Amit Chandel. All rights reserved.
//

import UIKit

class PLBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var booksTableView: UITableView!
    var bookResults: [AnyObject]! = []
    let kBookTableViewCellIdentifier:NSString = "bookCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBooksTableView()
    }

    func setupBooksTableView() {
        self.booksTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kBookTableViewCellIdentifier as String)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.booksTableView.dequeueReusableCellWithIdentifier(kBookTableViewCellIdentifier as String) as! UITableViewCell
        
        return cell
    }
}
