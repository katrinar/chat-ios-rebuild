//
//  CTPost.swift
//  chat-ios
//
//  Created by Brian Correa on 7/10/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit

class CTPost: NSObject {

    var id: String!
    var message: String!
    var from: Dictionary<String, AnyObject>!
    var timestamp: NSDate!
    var formattedDate: String!
    var place: Dictionary<String,AnyObject>!
    
    //Images:
    var image: Dictionary<String,AnyObject>!
    var thumbnailUrl: String!
    var thumbnailData: UIImage?
    var imageUrl: String!
    var imageData: UIImage?
    var isFetching = false
    
    func populate(postInfo: Dictionary<String, AnyObject!>){
        let keys = ["message", "place", "from"]
        for key in keys {
            self.setValue(postInfo[key], forKey: key)
        }
        
        //Image Strings:
        if let _image = postInfo["image"] as? Dictionary<String, AnyObject>{
            if let _original = _image["original"] as? String {
                self.imageUrl = _original
            }
            
            if let _thumb = _image["thumb"] as? String {
                self.thumbnailUrl = _thumb
            }
        } 
        
        if let _timestamp = postInfo["timestamp"] as? String {
            
            let ts = NSTimeInterval(_timestamp)
            self.timestamp = NSDate(timeIntervalSince1970: ts!)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy" // "May 16, 2015"
            self.formattedDate = dateFormatter.stringFromDate(self.timestamp)
        }
    }
}