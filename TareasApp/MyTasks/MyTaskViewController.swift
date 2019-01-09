//
//  MyTaskViewController.swift
//  TareasApp
//
//  Created by Trèvier Gittens on 09/01/2019.
//  Copyright © 2019 Gindora Global. All rights reserved.
//

import UIKit
import Firebase

class MyTaskViewController: UIViewController {
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var lbl_taskTitle: UILabel!
    @IBOutlet weak var lbl_taskDesc: UITextView!
    @IBOutlet weak var lbl_taskDeadline: UILabel!
    @IBOutlet weak var btn_Complete: UIButton!
    @IBOutlet weak var ai_loading: UIActivityIndicatorView!
    let defaults = UserDefaults.standard
    var task = OpenTask()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ai_loading.isHidden = true
        
        lbl_taskTitle.text = task.title
        lbl_taskDesc.text = task.taskdescription
        
        
        if task.completed
        {
            self.btn_Complete.isHidden = true
        }
        else
        {
            self.btn_Complete.isHidden = false
        }
    }
    
    
    
    @IBAction func btn_Complete(_ sender: Any) {
        self.btn_Complete.setImage(UIImage(named: "BtnSignInEmpty"), for: .normal)
        self.ai_loading.isHidden = false
        self.ai_loading.startAnimating()
        
        //Complete task in DB
        let clubname = self.defaults.string(forKey: "club")!
        
        let taskRef =  (Constants.baseDB).collection("clubs").document(clubname).collection("planning").document(task.documentID)
        
        // Set the "capital" field of the city 'DC'
        taskRef.updateData([
            "completed": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                self.alertMessageOk(title: "Error!", message: "Er is iets misgegaan \(self.task.title)")
            } else {
                print("Document successfully updated")
                self.alertMessageOk(title: "Bedankt!", message: "Voor het voltooien van de taak \(self.task.title)")
                
                _ = self.navigationController?.popViewController(animated: true)
            }
        }


    }
    
    
    
    func alertMessageOke(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
