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
    
    var textAreas = [UITextView]()
    
    var textAreaLabels = [String]()
    
    var buttonControllers = [SSRadioButtonsController?]()
    
    var buttonFieldlabels = [String]()

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        getJson()
        
        
        

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
        
        if segue.identifier == "takePhoto"{
        
        var fieldArrays = [[String]]()
        var AreaArrays = [[String]]()
       
        let dest = segue.destinationViewController as! PhotoViewController
        //dest.name = name.text!
        
        for i in 0...textfields.count - 1{
            let unrwappedI : String! = textfields[i].text
            let label: String! = textfields[i].placeholder
            fieldArrays.append([unrwappedI, label])
            
        }
        
        for i in 0...buttonControllers.count - 1{
            var unwrappedI = String()
            
            let selected = buttonControllers[i]!.selectedButton()
            
            
            if selected != nil{
                unwrappedI = buttonControllers[i]!.selectedButton()!.titleLabel!.text!
            }
            else {
                unwrappedI = ""
            }
            fieldArrays.append([unwrappedI, buttonFieldlabels[i]])
        }
        
        
        for i in 0...textAreas.count - 1 {

            let unwrappedI : String! = textAreas[i].text
            AreaArrays.append([unwrappedI, textAreaLabels[i]])
        }
        
        dest.toPass = fieldArrays
        dest.passAreas = AreaArrays
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    func getJson(){
        //if the json file name "pro" exists then
        if let path = NSBundle.mainBundle().pathForResource("pro", ofType: "json") {
            do {
                
                let urlPath =  NSURL(string: "https://www.dropbox.com/s/ud1akkco3jyxe1q/pro.json?dl=1")
            
                //read the json data into data var
                let data = try NSData(contentsOfURL: urlPath!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                
                //cast data var to json object
                let jsonObj = JSON(data: data)
                
                
                //json data integrity and existence check
                if jsonObj != JSON.null {
                    print("got json successfully")
                    
                    //get jsonfile.form.questions 1st element (starts at 0)
                
                    //let scrollView = UIScrollView(frame: CGRectMake(10, 175, 350, 300))
                    scrollView.backgroundColor = UIColor.clearColor()
                    scrollView.scrollEnabled = true
                    scrollView.showsVerticalScrollIndicator = true
                    
                    let realJson = jsonObj["form"]["questions"]
                    
                    
                    var startingHeight = CGFloat(0.0)
                    
                    
                    
//                    let contentHeight = Float(realJson.count) * 70 + 10;
                    

                    //print (realJson[0])
                    let swiftColor = UIColor(red: 15/255, green: 78/255, blue: 157/255, alpha: 1)
                    for i in 0...realJson.count - 1{
                        let text = realJson[i]["question"]["fieldLabel"]
                        
                        let labelHeight = startingHeight


                        if realJson[i]["question"]["type"] == "textfield"{
                            //create a uitextview at coord (x=0,y=10) with width 300 and height 700
                            let tempText = UITextField(frame: CGRectMake(120, 10.0 + startingHeight, 200, 30))
                        
                            tempText.backgroundColor = UIColor.whiteColor();
                            //add uitextview to main view
                            scrollView.addSubview(tempText)
                        
                            //put the json in var realJson you just gathered, into the uitextview you created
                            tempText.attributedPlaceholder = NSMutableAttributedString(string:"\(text)")
                            textfields.append(tempText);
                        }
                        
                        else if realJson[i]["question"]["type"] == "textarea" {
                            //create a uitextview at coord (x=0,y=10) with width 300 and height 700
                            let tempText = UITextView(frame: CGRectMake(120, 10.0 + startingHeight, 200, 60))
                            
                            
                            tempText.backgroundColor = UIColor.whiteColor();
                            //add uitextview to main view
                            scrollView.addSubview(tempText)
                            
                            startingHeight += 30.0
                            
                            textAreas.append(tempText)
                            
                            textAreaLabels.append("\(text)")
                            
                            
                            //put the json in var realJson you just gathered, into the uitextview you created
                            //tempText.attributedPlaceholder = NSMutableAttributedString(string:"\(text)")
                        }
                        
                        else if realJson[i]["question"]["type"] == "dropdown" {
                            let buttonOptions = realJson[i]["question"]["choices"]
                            
                            var buttons = [SSRadioButton]()
                            
                            var radioButtonController: SSRadioButtonsController?

                            
                            radioButtonController = SSRadioButtonsController()
                            radioButtonController!.shouldLetDeSelect = true
                            
                            for j in 0...buttonOptions.count - 1{
                                
                                let text = buttonOptions[j]["choice"]
                                
                                let tempButton = SSRadioButton()
                                tempButton.frame = CGRectMake(120 , 10.0 + startingHeight, 200, 30)
                                startingHeight += 40.0
                                
                                tempButton.backgroundColor = UIColor.grayColor()
                                tempButton.setTitle("\(text)", forState: UIControlState.Normal)
                                buttons.append(tempButton)
                                
                                radioButtonController!.addButton(tempButton)
                                
                                
                                scrollView.addSubview(tempButton)

                            }
                            
                            buttonFieldlabels.append("\(text)")
                        
                            
                            buttonControllers.append(radioButtonController!)

                            
                            startingHeight -= 40.0
                            
                        }
                        
                        startingHeight += 70.0
                        
                        let tempLabel = UILabel(frame: CGRectMake(10, 10.0 + labelHeight, 100, 30))
                        scrollView.addSubview(tempLabel)
                        
                        tempLabel.text = "\(text)"
                        tempLabel.textColor = swiftColor;
                        tempLabel.textAlignment = NSTextAlignment.Right
                        
                        let contentHeightClean = CGFloat(startingHeight);
                        scrollView.contentSize = CGSizeMake(350, contentHeightClean);


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
