//
//  PatientIDViewController.swift
//  Tele Vision
//
//  Created by Zachary Josephson on 9/8/15.
//  Copyright (c) 2015 Capstone. All rights reserved.
//

import UIKit

class PatientIDViewController: UIViewController {
    
    var time = "Yesterday"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var patientID: UITextField!
    var authPatient = "1234"
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "loadPatient" {
            print("Authenticating")
            if authPatient == patientID.text {
                print("Authenticated Patient")
                return true
            }
            else {
                return false
            }
        }
        
        else if identifier == "logout" {
            print("Logout", terminator: "")
            return true
        }
        
        return false
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
