//
//  CTCreatePlaceViewController.swift
//  chat-ios
//
//  Created by Brian Correa on 6/30/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit

class CTCreatePlaceViewController: UIViewController {

    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        
        view.backgroundColor = UIColor.lightGrayColor()
    
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
