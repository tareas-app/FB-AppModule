//
//  TabbarViewController.swift
//  TareasApp
//
//  Created by Trèvier Gittens on 30/11/2018.
//  Copyright © 2018 Gindora Global. All rights reserved.
//

import Hue
import UIKit

class TabbarViewController: UITabBarController {
    @IBOutlet var buttonView: UIView!
    @IBOutlet weak var btn_openTasks: UIButton!
    @IBOutlet weak var btn_myTasks: UIButton!
    @IBOutlet weak var btn_profile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonView.frame.size.width = self.view.frame.width - 20
        buttonView.frame.origin.x = 10
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                print("iPhone X, Xs")
                buttonView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.height - buttonView.frame.height - 12.5 - 30
            case 2688:
                print("iPhone Xs Max")
                buttonView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.height - buttonView.frame.height - 12.5 - 30
            case 1792:
                print("iPhone Xr")
                 buttonView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.height - buttonView.frame.height - 12.5 - 30
            default:
                buttonView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.height - buttonView.frame.height - 12.5
            }
        }
        
        buttonView.layer.cornerRadius = 15
        
        buttonView.layer.borderWidth = 1
        let gray = UIColor(hex: "#aaaacc")
        buttonView.layer.borderColor = gray.alpha(0.5).cgColor
        
        self.view.addSubview(buttonView)
    }
    
    @IBAction func changeTab(sender: UIButton) {
        self.selectedIndex = sender.tag
        
        switch sender.tag {
        case 0:
            btn_openTasks.setImage(UIImage(named: "OpenTasksB"), for: .normal)
            btn_myTasks.setImage(UIImage(named: "MyTasksG"), for: .normal)
            btn_profile.setImage(UIImage(named: "ProfileG"), for: .normal)
        case 1:
            btn_openTasks.setImage(UIImage(named: "OpenTasksG"), for: .normal)
            btn_myTasks.setImage(UIImage(named: "MyTasksB"), for: .normal)
            btn_profile.setImage(UIImage(named: "ProfileG"), for: .normal)
        case 2:
            btn_openTasks.setImage(UIImage(named: "OpenTasksG"), for: .normal)
            btn_myTasks.setImage(UIImage(named: "MyTasksG"), for: .normal)
            btn_profile.setImage(UIImage(named: "ProfileB"), for: .normal)
        default:
            btn_openTasks.setImage(UIImage(named: "OpenTasksG"), for: .normal)
            btn_myTasks.setImage(UIImage(named: "MyTasksG"), for: .normal)
            btn_profile.setImage(UIImage(named: "ProfileG"), for: .normal)
        }
    }
}
