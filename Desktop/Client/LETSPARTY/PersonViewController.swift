//
//  PersonViewController.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/29/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
   
    
    let loginUrl:String="http://localhost:3000/login"
    let userGlobal=UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginTapped(_ sender: AnyObject) {
        
        
        let loginMap=["username": username.text!,"password":password.text!]
        
        userGlobal.setValue(username.text!, forKey: "user")
        
        
        var loginRequest=NetworkClass().UploadRequest(url: loginUrl, uploadMap: loginMap,callback: {(response)->Void in
            
            let title = "Login"
            let message = response
            print(message!)
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let alert = UIAlertController(title: title, message: message, preferredStyle:  .alert)
                let action = UIAlertAction(title: "Login Successfully",style: .default,handler: nil)
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            })
            
        })

    }
}
