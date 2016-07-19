//
//  CTChatViewController.swift
//  chat-ios
//
//  Created by Brian Correa on 7/8/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit
import Firebase

class CTChatViewController: CTViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    //Firebase Config:
    var firebase: FIRDatabaseReference! // establishes connection and maintains connection to DB
    var _refHandle: UInt!
    
    //MARK: - Properties:
    var place: CTPlace!
    var chatTable: UITableView!
    var posts = Array<CTPost>()
    var keys = Array<String>()
    
    var bottomView: UIView!
    var messageField: UITextField!
    var selectedImage: UIImage?
    var cameraBtn: UIButton!
    
//    MARK: - Lifecycle Methods
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.hidesBottomBarWhenPushed = true
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(
            self,
            selector: #selector(CTChatViewController.shiftKeyboardUp(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(CTChatViewController.shiftKeyboardDown(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    override func loadView() {
        print("loadView")
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .lightGrayColor()
        
        self.chatTable = UITableView(frame: frame, style: .Plain)
        self.chatTable.dataSource = self
        self.chatTable.delegate = self
        self.chatTable.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        self.chatTable.separatorStyle = .None
        self.chatTable.showsVerticalScrollIndicator = false
        self.chatTable.registerClass(CTChatTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        view.addSubview(self.chatTable)
        
        var height = self.chatTable.contentInset.bottom
        let width = frame.size.width
        let y = frame.size.height //offscreen bounds; will animate in
        
        self.bottomView = UIView(frame: CGRect(x: 0, y: y, width: width, height: height))
        self.bottomView.autoresizingMask = .FlexibleTopMargin
        self.bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(bottomView)
        
        let padding = CGFloat(6)
        let btnWidth = CGFloat(80)
        
        self.cameraBtn = UIButton(type: .Custom)
        self.cameraBtn.frame = CGRect(x: 0, y: 0, width: height, height: height)
        self.cameraBtn.backgroundColor = .clearColor()
        self.cameraBtn.setImage(UIImage(named: "camera_icon.png"), forState: .Normal)
        self.cameraBtn.addTarget(
            self,
            action: #selector(CTChatViewController.photoSources),
            forControlEvents: .TouchUpInside)
        self.bottomView.addSubview(cameraBtn)
        
        height = height-2*padding
        
        self.messageField = UITextField(frame: CGRect(x: padding+44, y: padding, width: width-2*padding-btnWidth-44, height: height))
        self.messageField.borderStyle = .RoundedRect
        self.messageField.placeholder = "Post a Message"
        self.messageField.delegate = self
        self.bottomView.addSubview(self.messageField)
        
        let btnSend = UIButton(type: .Custom)
        btnSend.frame = CGRect(x: width-btnWidth, y: padding, width: 74, height: height)
        btnSend.setTitle("Send", forState: .Normal)
        btnSend.backgroundColor = UIColor.lightGrayColor()
        btnSend.layer.cornerRadius = 5
        btnSend.layer.masksToBounds = true
        btnSend.layer.borderColor = UIColor.darkGrayColor().CGColor
        btnSend.layer.borderWidth = 0.5
        self.bottomView.addSubview(btnSend)
        btnSend.addTarget(self,
                          action: #selector(CTChatViewController.postMessage),
                          forControlEvents: .TouchUpInside)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.firebase = FIRDatabase.database().reference() // initialize FB manager
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear:")
        
        if (self._refHandle != nil){
            return
        }
        
        //Listen for new messages in the FB DB
        self._refHandle = self.firebase.child(self.place.id).queryLimitedToLast(25).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            if let payload = snapshot.value as? Dictionary<String, AnyObject> {
                
                for key in payload.keys {
                    let postInfo = payload[key] as! Dictionary<String, AnyObject>
                    if(self.keys.contains(key)){
                        continue
                    }
                    
                    self.keys.append(key)
                    let post = CTPost()
                    post.id = key
                    post.populate(postInfo)
                    self.posts.append(post)
                }
                
                print("\(self.posts.count) POSTS")
                self.posts.sortInPlace{
                    $0.timestamp.compare($1.timestamp) == .OrderedAscending
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.chatTable.reloadData()
                    
                    let lastIndexPath = NSIndexPath(forItem: self.posts.count-1, inSection: 0)
                    self.chatTable.scrollToRowAtIndexPath(
                        lastIndexPath,
                        atScrollPosition: .Top,
                        animated: true
                    )
                })
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear")
        
        //already on screen
        let bottomFrame = self.bottomView.frame
        if (bottomFrame.origin.y < self.view.frame.size.height){
            return
        }
        
        UIView.animateWithDuration(0.35,
                                   delay: 0.25,
                                   options: UIViewAnimationOptions.CurveLinear,
                                   animations: {
                                    var bottomFrame = self.bottomView.frame
                                    bottomFrame.origin.y = bottomFrame.origin.y-self.bottomView.frame.size.height
                                    self.bottomView.frame = bottomFrame
            },
                                   completion: nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.firebase.removeObserverWithHandle(self._refHandle)
    }
    
    func photoSources(){
        let actionSheet = self.showCameraOptions()
        if(self.selectedImage == nil){
            self.presentViewController(actionSheet, animated: true, completion: nil)
            return
        }
        
        actionSheet.addAction(UIAlertAction(title: "Remove Image", style: .Default, handler: { action in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.selectedImage = nil
                self.cameraBtn.setImage(nil, forState: .Normal)
                
                UIView.transitionWithView(
                    self.cameraBtn,
                    duration: 0.3,
                    options: UIViewAnimationOptions.TransitionFlipFromLeft,
                    animations: {
                        self.cameraBtn.setImage(UIImage(named: "camera_icon.png"), forState: .Normal)
                        self.cameraBtn.alpha = 1.0
                    }, completion: nil)
            })
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Post Message
    func postMessage(){
        print("postMessage")
        
        let originalDefault = ""
        let thumbnailDefault = ""
        let imageInfo = ["original": originalDefault, "thumb": thumbnailDefault]
        self.postMessageDict(self.preparePostInfo(imageInfo))
    }
    
    func preparePostInfo(imageInfo: Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject>{
        
        var postInfo = Dictionary<String, AnyObject>()
        
        postInfo["from"] = ["id":CTViewController.currentUser.id!, "username":CTViewController.currentUser.username]
        postInfo["message"] = self.messageField.text!
        postInfo["timestamp"] = "\(NSDate().timeIntervalSince1970)"
        postInfo["place"] = ["id":self.place.id, "name":self.place.name]
        postInfo["image"] = imageInfo
        return postInfo
    }
    
    func postMessageDict(postInfo: Dictionary<String, AnyObject>){
        
        let message = postInfo["message"] as! String
        if (message.characters.count == 0){
            print("Empty message")
            let alert = UIAlertController(title: "No Message", message: "Please Enter a Message", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        self.messageField.resignFirstResponder()
        
        if (self.selectedImage != nil){ //upload image first
            self.uploadImage(self.selectedImage!, completion: { imageInfo in
                self.selectedImage = nil
                self.postMessageDict(self.preparePostInfo(imageInfo))
            })
            return
        }
        
        self.messageField.text = ""
        
        //Push data to Firebase Database
        self.firebase.child(self.place.id).childByAutoId().setValue(postInfo)
    }
    
    
    //MARK: - UIImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        print("didFinishPickingMediaWithInfo: \(info)")
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.selectedImage = image
        }
        
        picker.dismissViewControllerAnimated(true, completion: {
            UIView.transitionWithView(
                self.cameraBtn,
                duration: 0.3,
                options: UIViewAnimationOptions.TransitionFlipFromLeft,
                animations: {
                    self.cameraBtn.setImage(self.selectedImage, forState: .Normal)
                    self.cameraBtn.alpha = 1.0
                },
                completion: nil)
        })
    }
    
    
    //MARK: - KeyboardNotification
    
    func shiftKeyboardUp(notification: NSNotification){
        print("shiftKeyboardUp")
        if let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
            
            print("\(notification.userInfo!)")
            
            var frame = self.bottomView.frame
            frame.origin.y = keyboardFrame.origin.y-frame.size.height
            self.bottomView.frame = frame
            
            frame = self.chatTable.frame
            frame.origin.y = -keyboardFrame.size.height
            self.chatTable.frame = frame    
        }
    }
    
    func shiftKeyboardDown(notificaion: NSNotification){
        print("shiftKeyboardDown")
        
        var frame = self.bottomView.frame
        frame.origin.y = self.view.frame.size.height-frame.size.height
        self.bottomView.frame = frame
        
        frame = self.chatTable.frame
        frame.origin.y = 0
        self.chatTable.frame = frame
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let originalDefault = ""
        let thumbnailDefault = ""
        let imageInfo = ["original": originalDefault, "thumb": thumbnailDefault]
        self.postMessageDict(self.preparePostInfo(imageInfo))
        
        return true
    }
    
    //MARK: - TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = self.posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CTChatTableViewCell.cellId, forIndexPath: indexPath) as! CTChatTableViewCell
        cell.messageLabel.text = post.message
        cell.dateLabel.text = post.formattedDate
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CTChatTableViewCell.defaultHeight
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.messageField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
