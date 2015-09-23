//
//  LoginViewController.swift
//  Tele Vision
//
//  Created by Zachary Josephson on 9/8/15.
//  Copyright (c) 2015 Capstone. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var authUser = "mayo"
    var authPass = "admin"
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "login" {
            print("Authenticating")
            if authUser == username.text && authPass == password.text {
                print("Authenticated User")
                return true
            }
            else {
                return false
            }
        }
        
        return false
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
