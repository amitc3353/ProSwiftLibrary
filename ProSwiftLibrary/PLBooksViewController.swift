//
//  BooksViewController.swift
//  ProSwiftLibrary
//
//  Created by Amit Chandel on 7/27/15.
//  Copyright (c) 2015 Amit Chandel. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class PLBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var booksTableView: UITableView!
    var bookResults = [Book]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadBooks()
    }
    
// MARK: Private Methods
    
    func setupBooksTableView() {
        self.booksTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kBookCellIdentifier as String)
    }
    
    func loadBooks() {
        self.showLoadingIndicator()
        Alamofire.request(Router.GetBooks)
            .responseJSON { _, _, JSON, _ in
                self.bookResults = Mapper<Book>().mapArray(JSON)!
                self.booksTableView.reloadData()
                self.hideLodingIndicator()
        }
    }
    
// MARK: TableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.booksTableView.dequeueReusableCellWithIdentifier(kBookCellIdentifier as String) as! UITableViewCell

        cell.textLabel?.text = self.bookResults[indexPath.row].title
        cell.detailTextLabel?.text = self.bookResults[indexPath.row].author
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bookDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kBookDetailViewControllerIdentifier) as? PLBookDetailViewController
        bookDetailViewController?.bookURLEndpoint = self.bookResults[indexPath.row].url
        self.navigationController?.pushViewController(bookDetailViewController!, animated: true)
        self.booksTableView.deselectRowAtIndexPath(self.booksTableView.indexPathForSelectedRow()!, animated: true)
    }
}


