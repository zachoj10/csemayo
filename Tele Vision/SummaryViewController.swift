//
//  SummaryViewController.swift
//  Tele Vision
//
//  Created by Zachary Josephson on 11/2/15.
//  Copyright © 2015 Capstone. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    var patientInfo:[[String]]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (patientInfo)
        
        displayInfo()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayInfo(){
        let scrollView = UIScrollView(frame: CGRectMake(10, 175, 350, 300))
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        let swiftColor = UIColor(red: 15/255, green: 78/255, blue: 157/255, alpha: 1)

        
        for i in 0...patientInfo.count - 1{
            
            let tempLabel = UILabel(frame: CGRectMake(10, 10 + 60 * CGFloat(i), 100, 30))
            scrollView.addSubview(tempLabel)
            
            tempLabel.text = "\(patientInfo[i][0])"
            tempLabel.textColor = swiftColor;
            tempLabel.textAlignment = NSTextAlignment.Right
            
            scrollView.addSubview(tempLabel)
            
            
        }
        
        view.addSubview(scrollView)
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
