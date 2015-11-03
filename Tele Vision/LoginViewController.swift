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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);



        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!

        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
            
            else {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y = 0 - keyboardSize.height
                })
            }
        }
        
        else {
            print ("here")
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    func keyboardWillHide(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!

        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size

        self.view.frame.origin.y += keyboardSize.height
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
            /*
            print("Authenticating")
            if authUser == username.text && authPass == password.text {
                print("Authenticated User")
                return true
            }
            else {
                return false
            }
        }
        
        return false*/
            
            //Chances auth code 
            //user is mayo
            //pass is admin
            
            
            let myUsername:NSString = username.text!
            let myPassword:NSString = password.text!
            
            if ( myUsername.isEqualToString("") || myPassword.isEqualToString("") ) {
                
                let alertController = UIAlertController(title: "Sign in Failed", message: "Please enter Username and Password", preferredStyle: .Alert)
                
                /*let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                print("The user is okay.")
                }*/
                
                let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alertController.addAction(yesAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                
                do {
                    let post:NSString = "username=\(myUsername)&password=\(myPassword)"
                    
                    NSLog("PostData: %@",post);
                    
                    let url:NSURL = NSURL(string:"http://ec2-54-68-228-124.us-west-2.compute.amazonaws.com/loginDoctor2.php")!
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
                                
                                //the following was me trying to get a modal to pop up saying welcome and then dismiss after 2 seconds.
                                //it was able to dismiss but then it would segue to patient screen so...
                                //let alertController = UIAlertController(title: "Welcome Doctor", message: "Logged in Successfully", preferredStyle: .Alert)
                                
                                //let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                //alertController.addAction(yesAction)
                                //self.presentViewController(alertController, animated: true, completion: nil)
                                
                                //let delay = 2 * Double(NSEC_PER_SEC)
                                //let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                //dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                                //    alertController.dismissViewControllerAnimated(true, completion: nil)
                                //}
                                return true

                                /*
                                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                prefs.setObject(username, forKey: "USERNAME")
                                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                                prefs.synchronize()
                                self.dismissViewControllerAnimated(true, completion: nil)
                                */
                                
                            } else {
                                var error_msg:NSString
                                
                                if jsonData["error_message"] as? NSString != nil {
                                    error_msg = jsonData["error_message"] as! NSString
                                } else {
                                    error_msg = "Unknown Error"
                                }
                                
                                let alertController = UIAlertController(title: "Sign in Failed", message: error_msg as String, preferredStyle: .Alert)
                                
                                let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                alertController.addAction(yesAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                return false
                                
                            }
                            
                        } else {
                            
                            let alertController = UIAlertController(title: "Sign in Failed", message: "Connection failed", preferredStyle: .Alert)
                            
                            let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alertController.addAction(yesAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            return false
                        }
                    } else {
                        
                        let errorMessage = "Error"
                        
                        let alertController = UIAlertController(title: "Sign in Failed", message: errorMessage, preferredStyle: .Alert)
                        
                        let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(yesAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return false
                    }
                } catch {
                    
                    let alertController = UIAlertController(title: "Sign in Failed", message: "Server Error", preferredStyle: .Alert)
                    
                    let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(yesAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return false
                }
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
