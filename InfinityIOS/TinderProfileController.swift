//
//  TinderProfileController.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 13/04/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import UIKit


class TinderProfileController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    
    @IBOutlet weak var editbtn: UIButton!
    
    let httpService = HttpService();
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePhoto.layer.borderColor = UIColor.lightGray.cgColor
        profilePhoto.layer.shadowColor = UIColor.lightGray.cgColor
        profilePhoto.layer.shadowOffset = CGSize(width: 0, height: 5)
        profilePhoto.layer.shadowRadius = 15
        profilePhoto.layer.shadowOpacity = 3
        profilePhoto.layer.masksToBounds = false
        
        profilePhoto.layer.cornerRadius=profilePhoto.frame.size.width/2
        profilePhoto.clipsToBounds = true
        editbtn.layer.cornerRadius=editbtn.frame.size.width/2
        editbtn.clipsToBounds = true
        profilePhoto.layer.borderWidth = 0.2;
        httpService.genToken(){ (status) -> () in
            if(status){
                self.getProfile();
            }
        };
       // picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func gotoSugges(_ sender: Any) {
//       self.dismiss(animated: true, completion: nil);
//    }
    
    func openCamera(alertAction: UIAlertAction!) -> Void {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            present(alertVC,animated: true,completion: nil)
        }
    }
    
    func openGallery(alertAction: UIAlertAction!) -> Void {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func editProfilePhoto(_ sender: Any) {
        let alert = UIAlertController(title: "Choose One ", message: "", preferredStyle: .actionSheet)
        let Camera = UIAlertAction(title: "Camera", style: .destructive, handler: self.openCamera)
        let Gallery = UIAlertAction(title: "Gallery", style: .destructive, handler: openGallery)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func gotoSettingView(_ sender: Any) {
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logout" {
          let logout =  FirebaseService.logout();
            print(logout);
        }
    }
    
    
    func getProfile(){
        httpService.getProfile(id:"me"){ (user,status) -> () in
            print(user);
            if let data = NSData(contentsOf: NSURL(string: user["photoURL"] as! String)! as URL) {
                print(data);
                self.profilePhoto?.image = UIImage(data: data as Data)
            }else{
                print("====== ");
                self.profilePhoto?.image = UIImage(named:"default")
            }
            self.name.text = user["name"] as? String
            self.bio.text = user["bio"] as? String
        }
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePhoto.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePhoto.image = image
        } else {
            profilePhoto.image = nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
