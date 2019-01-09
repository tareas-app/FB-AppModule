//
//  ProfileViewController.swift
//  TareasApp
//
//  Created by Trèvier Gittens on 30/11/2018.
//  Copyright © 2018 Gindora Global. All rights reserved.
//

import UIKit
import Firebase
//goBackToLogin
class ProfileViewController: UIViewController {
    @IBOutlet weak var lbl_name: UILabel!
        @IBOutlet weak var lbl_contactInformation: UILabel!
    @IBOutlet weak var lbl_contactEmail: UILabel!
    @IBOutlet weak var lbl_contactTel: UILabel!
    @IBOutlet weak var lbl_contactStreetAndNum: UILabel!
    @IBOutlet weak var lbl_contactZipAndCity: UILabel!
    @IBOutlet weak var lbl_contactCountry: UILabel!
        @IBOutlet weak var lbl_accountInformation: UILabel!
        @IBOutlet weak var lbl_firstnameT: UILabel!
    @IBOutlet weak var lbl_firstname: UILabel!
        @IBOutlet weak var lbl_lastnameT: UILabel!
    @IBOutlet weak var lbl_lastname: UILabel!
        @IBOutlet weak var lbl_dateofbirthT: UILabel!
    @IBOutlet weak var lbl_dateofbirth: UILabel!
        @IBOutlet weak var lbl_emailT: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
        @IBOutlet weak var lbl_roleT: UILabel!
    @IBOutlet weak var lbl_role: UILabel!
    
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }
    
    func getData(){
        //get club information
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if Auth.auth().currentUser != nil { //checks if a user is signed in
            let clubname = self.defaults.string(forKey: "club")!
            print("club: \(clubname)")
            
            let ref = (Constants.baseDB).collection("clubs").document(clubname)
            
            ref.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    self.lbl_name.text = clubname
                    self.lbl_contactEmail.text = (document["clubemail"] as! String)
                    self.lbl_contactTel.text = (document["clubphonenumber"] as! String)
                    self.lbl_contactStreetAndNum.text = (document["clubaddress"] as! String)
                    self.lbl_contactZipAndCity.text = (document["clubpostalcode"] as! String) + ", " + (document["clubcity"] as! String)
                    self.lbl_contactCountry.isHidden = true
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                } else {
                    print("Document does not exist")
                }
            }
            
            self.lbl_firstname.text = defaults.string(forKey: "first_name");
            self.lbl_lastname.text = defaults.string(forKey: "last_name");
            self.lbl_dateofbirth.text = defaults.string(forKey: "date_of_birth");
            self.lbl_email.text = defaults.string(forKey: "email");
            self.lbl_role.text = defaults.string(forKey: "role");

        } else {
            alertMessageOke(title: "Error", message: "You need to be logged in to perform this action!")
        }
    }
    
    
    @IBAction func btn_logout(_ sender: Any) {
        let alert = UIAlertController(title: "Uitloggen", message: "Weet u zeker dat u wilt uitloggen?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Uitloggen", style: .default, handler: { (alert) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.performSegue(withIdentifier: "goBackToLogin", sender: self)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    func alertMessageOke(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
