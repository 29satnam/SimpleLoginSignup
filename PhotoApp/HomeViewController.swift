//
//  ViewController.swift
//  PhotoApp
//
//  Created by Satnam Sync on 1/17/16.
//  Copyright © 2016 Satnam Sync. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet var usernameLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
            
            
            let token = prefs.valueForKey("SESSIONID") as? String
            
            
            let url = NSURL(string: "http://xxxxxxxxx.com:2403/users/me")
            
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            request.setValue( "Bearer \(token!)", forHTTPHeaderField: "Authorization")
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()!) { response, maybeData, error in
                if let data = maybeData {
                    let contents = NSString(data:data, encoding:NSUTF8StringEncoding)
                    print(contents!, "bitch")
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}
