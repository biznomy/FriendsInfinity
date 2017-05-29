//
//  ViewController.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 30/03/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import UIKit
import Firebase
import SwiftLoader

class LoginController: UIViewController {
    
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
    }

    
    @IBAction func login(_ sender: Any) {
        SwiftLoader.show(title: "", animated: true);
        let e = self.email.text!
        let p = self.password.text!
        self.firebaseLogin(email: e,password:p )
    }
    
    // digilocker_ind@gmail.com
    func firebaseLogin(email:String,password:String ){
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            SwiftLoader.hide();
            if((user) != nil){
                self.performSegue(withIdentifier: "gotoHome", sender: nil)
            }else{
                let alert =  UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let CancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(CancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
   
}

