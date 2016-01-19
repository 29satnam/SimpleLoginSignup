//
//  LoginViewController.swift
//  PhotoApp
//
//  Created by Satnam Sync on 1/18/16.
//  Copyright © 2016 Satnam Sync. All rights reserved.
//

let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

import UIKit
import Alamofire

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
        
    }
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signinTapped(sender : UIButton) {
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let alertController = UIAlertController(title: "Sign in Failed!", message: "Please enter Username and Password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
            
            
        } else {

        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://my.vigasdeep.com:2403/users/login")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let post:NSString = "username=\(username)&password=\(password)"
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        let postLength:NSString = String( postData.length )

        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {urlData, response, error -> Void in
            if (urlData != nil) {
                let res = response as! NSHTTPURLResponse!;
                if 200..<300 ~= res.statusCode {
                    do {
                        let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                        //On success, invoke `completion` with passing jsonData.
                        let sessionId:String = jsonData.valueForKey("id") as! String
                        if(sessionId != "") {
                            
                            prefs.setObject(username, forKey: "USERNAME")
                            prefs.setObject(sessionId, forKey: "SESSIONID")
                            prefs.setInteger(1, forKey: "ISLOGGEDIN")
                            prefs.synchronize()
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            
                            /* var error_msg:NSString
                            if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                            } else {
                            error_msg = "Unknown Error"
                            } */
                            
                            dispatch_async(dispatch_get_main_queue(), {

                            let alertController = UIAlertController(title: "Sign in Failed!", message: "Failed to retrieve data", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                            alertController.addAction(OKAction)
                            self.presentViewController(alertController, animated: true) { }
                            })
                        }
                    } catch _ as NSError {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let alertController = UIAlertController(title: "Sign in Failed!", message: "Server error", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                            alertController.addAction(OKAction)
                            self.presentViewController(alertController, animated: true) { }
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                    let alertController = UIAlertController(title: "Sign in Failed!", message: "Check Credentials", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) { }
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Sign in Failed!", message: "Check Internet Connection", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) { }
                })
            }
            })
        task.resume()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}