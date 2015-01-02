//
//  ViewController.swift
//  ScriptureTracker
//
//  Created by Michael Patterson on 12/29/14.
//  Copyright (c) 2014 Michael Patterson. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum SlideOutState{
    case open
    case closed
}

class MainViewController: UIViewController, MarkControllerDelegate {

    @IBOutlet weak var individualReading: UIView!
    @IBOutlet weak var familyReading: UIView!
    @IBOutlet weak var allTime: UILabel!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var familyCurrent: UILabel!
    @IBOutlet weak var familyMinutes: UILabel!
    @IBOutlet weak var familyAllTime: UILabel!
    
    var markIndividualState: SlideOutState = .closed
    var markFamilyState: SlideOutState = .closed
    
    var individualView: MarkController?
    var familyView: TestViewController?
    
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
        var individualGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "openIndividualView:")
        individualReading.addGestureRecognizer(individualGR)
        refreshTotals()
        var familyGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "openFamilyView:")
        familyReading.addGestureRecognizer(familyGR)
        
        //Check if the scripture data has already been loaded
        var checkFetch = NSFetchRequest(entityName: "Book")
        var numBooks = (managedObjectContext!.executeFetchRequest(checkFetch, error: nil) as Array<Book>).count
        if(numBooks == 0){
            loadScriptureData()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadScriptureData(){
        let path = NSBundle.mainBundle().pathForResource("scriptures", ofType: "json")
        let langJSON = NSData(contentsOfFile: path!, options: nil, error: nil)
        
        var error: NSError? = nil
        var jsonArray: NSArray? = NSJSONSerialization.JSONObjectWithData(langJSON!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray
        if(error != nil){
            println("JSON error \(error?.description)")
            return
        }else{
            for (index, item) in enumerate(jsonArray!){
                let entityDescription: NSEntityDescription = NSEntityDescription.entityForName("Book", inManagedObjectContext: managedObjectContext!)!
                var book: Book = Book(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext!)
                book.name = item.objectForKey("name") as NSString
                var subBooks = item.objectForKey("books") as NSArray
                for(index, bookItem) in enumerate(subBooks){
                    let innerEntityDescription: NSEntityDescription = NSEntityDescription.entityForName("SubBook", inManagedObjectContext: managedObjectContext!)!
                    var subBook = SubBook(entity: innerEntityDescription, insertIntoManagedObjectContext: managedObjectContext!)
                    subBook.name = bookItem.objectForKey("name") as NSString
                    subBook.chapters = bookItem.objectForKey("chapters") as NSNumber
                    subBook.sort = bookItem.objectForKey("sort") as NSNumber
                    subBook.book = book
                }
            }
        }
        var saveError: NSErrorPointer = NSErrorPointer()
        managedObjectContext!.save(saveError)
        if(saveError != nil){
            println("Save Error \(saveError.memory?.description)")
        }
//        var testFetch = NSFetchRequest(entityName: "Book")
//        testFetch.predicate = NSPredicate(format: "name == 'Book of Mormon'")
//        var testBooks = managedObjectContext!.executeFetchRequest(testFetch, error: nil) as Array<Book>
//        for(index, book) in enumerate(testBooks){
//            println(book.subBooks.count)
//        }
        
        
    }
    
    func refreshTotals(){
        var fetchRequest = NSFetchRequest(entityName: "Reading")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        var readings = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil)! as Array<Reading>
        var personalConsecutive = countConsecutiveDates(readings, type: "Personal")
        current.text = "\(personalConsecutive)"
        var personalData = countMinutesAndChapters(readings, type: "Personal")
        println(personalData.chapters)
        allTime.text = "\(personalData.chapters)"
        minutes.text = "\(personalData.minutes)"
        
        var familyConsecutive = countConsecutiveDates(readings, type: "Family")
        familyCurrent.text = "\(familyConsecutive)"
        var familyData = countMinutesAndChapters(readings, type: "Family")
        familyAllTime.text = "\(familyData.chapters)"
        familyMinutes.text = "\(familyData.minutes)"
    }
    
    func countMinutesAndChapters(readings: Array<Reading>, type: String)->(minutes: Int, chapters: Double){
        var minutes:Int = 0;
        var chapters:Double = 0;
        for(index, reading) in enumerate(readings){
            if(reading.type == type){
                minutes += Int(reading.minutes)
                chapters += Double(reading.chapters)
            }
        }
        return (minutes: minutes, chapters: chapters)
    }
    
    func countConsecutiveDates(readings: Array<Reading>, type: String) -> Int{
        var startDate = NSDate()
        var consecutive = 0
        for(index, reading) in enumerate(readings){
            if(type == reading.type){
                var beforeDate = startDate.dateBySubtractingDays(1)
                if(beforeDate.day == reading.date.day){
                    consecutive++
                }else if(reading.date.day != startDate.day){
                    break
                }
                startDate = reading.date
            }
        }
        return consecutive
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func openIndividualView(sender: UITapGestureRecognizer) -> Void{
        toggleIndividualView()
    }
    
    func openFamilyView(sender: UITapGestureRecognizer) -> Void{
        toggleFamilyView()
    }
    
    func toggleIndividualView(){
        if(markIndividualState != .open){
            individualView = markController()
            individualView!.delegate = self
            individualView!.view.frame.origin.y = 1000
            view.insertSubview(individualView!.view, atIndex: 10)
            addChildViewController(individualView!)
            markIndividualState = .open
            individualView!.setType("Personal")
            animateY(0, origin: individualView!)
        }else{
            markIndividualState = .closed
            animateY(1000, origin: individualView!){ finished in
                self.individualView!.view.removeFromSuperview()
                self.individualView = nil
            }
        }
    }
    
//    func toggleFamilyView(){
//        if(markFamilyState != .open){
//            familyView = markController()
//            familyView!.delegate = self
//            familyView!.view.frame.origin.y = 1000
//            view.insertSubview(familyView!.view, atIndex: 10)
//            addChildViewController(familyView!)
//            markFamilyState = .open
//            familyView!.setType("Family")
//            animateY(0, origin: familyView!)
//        }else{
//            markFamilyState = .closed
//            animateY(1000, origin: familyView!){ finished in
//                self.familyView!.view.removeFromSuperview()
//                self.familyView = nil
//            }
//        }
//    }
    
    func toggleFamilyView(){
        if(markFamilyState != .open){
            familyView = testController()
//            familyView!.delegate = self
            familyView!.view.frame.origin.y = 1000
            view.insertSubview(familyView!.view, atIndex: 10)
            addChildViewController(familyView!)
            markFamilyState = .open
//            familyView!.setType("Family")
            animateY(0, origin: familyView!)
        }else{
            markFamilyState = .closed
            animateY(1000, origin: familyView!){ finished in
                self.familyView!.view.removeFromSuperview()
                self.familyView = nil
            }
        }
    }

    
    func closeMarkView(){
        if(markIndividualState == .open){
            toggleIndividualView()
        }else if(markFamilyState == .open){
            toggleFamilyView()
        }
        refreshTotals()
    }
    
    func animateX(targetPosition: CGFloat, origin: UIViewController, completion: ((Bool) -> Void)! = nil){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            origin.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animateY(targetPosition: CGFloat, origin: UIViewController, completion: ((Bool) -> Void)! = nil){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            origin.view.frame.origin.y = targetPosition
            }, completion: completion)
    }
    
    func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    func markController() -> MarkController?{
        return mainStoryboard().instantiateViewControllerWithIdentifier("markController") as? MarkController
    }
    
    func testController() -> TestViewController?{
        return mainStoryboard().instantiateViewControllerWithIdentifier("testController") as? TestViewController
    }


}

