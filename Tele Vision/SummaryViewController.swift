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
    
    var patientAreas:[[String]]!
    
    var patientImg:UIImage!

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //delete the generated pdf
    func deleteFile() {
        let fileManager = NSFileManager()

        let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first!
        let fileURL = dir.stringByAppendingPathComponent("test.pdf")
        
        do {
            try fileManager.removeItemAtPath(fileURL)
            print("successfully deleted pdf")
        } catch {
            print("No file found")
        }
    }
    //delete the generated pdf end
    


    func displayInfo(){
        var pdfString = "<body><h1 style=\"text-align:center\"><b>PATIENT RECORD OUTCOME</b></h1>"
        let screenSize: CGRect = UIScreen.mainScreen().bounds

        let screenWidth = screenSize.width
        
        let middleScreen = screenWidth * 0.5;
        
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        let contentHeight = Float(patientInfo.count) * 70 + 10 + 210;
        let contentHeightClean = CGFloat(contentHeight);
        

        
        let swiftColor = UIColor(red: 15/255, green: 78/255, blue: 157/255, alpha: 1)
        
        let swiftBlack = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        var verticalPosition = CGFloat(0.0)

        
        for i in 0...patientInfo.count - 1{
            
            let tempLabel = UILabel(frame: CGRectMake(middleScreen - 150 - 10, 10 + verticalPosition, 150, 30))
            scrollView.addSubview(tempLabel)
            
            tempLabel.text = "\(patientInfo[i][1])"
            tempLabel.textColor = swiftBlack;
            tempLabel.textAlignment = NSTextAlignment.Right
            tempLabel.font = UIFont(name: "Helvetica", size: 25)
            
            scrollView.addSubview(tempLabel)
            
            let tempValue = UILabel(frame: CGRectMake(middleScreen + 10, 10 + verticalPosition, 145, 30))
            scrollView.addSubview(tempValue)
            
            tempValue.text = "\(patientInfo[i][0])"
            tempValue.textColor = swiftColor;
            tempValue.textAlignment = NSTextAlignment.Left
            
            verticalPosition += 40.0
            var newString = "<p><b>" + patientInfo[i][1]
            newString += ":</b> " + patientInfo[i][0] + "</p>"
            pdfString += newString
        }
        
        
        for i in 0...patientAreas.count - 1{
            
            let tempLabel = UILabel(frame: CGRectMake(middleScreen - 150 - 10, 10 + verticalPosition, 150, 30))
            scrollView.addSubview(tempLabel)
            
            tempLabel.text = "\(patientAreas[i][1])"
            tempLabel.textColor = swiftBlack;
            tempLabel.textAlignment = NSTextAlignment.Right
            tempLabel.font = UIFont(name: "Helvetica", size: 25)
            
            scrollView.addSubview(tempLabel)
            
            let tempValue = UITextView(frame: CGRectMake(middleScreen + 10, 10 + verticalPosition, 145, 60))
            scrollView.addSubview(tempValue)
            
            tempValue.text = "\(patientAreas[i][0])"
            tempValue.textColor = swiftColor;
            tempValue.textAlignment = NSTextAlignment.Left
            tempValue.editable = false
            
            verticalPosition += 70
            pdfString += "<p><b>" + patientAreas[i][1]
            pdfString += ":</b> " + patientAreas[i][0] + "</p>"
            
        }
        
        let imgStart = Int(verticalPosition + 20.0)
        scrollView.contentSize = CGSizeMake(350, CGFloat(imgStart) + 220);

        
        let imageView = UIImageView(image: patientImg!)
        imageView.frame = CGRect(x: Int(middleScreen - 150.0/2.0), y:imgStart, width: 150, height:200)
        
        scrollView.addSubview(imageView)
        
        
        
        view.addSubview(scrollView)
        //from git user nyg
        //via http://www.labs.saachitech.com/2012/10/23/pdf-generation-using-uiprintpagerenderer
        //Also used http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
        
        let fmt = UIMarkupTextPrintFormatter(markupText: pdfString)
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAtIndex: 0)

        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let printable = CGRectInset(page, 0, 0)
        
        render.setValue(NSValue(CGRect: page), forKey: "paperRect")
        render.setValue(NSValue(CGRect: printable), forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil)
        
        for i in 1...render.numberOfPages() {
            
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPageAtIndex(i - 1, inRect: bounds)
            
            var image = patientImg
            image?.drawInRect(CGRectMake(300, 300, 100, 100))
        }
        
        UIGraphicsEndPDFContext();
        
        print ("here")
        
        pdfData.writeToFile("patientRecord.pdf", atomically: true)
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent("test.pdf")
            let text = "Test"
            
            print (dir)
            do {
                try pdfData.writeToFile(path, atomically: true)
                
                //start of amazon s3 connection
                //taken from http://shrikar.com/ios-app-development-upload-images-to-aws-s3/
                //changed some lines to conform to swift2.0
                
                let transferManager = AWSS3TransferManager.defaultS3TransferManager()
                
                let testFileURL1 = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("temp")
                let uploadRequest1 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
                
                pdfData.writeToURL(testFileURL1, atomically: true)
                
                uploadRequest1.bucket = "cse486-teamjuly"
                uploadRequest1.key =  "patientRecord"
                uploadRequest1.body = testFileURL1
                
                let task = transferManager.upload(uploadRequest1)

                task.continueWithBlock { (task) -> AnyObject! in
                    if task.error != nil {
                        print("Error: \(task.error)")
                        
                        //alert saying unsuccessful upload
                        let alertController = UIAlertController(title: "Upload Unsuccessful", message: task.error.localizedDescription, preferredStyle: .Alert)
                        
                        let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(yesAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    
                    } else {
                        print("Upload successful")
                        
                        //alert saying successful upload
                        let alertController = UIAlertController(title: "Upload Successful", message: "Successful upload to Mayo Clinic Servers", preferredStyle: .Alert)
                        
                        let yesAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(yesAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        //delete the pdf file
                        self.deleteFile()
                    }
                    return nil
                }
                //end of amazon s3 conenction
            }
        
            catch {
                print ("error")
            }
        }
        
        
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
