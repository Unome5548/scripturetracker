//
//  ChapterButton.swift
//  ScriptureTracker
//
//  Created by Michael Patterson on 1/2/15.
//  Copyright (c) 2015 Michael Patterson. All rights reserved.
//

import UIKit

enum ChapterButtonState{
    case NoneRead
    case HalfRead
    case FullRead
}

class ChapterButton: UIViewController {

    @IBOutlet weak var imageButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        imageButton.addGestureRecognizer(UITapGestureRecognizer(target: imageButton, action: "imageTapped:"))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(sender: UITapGestureRecognizer){
        println("Tapped Me")
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
