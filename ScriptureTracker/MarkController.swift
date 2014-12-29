//
//  MarkController.swift
//  ScriptureTracker
//
//  Created by Michael Patterson on 12/29/14.
//  Copyright (c) 2014 Michael Patterson. All rights reserved.
//

import UIKit
import CoreData

protocol MarkControllerDelegate {
    func closeMarkView()
}

class MarkController: UIViewController {

    @IBOutlet weak var minutesPicker: UIPickerView!
    @IBOutlet weak var chaptersPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var readingType: UILabel!
    
    var chaptersData = ChaptersPickerData()
    var minutesData = MinutesPickerData()
    var delegate:MarkControllerDelegate?
    var type:String = "Personal"
    
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
        chaptersPicker.delegate = chaptersData
        chaptersPicker.dataSource = chaptersData
        
        minutesPicker.delegate = minutesData
        minutesPicker.dataSource = minutesData
    }
    
    func setType(type:String){
        readingType.text = "\(type) Reading"
        self.type = type
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitTapped(sender: AnyObject) {
        let entityDescription: AnyObject = NSEntityDescription.entityForName("Reading", inManagedObjectContext: managedObjectContext!)!
        var reading = Reading(entity: entityDescription as NSEntityDescription, insertIntoManagedObjectContext: managedObjectContext)
        reading.minutes = minutesData.minutesRead
        reading.chapters = chaptersData.chaptersRead
        reading.date = datePicker.date
        reading.type = type
        
        managedObjectContext!.save(nil)
        delegate?.closeMarkView()
    }
    
    @IBAction func closeTapped(sender: AnyObject) {
        delegate?.closeMarkView()
    }
}

class ChaptersPickerData: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var dataArray = Array<Double>()
    var chaptersRead: Double = 0.5
    
    override init() {
        dataArray.append(0.5)
        for(var i = 1; i <= 20; i++){
            dataArray.append(Double(i))
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(dataArray[row] == 0.5){
            return "1/2"
        }else{
            return "\(Int(dataArray[row]))"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chaptersRead = dataArray[row]
    }
}

class MinutesPickerData: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var dataArray = Array<Int>()
    var minutesRead: Int = 5
    
    override init() {
        for(var i = 5; i <= 60; i+=5){
            dataArray.append(i)
        }
        dataArray.append(75)
        dataArray.append(90)
        dataArray.append(105)
        dataArray.append(120)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(dataArray[row])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        minutesRead = dataArray[row]
    }
}
