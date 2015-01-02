//
//  testViewController.swift
//  ScriptureTracker
//
//  Created by Michael Patterson on 1/2/15.
//  Copyright (c) 2015 Michael Patterson. All rights reserved.
//

import UIKit

enum TableViewState{
    case Book
    case SubBook
    case Chapters
}
class TestViewController: UIViewController, BookTableViewDelegate {
    
    var bookTableView: BookTableViewController?
    var subBookTableView: SubBookTableViewController?
    var tableViewState: TableViewState = .Book
    var frameWidth: CGFloat = 200

    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bookTableView = BookTableViewController()
        bookTableView?.delegate = self
        view.insertSubview(bookTableView!.view, atIndex: 0)
        bookTableView!.view.frame = CGRect(x: 10, y: 50, width: CGRectGetWidth(self.view.frame) - 20, height: 200)
        self.addChildViewController(bookTableView!)
        backButton.hidden = true
        frameWidth = CGRectGetWidth(self.view.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func transitionToSubBook(book: String) {
        backButton.hidden = false
        subBookTableView = SubBookTableViewController()
        subBookTableView?.setDataArray(book)
        view.insertSubview(subBookTableView!.view, atIndex: 1)
        subBookTableView!.view.frame = CGRect(x: frameWidth, y: 50, width: CGRectGetWidth(self.view.frame) - 20, height: 200)
        self.addChildViewController(subBookTableView!)
        backButton.titleLabel!.text = book
        animateX(10, origin: subBookTableView!)
    }
    
    func animateX(targetPosition: CGFloat, origin: UIViewController, completion: ((Bool) -> Void)! = nil){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            origin.view.frame.origin.x = targetPosition
            }, completion: completion)
    }

    @IBAction func backButtonTouched(sender: AnyObject) {
        animateX(frameWidth, origin: subBookTableView!)
        subBookTableView!.removeFromParentViewController()
        subBookTableView = nil
        backButton.hidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
