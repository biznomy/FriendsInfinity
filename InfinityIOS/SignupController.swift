//
//  SignupController.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 30/03/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import UIKit
import Firebase
import SwiftLoader
import Alamofire


class SignupController: UIViewController {

    var fixedURL : String = "http://138.197.217.75:3100/fcm/"

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
        self.name.resignFirstResponder()
    }
    
    
    @IBAction func signup(_ sender: Any) {
        SwiftLoader.show(title: "signup ...", animated: true);
        let e = self.email.text!,p = self.password.text!,name = self.name.text!;
        let jsonObject = [
            "displayName":name,
            "email": e,
            "password": p
        ]
        
        let urlstring = fixedURL + "signup";
        
        Alamofire.request(urlstring,method:.post, parameters: jsonObject, encoding: JSONEncoding.default).responseJSON { response in
            print(response);
        }
    }
    
    
    func login(email:String,password:String ){
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            SwiftLoader.hide();
            if((user) != nil){
                self.performSegue(withIdentifier: "gotoHome", sender: nil)
            }else{
                let alert =  UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }


}
