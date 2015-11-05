//
//  SurveyViewController.swift
//  Tele Vision
//
//  Created by Zachary Josephson on 9/9/15.
//  Copyright (c) 2015 Capstone. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController, SSRadioButtonControllerDelegate {
    
    var textfields = [UITextField]()
    
    var radioButtonController: SSRadioButtonsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        getJson()
        
        //let backItem = UIBarButtonItem(title: "Back", style: .Bordered, target: nil, action: nil)
        let backItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)

        navigationItem.backBarButtonItem = backItem

        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var name: UITextField!

    // MARK: - Navigation
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        var fieldArrays = [[String]]()
       
        let dest = segue.destinationViewController as! PhotoViewController
        //dest.name = name.text!
        
        for i in 0...textfields.count - 1{
            let unrwappedI : String! = textfields[i].text
            let label: String! = textfields[i].placeholder
            fieldArrays.append([unrwappedI, label])
            
        }
        
        dest.toPass = fieldArrays
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    func getJson(){
        //if the json file name "pro" exists then
        if let path = NSBundle.mainBundle().pathForResource("pro", ofType: "json") {
            do {
                
                let urlPath =  NSURL(string: "https://dl.dropboxusercontent.com/u/9366248/pro.json")
                
                //read the json data into data var
                let data = try NSData(contentsOfURL: urlPath!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                
                //cast data var to json object
                let jsonObj = JSON(data: data)
                
                
                //json data integrity and existence check
                if jsonObj != JSON.null {
                    print("got json successfully")
                    
                    //get jsonfile.form.questions 1st element (starts at 0)
                
                    let scrollView = UIScrollView(frame: CGRectMake(10, 175, 350, 300))
                    scrollView.backgroundColor = UIColor.clearColor()
                    scrollView.scrollEnabled = true
                    scrollView.showsVerticalScrollIndicator = true
                    
                    let realJson = jsonObj["form"]["questions"]
                    
                    let contentHeight = Float(realJson.count) * 70 + 10;
                    let contentHeightClean = CGFloat(contentHeight);
                    
                    scrollView.contentSize = CGSizeMake(350, contentHeightClean);

                    //print (realJson[0])
                    let swiftColor = UIColor(red: 15/255, green: 78/255, blue: 157/255, alpha: 1)
                    for i in 0...realJson.count - 1{
                        let text = realJson[i]["question"]["fieldLabel"]

                        if realJson[i]["question"]["type"] == "textfield"{
                            //create a uitextview at coord (x=0,y=10) with width 300 and height 700
                            let tempText = UITextField(frame: CGRectMake(120, 10 + 60 * CGFloat(i), 200, 30))
                        
                            tempText.backgroundColor = UIColor.whiteColor();
                            //add uitextview to main view
                            scrollView.addSubview(tempText)
                        
                            //put the json in var realJson you just gathered, into the uitextview you created
                            tempText.attributedPlaceholder = NSMutableAttributedString(string:"\(text)")
                            textfields.append(tempText);
                        }
                        
                        else if realJson[i]["question"]["type"] == "textarea" {
                            //create a uitextview at coord (x=0,y=10) with width 300 and height 700
                            let tempText = UITextView(frame: CGRectMake(120, 10 + 60 * CGFloat(i), 200, 60))
                            
                            
                            tempText.backgroundColor = UIColor.whiteColor();
                            //add uitextview to main view
                            scrollView.addSubview(tempText)
                            
                            //put the json in var realJson you just gathered, into the uitextview you created
                            //tempText.attributedPlaceholder = NSMutableAttributedString(string:"\(text)")
                        }
                        
                        else if realJson[i]["question"]["type"] == "dropdown" {
                            let button1 = UIButton()
                            button1.frame = CGRectMake(100,100, 100, 50)
                            
                            button1.backgroundColor = UIColor.greenColor()
                            button1.setTitle("Test Button", forState: UIControlState.Normal)
                            
                            let button2 = UIButton()
                            
                            button2.frame = CGRectMake(100, 150, 100, 50)
                            button2.backgroundColor = UIColor.grayColor()
                            button2.setTitle("Test Button 2", forState: UIControlState.Normal)
                            
                            radioButtonController = SSRadioButtonsController(buttons: button1, button2)
                            radioButtonController!.delegate = self
                            radioButtonController!.shouldLetDeSelect = true
                            
                            scrollView.addSubview(button1)
                            scrollView.addSubview(button2)
                        }
                        
                        let tempLabel = UILabel(frame: CGRectMake(10, 10 + 60 * CGFloat(i), 100, 30))
                        scrollView.addSubview(tempLabel)
                        
                        tempLabel.text = "\(text)"
                        tempLabel.textColor = swiftColor;
                        tempLabel.textAlignment = NSTextAlignment.Right
                    }
                    
                    view.addSubview(scrollView)

                
                    
                } else {
                    print("could not get json obj from file.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    

}
