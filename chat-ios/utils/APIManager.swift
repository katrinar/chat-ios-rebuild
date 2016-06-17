//
//  APIManager.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/15/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {
    
    static func getRequest(path:String, params:Dictionary<String, AnyObject>?, completion:((results: Dictionary<String, AnyObject>) -> Void)?) {
        
        let url = "http://localhost:3000/api/place"
        
        
        Alamofire.request(.GET, url, parameters: params).responseJSON { response in
            if let json = response.result.value as? Dictionary<String, AnyObject>{
                if (completion != nil){
                    completion!(results: json)
                }
            }
        }
    }

}
