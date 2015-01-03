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
    var bookTableExpanded = false
    var subBookTableView: SubBookTableViewController?
    var tableViewState: TableViewState = .Book
    var frameWidth: CGFloat = 200

    @IBOutlet weak var readView: UIView!
    @IBOutlet weak var readLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frameWidth = CGRectGetWidth(self.view.frame)
        
        bookTableView = BookTableViewController()
        bookTableView?.delegate = self
        
        self.view.insertSubview(self.bookTableView!.view, atIndex: 3)
        self.addChildViewController(self.bookTableView!)
        self.bookTableView!.view.layer.opacity = 0.0
        self.bookTableView!.view.frame = CGRect(x: self.readView.frame.origin.x, y: self.readView.frame.origin.y + 50, width: 280, height: 150)
        
        println(self.readView.bounds.width)
        
        
        subBookTableView = SubBookTableViewController()
        view.insertSubview(subBookTableView!.view, atIndex: 4)
        subBookTableView!.view.frame = CGRect(x: frameWidth, y: self.readView.frame.origin.y + 50, width: 280, height: 150)
        self.addChildViewController(subBookTableView!)
        
        // Do any additional setup after loading the view.
        backButton.hidden = true

        
        //This doesn't work
//        var item1 = ChapterButton()
//        item1.view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        self.view.insertSubview(item1.view, atIndex: 10)

        readView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "expandView:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func expandView(sender: UITapGestureRecognizer){
        if(!bookTableExpanded){
//            bookTableExpanded = true


            growView(300, origin: readView!, completion: { (Bool) -> Void in
                self.fadeIn(self.bookTableView!)
            })
        }
    }
    
    func transitionToSubBook(book: String) {
        backButton.hidden = false
        subBookTableView?.setDataArray(book)
        backButton.titleLabel!.text = book
        animateX(self.readView.frame.origin.x, origin: subBookTableView!)
    }
    
    func animateX(targetPosition: CGFloat, origin: UIViewController, completion: ((Bool) -> Void)! = nil){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            origin.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func fadeIn(origin: UIViewController, completion: ((Bool) -> Void)! = nil){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            origin.view.layer.opacity = 1.0
            }, completion: completion)
    }
    
    func growView(targetPosition: CGFloat, origin: UIView, completion: ((Bool) -> Void)! = nil){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            origin.frame.size.height = targetPosition
            }, completion: completion)
    }

    @IBAction func backButtonTouched(sender: AnyObject) {
        animateX(frameWidth, origin: subBookTableView!)
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
