//
//  SettingsViewController.swift
//  ChatClient
//
//  Created by Роман Смоляков on 06/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    


    @IBOutlet weak var imgUserLogo: UIImageView!
    lazy var realm = try! Realm()
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        user = realm.objects(User.self).filter("id = '\(Constants.id)'").first
        updateProfile()
        SocketHelper.sharedInstance.getLogo(id: Constants.id)
        
        SocketHelper.sharedInstance.socket.on("getlogo", callback: { (data, ack) in
            if let avatar = data[0] as? String {
                if(self.user!.avatar.isEmpty && !avatar.isEmpty){
                    try! self.realm.write {
                        self.user.avatar = avatar
                         self.updateProfile()
                    }
                }else if(avatar.isEmpty && !self.user!.avatar.isEmpty){
                       SocketHelper.sharedInstance.setLogo(id: Constants.id, avatar: self.user!.avatar)
                }else if (!avatar.isEmpty && !self.user!.avatar.isEmpty && avatar != self.user!.avatar){
                    try! self.realm.write {
                        self.user.avatar = avatar
                        self.updateProfile()
                    }
                }
            }
        })
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgUserLogo.isUserInteractionEnabled = true
        imgUserLogo.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateProfile(){
        if(user != nil){
            self.imgUserLogo.image = Utility.getImageFromBase64(str: user!.avatar)
        }
//        if (!self.profile.avatar.isEmpty) {
//            self.imgUserLogo.loadImageUsingCache(withUrl: self.profile.avatar)
//        }
    }
   
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
       
        switch tappedImage {
    
        case self.imgUserLogo:
            importImage()
            return
            break
        default:
            return
        }
        
  
    }

    func importImage(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
            print("completed")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
//        guard let image = info[.originalImage] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {

        
  
        
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let resizedImage = Utility.resizeImage(image: image, newWidth: CGFloat(50))
            self.imgUserLogo.image = resizedImage
            let imageData: Data? = resizedImage.pngData()
            let imageStr = imageData?.base64EncodedString() ?? "" //options: .lineLength64Characters
            print(imageStr)
            
            try! self.realm.write {
//                 self.user.avatar = "data:image/png;base64,\(imageStr))"
                 self.user.avatar = imageStr
                SocketHelper.sharedInstance.setLogo(id: Constants.id, avatar: imageStr)
            }
           
            
//            NetworkLayer.updateProfile(id: Constants.auth.user.id, profile: ["avatar": "data:image/png;base64,\(imageStr)"], completion: { (success, user) in
//                if(success){
//                    Constants.user = user
//                    self.profile.avatar = user.avatar
//                    self.updateProfile()
//                }
//            })
//
        }else {
             fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
