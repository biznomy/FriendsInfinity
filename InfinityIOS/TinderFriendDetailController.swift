//
//  TinderFriendDetailController.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 13/04/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import UIKit

class TinderFriendDetailController: UIViewController {

    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    var userName:String = "",profilePic :String = "",userEmail :String = "";
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePhoto.isUserInteractionEnabled = true
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.getSwipeAction(_:)))
        swipeGesture.direction = [.down,.up];
        self.profilePhoto.addGestureRecognizer(swipeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.name.text = self.userName
        self.email.text = self.userEmail
        if let data = NSData(contentsOf: NSURL(string: self.profilePic)! as URL) {
            self.profilePhoto.image = UIImage(data: data as Data)!
        }else{
            self.profilePhoto.image = UIImage(named: "default")
        }
    }
    
    
    func getSwipeAction( _ recognizer : UISwipeGestureRecognizer){
        
        self.dismiss(animated: true, completion: nil);
        
    }}
