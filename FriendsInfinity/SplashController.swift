//
//  SplashController.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 30/03/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import UIKit
import SwiftLoader


class SplashController: UIViewController {
    
    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loaderConfig();
                
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                if(FirebaseService.isLogin()){
                    self.performSegue(withIdentifier: "isLogin", sender: nil)
                }else{
                    self.performSegue(withIdentifier: "isNotLogin", sender: nil)
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func loaderConfig(){
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.spinnerLineWidth = 2.0
        config.spinnerColor = .red
        config.foregroundColor = .black
        config.foregroundAlpha = 0.8
        SwiftLoader.setConfig(config: config)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
