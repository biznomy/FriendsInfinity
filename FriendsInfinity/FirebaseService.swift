//
//  FirebaseService.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 04/04/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import Firebase

class FirebaseService {
    
    static func getToken(completion :@escaping (_ status:Bool,_ token:String) -> ()) {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                user.getTokenWithCompletion({ (token, error) in
                    completion(true,token!);
                })
            }else{
                completion(false,"none");
            }
        }
    }
    
    static func isLogin() -> Bool {
        let firebaseAuth = FIRAuth.auth();
        let status = (firebaseAuth) != nil && ((firebaseAuth?.currentUser) != nil)
        return status;
    }
    
    static func logout() -> Bool{
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            print ("=== signing out ====");
            return true;
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
             return false;
        }
    }
    
}
