//
//  CTViewController.swift
//  chat-ios
//
//  Created by Brian Correa on 6/19/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit
import Cloudinary

class CTViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLUploaderDelegate  {
    
    static var currentUser = CTProfile() //shared across application
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(CTViewController.userLoggedIn(_:)),
                                       name: Constants.kUserLoggedInNotification,
                                       object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func userLoggedIn(notification: NSNotification){
        if let user = notification.userInfo!["user"] as? Dictionary<String, AnyObject>{
            CTViewController.currentUser.populate(user)
        }
    }
    
    func postLoggedInNotification(currentUser: Dictionary<String, AnyObject>){
        let notification = NSNotification(
            name: Constants.kUserLoggedInNotification,
            object: nil,
            userInfo: ["user":currentUser]
        )
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotification(notification)
        
    }
    
    func exit(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Camera Methods:
    
    func showCameraOptions() -> UIAlertController {
        let actionSheet = UIAlertController(title: "Select Photo Source", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            
            print("Select Camera: \(action.title!)")
            dispatch_async(dispatch_get_main_queue(), {
                self.launchPhotoPicker(.Camera)
            })
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { action in
            
            print("Select Photo Library: \(action.title!)")
            dispatch_async(dispatch_get_main_queue(), {
                self.launchPhotoPicker(.PhotoLibrary)
            })
        }))
        
        return actionSheet
    }
    
    func launchPhotoPicker(sourceType: UIImagePickerControllerSourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UploadImage
    func uploadImage(image: UIImage, completion: (imageInfo:Dictionary<String, AnyObject>) -> Void){
        let clouder = CLCloudinary(url: "cloudinary://653334994547459:tCn9eIutSZdgag0a5LF_4Ma7amo@hrot1fmxg")
        let forUpload = UIImageJPEGRepresentation(image, 0.5)
        
        let uploader = CLUploader(clouder, delegate: self)
        
        uploader.upload(forUpload, options: nil,
                        withCompletion: { (dataDictionary: [NSObject: AnyObject]!, errorResult:String!, code:Int, context: AnyObject!) -> Void in
                            
                            print("Upload Response: \(dataDictionary)")
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                var imageUrl = ""
                                if let secure_url = dataDictionary["secure_url"] as? String{
                                    imageUrl = secure_url
                                }
                                
                                let thumbnailUrl = imageUrl.stringByReplacingOccurrencesOfString("/upload/", withString: "/upload/t_thumb_250/")
                                
                                let imageInfo = [
                                    "original": imageUrl,
                                    "thumb": thumbnailUrl
                                ]
                                
                                completion(imageInfo: imageInfo)
                                
                            })
            },
                        
                        andProgress: { (bytesWritten:Int, totalBytesWritten:Int, totalBytesExpectedToWrite:Int, context:AnyObject!) -> Void in
                            
                            print("Upload progress: \((totalBytesWritten * 100)/totalBytesExpectedToWrite) %");
            }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    
}