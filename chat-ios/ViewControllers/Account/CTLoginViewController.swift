//
//  CTLoginViewController.swift
//  chat-ios
//
//  Created by Brian Correa on 6/22/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit

class CTLoginViewController: CTViewController, UITextFieldDelegate {
    
    var textFields = Array<UITextField>()
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.grayColor()
        
        let padding = CGFloat(Constants.padding)
        let width = frame.size.width-2*padding
        let height = CGFloat(32)
        var y = CGFloat(Constants.origin_y)
        
        let fieldNames = ["Email", "Password"]
        
        for fieldName in fieldNames {
            
            let field = CTTextField(frame: CGRect(x: padding, y: y, width: width, height: height))
            field.delegate = self
            field.placeholder = fieldName
            let isPassword = (fieldName == "Password")
            field.secureTextEntry = isPassword
            field.returnKeyType = isPassword ? .Join : .Next
            
            view.addSubview(field)
            self.textFields.append(field)
            y += height+padding
        }
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }

}
