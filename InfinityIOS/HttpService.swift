//
//  Service.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 04/04/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import Firebase
import Alamofire

class HttpService{
    var headers: HTTPHeaders = [:];
    var resultsList = Array<AnyObject>();
    
    func genToken(completion:@escaping (_ status:Bool) -> ()) {
        FirebaseService.getToken { (status, token) in
            self.headers = [
                "id-token":token,
                "Accept": "application/json"
            ]
            completion(status);
        }
    }
    
    
    func getFriends(completion :@escaping (_ friends:Array<AnyObject>) -> ()){
        let u = "friend/list";
        self._getList(url: u) { (data) in
            completion(data)
        }
    }
    
    func getFriendsSuggestion(page:Int,limit:Int,completion :@escaping (_ friends:Array<AnyObject>) -> ()){
        let u = "user/suggestion/list?page=\(page)&limit=\(limit)";
        self._getList(url: u) { (data) in
            completion(data)
        }
    }
    
    
    func getSentRequests(completion :@escaping (_ friends:Array<AnyObject>) -> ()){
        let u = "friend/request/out/list";
        self._getList(url: u) { (data) in
            completion(data)
        }
    }
    
    func getReceivedRequests(completion :@escaping (_ friends:Array<AnyObject>) -> ()){
        let u = "friend/request/in/list";
        self._getList(url: u) { (data) in
            completion(data)
        }
    }
    
    func unfriend(id:String,completion :@escaping (_ friends:NSDictionary,_ status:Bool) -> ()){
        let u = "friend/\(id)/unfriend";
        self._getSingleDocument(url: u) { (data,status) in
            completion(data,status)
        }
    }
    
    func sendFriendReq(id:String,completion :@escaping (_ user:NSDictionary,_ status:Bool) -> ()){
        let u = "friend/"+id+"/request";
        self._getSingleDocument(url: u) { (data,status) in
            completion(data,status)
        }
    }

    
    func getProfile(id:String,completion :@escaping (_ user:NSDictionary,_ status:Bool) -> ()){
        let u = "user/"+id;
        self._getSingleDocument(url: u) { (data,status) in
            completion(data,status)
        }
    }

    
    func _getSingleDocument(url:String,completion :@escaping (_ user:NSDictionary,_ status:Bool) -> ()){
        let u = Constants.Http.Domain + url;
        Alamofire.request(u,headers:self.headers).responseJSON { response in
            if let error = response.result.error {
                print(error)
            } else {
                if let JSON = response.result.value as? NSDictionary{
                    if((JSON["status"]) != nil){
                        let status = (JSON.object(forKey:"status") as? NSNumber)?.boolValue
                        completion(JSON,status!)
                    }else{
                        completion(JSON,true)
                    }
                    
                }
            }
        }
    }
    
    func _getList(url:String,completion :@escaping (_ list:Array<AnyObject>) -> ()){
        let u = Constants.Http.Domain + url;
        Alamofire.request(u,headers:self.headers).responseJSON { response in
            if let error = response.result.error {
                print(error)
            } else {
                if let JSON = response.result.value as? NSDictionary{
                    self.resultsList = (JSON["result"] as! NSArray) as Array<AnyObject>
                    completion(self.resultsList)
                }
            }
        }
    }
    
}
