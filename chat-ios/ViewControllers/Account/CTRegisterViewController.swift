//
//  CTRegisterViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/10/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit

class CTRegisterViewController: CTViewController {
    
    var textFields = Array<UITextField>()
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.redColor()
        
        let padding = CGFloat(20)
        let width = frame.size.width-2*padding
        let height = CGFloat(32)
        var y = CGFloat(120)
        let font = UIFont(name: "Heiti SC", size: 18)
        
        let fieldNames = ["Username", "Email", "Password"]
        for fieldName in fieldNames {
            
            let field = UITextField(frame: CGRect(x: padding, y: y, width: width, height: height))
            field.placeholder = fieldName
            field.font = font
            field.autocorrectionType = .No
            let isPassword = (fieldName == "Password")
            field.secureTextEntry = (isPassword)
            field.returnKeyType = (isPassword) ? .Join : .Next
            let line = UIView(frame: CGRect(x: 0, y: height-1, width: width, height: 1))
            line.backgroundColor = .whiteColor()
            field.addSubview(line)
            view.addSubview(field)
            self.textFields.append(field)
            y += height+padding
        }
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
