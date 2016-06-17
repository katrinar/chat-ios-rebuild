//
//  CTAccountViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/10/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit

class CTAccountViewController: CTViewController {
    
    var loginButtons = Array<UIButton>()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Account"
        self.tabBarItem.image = UIImage(named: "profile_icon")
    }
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .blueColor()
    
        let padding = CGFloat(20)
        let width = frame.size.width-2*padding
        let height = CGFloat(44)
        let bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        let whiteColor = UIColor.whiteColor().CGColor
        let font = UIFont(name: "Heiti SC", size: 18)
        var y = CGFloat(120)
        
        let buttonTitles = ["Sign Up", "Login"]
        for btnTitle in buttonTitles {
            let btn = UIButton(frame: CGRect(x: padding, y: y, width: width, height: height))
            btn.setTitle(btnTitle, forState: .Normal)
            btn.backgroundColor = bgColor
            btn.layer.borderColor = whiteColor
            btn.layer.borderWidth = 2
            btn.layer.cornerRadius = 22
            btn.titleLabel?.font = font
            
            btn.addTarget(self, action: #selector(CTAccountViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
            self.loginButtons.append(btn)
            view.addSubview(btn)
            
            y += height+padding
        }
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func buttonTapped(btn: UIButton){
        let buttonTitle = btn.titleLabel?.text?.lowercaseString
        print("buttonTapped: \(buttonTitle!)")
    
        if (buttonTitle == "sign up"){
            let registerVc = CTRegisterViewController()
            self.navigationController?.pushViewController(registerVc, animated: true)
    }
    
        if (buttonTitle == "login"){
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
