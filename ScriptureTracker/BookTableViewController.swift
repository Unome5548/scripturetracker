//
//  BookTableViewController.swift
//  multipleTableViews
//
//  Created by Michael Patterson on 1/2/15.
//  Copyright (c) 2015 Michael Patterson. All rights reserved.
//

import UIKit
import CoreData

protocol BookTableViewDelegate{
    func transitionToSubBook(book: String)
}

class BookTableViewController: UITableViewController {
    
    var dataArray: Array<Book>?
    var selectedBook: Book?
    var delegate: BookTableViewDelegate?
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else{
            return nil
        }
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bookFetch = NSFetchRequest(entityName: "Book")
        dataArray = managedObjectContext?.executeFetchRequest(bookFetch, error: nil)! as? Array<Book>
        var nib : UINib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.lightGrayColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataArray!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = dataArray![indexPath.row].name
        cell.backgroundColor = UIColor.lightGrayColor()

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedBook = dataArray![indexPath.row]
        println("Boom")
        delegate?.transitionToSubBook(selectedBook!.name)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tableController = segue.destinationViewController as SubBookTableViewController
        var row = self.tableView.indexPathForSelectedRow()!.row
        tableController.setDataArray(dataArray![row].name)
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}
