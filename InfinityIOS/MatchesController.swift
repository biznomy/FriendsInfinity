//
//  MatchesController.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 14/04/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import UIKit
import SwiftLoader

class MatchesListView : UITableViewCell {
    
    @IBOutlet weak var photoURL: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var email: UILabel!
}

class MatchesController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var friendView: UITableView!
    
    var myFriends = Array<AnyObject>()
    var deletePlanetIndexPath: NSIndexPath? = nil
    
    let httpService = HttpService();
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        httpService.genToken(){ (status) -> () in
            if(status){
                self.getFriends();
            }
        };
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendView.delegate = self
        friendView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getFriends(){
        SwiftLoader.show(title: "", animated: true)
        httpService.getFriends(){ (result) -> () in
            self.myFriends = result;
            self.friendView.reloadData();
            SwiftLoader.hide();
        }
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFriends.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! MatchesListView
        
        let row = indexPath.row
        let friend = myFriends[row] as! [String : AnyObject]
        
        cell.name?.text = friend["name"] as? String
        cell.email?.text = friend["email"] as? String
        cell.photoURL.layer.cornerRadius = cell.photoURL.frame.size.width/2
        cell.photoURL.clipsToBounds = true
        
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        if let data = NSData(contentsOf: NSURL(string: friend["photoURL"] as! String)! as URL) {
            cell.photoURL?.image = UIImage(data: data as Data)
        }else{
            cell.photoURL?.image = UIImage(named:"default")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let row = indexPath.row
        //        let studentDetailController = self.storyboard?.instantiateViewController(withIdentifier: "StudentDetailController") as! StudentDetailController
        //        let student = self.myFriends[row] as! [String : AnyObject]
        //        studentDetailController.student = student["_id"] as! String
        //        self.navigationController?.pushViewController(studentDetailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let unfriend = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Unfriend"){(UITableViewRowAction,NSIndexPath) -> Void in
            self.deletePlanetIndexPath = indexPath as NSIndexPath?
            let friend = self.myFriends[indexPath.row] as! [String : AnyObject]
            self.confirmUnfriend(friend: friend["name"] as! String)
            tableView.setEditing(false, animated: true)
        }
        
        let block = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Block"){(UITableViewRowAction,NSIndexPath) -> Void in
            self.deletePlanetIndexPath = indexPath as NSIndexPath?
            let friend = self.myFriends[indexPath.row] as! [String : AnyObject]
            self.blockReqUser(friend: friend["name"] as! String)
            tableView.setEditing(false, animated: true)
        }
        
        block.backgroundColor = UIColor.lightGray
        unfriend.backgroundColor = UIColor.red
        return [unfriend,block]
    }
    
    // Block Confirmation and Handling
    func blockReqUser(friend: String) {
        
    }
    
    
    // Delete Confirmation and Handling
    func confirmUnfriend(friend: String) {
        let alert = UIAlertController(title: "Unfriend ", message: "Are you sure you want to Unfriend \(friend)?", preferredStyle: .actionSheet)
        
        let UnfriendAction = UIAlertAction(title: "Unfriend", style: .destructive, handler: handleUnfriend)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(UnfriendAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleUnfriend(alertAction: UIAlertAction!) -> Void {
        SwiftLoader.show(title: "", animated: true)
        if let indexPath = deletePlanetIndexPath {
            let ff = self.myFriends[indexPath.row] as! [String : AnyObject]
            httpService.unfriend(id: ff["_id"] as! String){ (result,status) -> () in
                if(status){
                    self.friendView.beginUpdates()
                    self.myFriends.remove(at: indexPath.row)
                    self.friendView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                    self.deletePlanetIndexPath = nil
                    self.friendView.endUpdates()
                }
                SwiftLoader.hide();
            }
        }
    }
    
}
