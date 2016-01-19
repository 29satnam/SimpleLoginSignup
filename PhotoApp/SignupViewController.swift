//
//  SignupViewController.swift
//  PhotoApp
//
//  Created by Satnam Sync on 1/18/16.
//  Copyright © 2016 Satnam Sync. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var fullName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoLogin(sender : UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func signupTapped(sender : UIButton) {
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        let fullname:NSString = fullName.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") || fullname.isEqualToString("") ) {
            
            let alertController = UIAlertController(title: "Sign up Failed!", message: "Please enter Username and Password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
        } else {
       
            let request = NSMutableURLRequest(URL: NSURL(string: "http://my.vigasdeep.com:2403/users")!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            let post:NSString = "username=\(username)&password=\(password)&fullname=\(fullname)"
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let postLength:NSString = String( postData.length )
            
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {urlData, response, error -> Void in
                
                print(urlData, response, error)
                
                if (urlData != nil) {
                    let res = response as! NSHTTPURLResponse!;
                    if 200..<300 ~= res.statusCode {
                        do {
                            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary

                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                         } catch _ as NSError {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                let alertController = UIAlertController(title: "Sign up Failed!", message: "Server error", preferredStyle: .Alert)
                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                                alertController.addAction(OKAction)
                                self.presentViewController(alertController, animated: true) { }
                            })
                        }
                        
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let alertController = UIAlertController(title: "Sign up Failed!", message: "Username already exist", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                            alertController.addAction(OKAction)
                            self.presentViewController(alertController, animated: true) { }
                        })
                        
                    }
                    
                } else {
                 
                    dispatch_async(dispatch_get_main_queue(), {
                        let alertController = UIAlertController(title: "Sign up Failed!", message: "Check Internet Connection", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true) { }
                    })
                    
                }
                
            })
            task.resume()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}