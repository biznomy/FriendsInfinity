//
//  TinderController.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 11/04/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import UIKit
import Koloda
import pop
import SwiftLoader


private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSprinvareed: CGFloat = 16
private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


class TinderController: UIViewController {
    
    var suggestionsList:Array<AnyObject> = [],page:Int = 1, limit:Int = 15;
 
    let httpService = HttpService();
    
    var selectedCard:Int = 0,limitOver:Bool = false;
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        //self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        httpService.genToken(){ (status) -> () in
            if(status){
                self.page = 1;
                self.kolodaView.reloadData();
                self.getFriendsSuggestion();
            }
        };
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getFriendsSuggestion(){
        SwiftLoader.show(title: "", animated: true)
        httpService.getFriendsSuggestion(page:page,limit:limit){ (result) -> () in
            self.suggestionsList = [];
            self.suggestionsList = result;
            self.page = self.page + 1;
            //self.kolodaView.reloadData();
            self.kolodaView.resetCurrentCardIndex()
            SwiftLoader.hide();
        }
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        let crntIndx = self.kolodaView.currentCardIndex;
        if(crntIndx < self.suggestionsList.count && !limitOver){
            self.kolodaView?.swipe(.right);
            let id = self.suggestionsList[crntIndx]["_id"];
            httpService.sendFriendReq(id:id as! String){ (result,status:Bool) -> () in
                if status == false{
                    self.limitOver = true;
                    self.kolodaView?.swipe(.left)
                    self.displayAlert(msg:"Your Friend Request was not sent because the Request limit was reached.")
                }
            }
        }else{
            self.displayAlert(msg:"Your Friend Request was not sent because the Request limit was reached.")
        }
        
    }
    
    func displayAlert(msg:String){
      let alert = UIAlertController(title: "Information ", message:msg , preferredStyle: .alert)
      let CancelAction = UIAlertAction(title: "Ok", style: .default)
       alert.addAction(CancelAction)
      self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let tinderFriend = segue.destination as! TinderFriendDetailController
            let user = self.suggestionsList[selectedCard];
            tinderFriend.userName = user["name"] as! String;
            tinderFriend.profilePic = user["photoURL"] as! String;
            tinderFriend.userEmail = user["email"] as! String;

        }
    }
}

//MARK: KolodaViewDelegate
extension TinderController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.getFriendsSuggestion();
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        self.selectedCard = index;
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSprinvareed
        return animation
    }
}

// MARK: KolodaViewDataSource
extension TinderController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.suggestionsList.count
    }
   
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIView(frame: CGRect.init(x:0, y:0, width: 394, height:kolodaView.frame.height)),
            subview  = UIView(frame: CGRect.init(x:0, y:415, width: 390, height:80)),
            cover = UIImageView(frame: CGRect.init(x:0, y:0, width: 390, height:420));
        if(self.suggestionsList.count >= 1){
            let user = self.suggestionsList[index];
            cover.contentMode = .redraw
            if let data = NSData(contentsOf: NSURL(string: user["photoURL"] as! String)! as URL) {
                cover.image = UIImage(data: data as Data)!
            }else{
                cover.image = UIImage(named: "default")
            }
            view.addSubview(cover)
            
            subview.backgroundColor = UIColor.white
            let name = UILabel(frame: CGRect.init(x: 100, y: 15, width: 300, height: 30))
            name.text = user["name"] as? String
            name.font = UIFont(name:"Arial Rounded MT Bold", size: 22)
            let email = UILabel(frame: CGRect.init(x: 100, y: 15 + 20 + 10 , width: 300, height: 20))
            email.text = user["email"] as? String
            let profilePhoto = UIImageView(frame: CGRect.init(x:10, y:10, width:60, height:60));
            profilePhoto.contentMode = .redraw
            profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width/2
            profilePhoto.clipsToBounds = true
            if let data = NSData(contentsOf: NSURL(string: user["photoURL"] as! String)! as URL) {
                profilePhoto.image = UIImage(data: data as Data)!
            }else{
                profilePhoto.image = UIImage(named: "default")
            }
            subview.addSubview(profilePhoto)
            subview.addSubview(name);
            subview.addSubview(email);
        }
        
        view.addSubview(subview)
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 3
        view.layer.masksToBounds = false
        
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        return view;
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
