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
    let defaults = UserDefaults.standard
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let dateString = dateFormatter.string(from: task.Deadline)
        
        //assigning task to user
        let clubname = self.defaults.string(forKey: "club")!
        
        let batch = (Constants.baseDB).batch()
        let reff =  (Constants.baseDB).collection("clubs").document(clubname).collection("planning").document(dateString)
        batch.setData([
            "task": [
                "title": task.title,
                "taskdescription": task.taskdescription,
                "assigned": true,
                "minpeopleneeded": task.minpeopleneeded,
                "Deadline": task.Deadline
                
            ],
            "deadline": task.Deadline,
            "membersperformingtask": [
                "email": self.defaults.string(forKey: "email")!,
                "first_name": self.defaults.string(forKey: "first_name")!,
                "last_name": self.defaults.string(forKey: "last_name")!,
                "role": self.defaults.string(forKey: "role")!,
            ],
            "membersperforming": [self.defaults.string(forKey: "email")!],
            "completed": false
            
            ], forDocument: reff)
           
            
        let updateRef =  (Constants.baseDB).collection("clubs").document(clubname).collection("tasks").document(self.task.title)
        batch.updateData(["assigned": true ], forDocument: updateRef)
        
            
        batch.commit() { err in
            if let err = err {
                    print("Error writing batch \(err)")
                    self.alertMessageOk(title: "Error", message: err.localizedDescription)
                } else {
                    print("Batch write succeeded.")
                    self.alertMessageOk(title: "Success", message: "U bent successvol ingeschreven")
                
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }

    }
    
}
