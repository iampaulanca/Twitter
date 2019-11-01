//
//  ViewController.swift
//  Twitter
//
//  Created by Paul Ancajima on 10/30/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func onLoginButton(_ sender: Any) {
        let url = "https://api.twitter.com/oauth/request_token"
        UserDefaults.standard.set(true, forKey: "userLoggedIn")
        TwitterAPICaller.client?.login(url: url, success: {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print("Could not login.")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
