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
import  Alamofire


class SignupController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    let httpService = HttpService();
    
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
    
    func displayAlert(msg:String){
        let alert = UIAlertController(title: "Information ", message:msg , preferredStyle: .alert)
        let CancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signup(_ sender: Any) {
        SwiftLoader.show(title: "", animated: true);
        let e = self.email.text!,p = self.password.text!,name = self.name.text!;
        let jsonObject = [
            "displayName":name,
            "email": e,
            "password": p
        ]
        let u = Constants.Http.Domain + "fcm/signup";
        Alamofire.request(u,method:.post, parameters: jsonObject, encoding: JSONEncoding.default).responseJSON { response in
            if let error = response.result.error {
                SwiftLoader.hide();
                print(error)
            } else {
                if let JSON = response.result.value as? NSDictionary{
                    SwiftLoader.hide();
                    if((JSON["status"]) != nil){
                        let result = (JSON.object(forKey:"result") as? NSDictionary);
                        self.displayAlert(msg: result?["message"] as! String);
                    }else{
                        self.displayAlert(msg:"");
                    }
                    
                }
            }
        }
        
//        httpService.signup(data:jsonObject as NSDictionary){(result,status:Bool) -> () in
//            let msg = result["message"] as? String;
//            self.displayAlert(msg:msg);
//        }
        
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
