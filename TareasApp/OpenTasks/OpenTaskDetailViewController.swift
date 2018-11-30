//
//  OpenTaskDetailViewController.swift
//  TareasApp
//
//  Created by Trèvier Gittens on 30/11/2018.
//  Copyright © 2018 Gindora Global. All rights reserved.
//

import UIKit

class OpenTaskDetailViewController: UIViewController {
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var lbl_taskTitle: UILabel!
    @IBOutlet weak var lbl_taskDesc: UITextView!
    @IBOutlet weak var lbl_taskDeadline: UILabel!
    @IBOutlet weak var btn_Enroll: UIButton!
    @IBOutlet weak var ai_loading: UIActivityIndicatorView!
    var task = OpenTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ai_loading.isHidden = true
        
        lbl_taskTitle.text = task.title
        lbl_taskDesc.text = task.taskdescription
    }
    
    @IBAction func btn_Enroll(_ sender: Any) {
        self.btn_Enroll.setImage(UIImage(named: "BtnSignInEmpty"), for: .normal)
        self.ai_loading.isHidden = false
        self.ai_loading.startAnimating()
    }
    
}
