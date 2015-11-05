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
            let myUsername:NSString = patientID.text!
            
            if ( myUsername.isEqualToString("")) {
                
                let alertController = UIAlertController(title: "Patient Lookup Failed", message: "Please enter a valid patient id", preferredStyle: .Alert)
                
                /*let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                print("The user is okay.")
                }*/
                
                let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alertController.addAction(yesAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                
                do {
                    let post:NSString = "username=\(myUsername)"
                    
                    NSLog("PostData: %@",post);
                    
                    let url:NSURL = NSURL(string:"http://ec2-54-68-228-124.us-west-2.compute.amazonaws.com/findPatient.php")!
                    let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                    
                    let postLength:NSString = String( postData.length )
                    
                    let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                    request.HTTPMethod = "POST"
                    request.HTTPBody = postData
                    request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField: "Accept")
                    
                    
                    var reponseError: NSError?
                    var response: NSURLResponse?
                    
                    var urlData: NSData?
                    
                    do {
                        urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
                    } catch let error as NSError {
                        reponseError = error
                        urlData = nil
                    }
                    
                    /*trying nondeprecated api call here
                    let session = NSURLSession.sharedSession()
                    session.dataTaskWithRequest(request) { (urlData, response, responseError) -> Void in
                    
                    */
                    if ( urlData != nil ) {
                        let res = response as! NSHTTPURLResponse!;
                        
                        NSLog("Response code: %ld", res.statusCode);
                        
                        if (res.statusCode >= 200 && res.statusCode < 300)
                        {
                            let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                            
                            NSLog("Response ==> %@", responseData);
                            
                            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                            
                            let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                            
                            NSLog("Success: %ld", success);
                            
                            if(success == 1)
                            {
                                NSLog("Login SUCCESS");
                                
                                /*
                                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                prefs.setObject(username, forKey: "USERNAME")
                                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                                prefs.synchronize()
                                
                                self.dismissViewControllerAnimated(true, completion: nil)*/
                                return true
                            } else {
                                var error_msg:NSString
                                
                                if jsonData["error_message"] as? NSString != nil {
                                    error_msg = jsonData["error_message"] as! NSString
                                } else {
                                    error_msg = "Unknown Error"
                                }
                                
                                let alertController = UIAlertController(title: "Patient Lookup Failed", message: error_msg as String, preferredStyle: .Alert)
                                
                                let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                alertController.addAction(yesAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                return false
                            }
                            
                        } else {
                            
                            let alertController = UIAlertController(title: "Patient Lookup Failed", message: "Connection failed", preferredStyle: .Alert)
                            
                            let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alertController.addAction(yesAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            return false
                        }
                    } else {
                        
                        let errorMessage = "Error"
                        
                        let alertController = UIAlertController(title: "Patient Lookup Failed", message: errorMessage, preferredStyle: .Alert)
                        
                        let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(yesAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return false
                    }
                } catch {
                    
                    let alertController = UIAlertController(title: "Patient Lookup Failed", message: "Server Error", preferredStyle: .Alert)
                    
                    let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(yesAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return false
                }
            }
            //return false
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
