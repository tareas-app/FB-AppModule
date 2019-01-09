//
//  ViewController.swift
//  TareasApp
//
//  Created by Trèvier Gittens on 09/11/2018.
//  Copyright © 2018 Gindora Global. All rights reserved.
//

import UIKit
import McPicker
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_club: UITextField!
    @IBOutlet weak var ai_loading: UIActivityIndicatorView!
    @IBOutlet weak var btn_login: UIButton!
    let defaults = UserDefaults.standard
    var clubNames = [String]()
    var clubname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ai_loading.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func unwindToLogIn(segue: UIStoryboardSegue){}
    
    override func viewWillAppear(_ animated: Bool) {
        getClubNames()
        
//        LOGOUT FUNCTION
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            self.performSegue(withIdentifier: "goToHome", sender: self)
        } 
    }
    
    func getClubNames()
    {
        (Constants.baseDB).collection("clubs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    self.clubNames.append(document.documentID)
                }
            }
        }

    }
    
    @IBAction func btn_clubSelecter(_ sender: Any) {
        McPicker.show(data: [self.clubNames]) {  [weak self] (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print(name)
                self?.tf_club.text = name
                self?.clubname = name
            }
        }
    }
    
    @IBAction func clubSelecter(_ sender: Any) {
        view.resignFirstResponder()
        McPicker.show(data: [self.clubNames]) {  [weak self] (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print(name)
                self?.tf_club.text = name
            }
        }
    }
    
    @IBAction func btn_login(_ sender: Any) {
        
        
        if (tf_email.text?.isEmpty)! || (tf_password.text?.isEmpty)! || clubname.isEmpty
        {
            let alert = UIAlertController(title: "Oeps", message: "Vul alle velden in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if !(isValidEmail(testStr: tf_email.text!)) {
            let alert = UIAlertController(title: "Oeps", message: "Dit is geen geldig email adres", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        
        self.ai_loading.isHidden = false
        self.ai_loading.startAnimating()
        
        
        Auth.auth().signIn(withEmail: tf_email.text!, password: self.md5(self.tf_password.text!)) { (user, error) in
            if error == nil {
                
                print("You have successfully logged in")
                
                self.ai_loading.stopAnimating()
                self.ai_loading.isHidden = true
                
                self.getUserData(email: self.tf_email.text!.lowercased())

                
            } else {
                
                
                let alert = UIAlertController(title: "Error", message: (error?.localizedDescription)!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                self.ai_loading.stopAnimating()
                self.ai_loading.isHidden = true
            }
        }
        
    }
    
    func getUserData(email: String) {
        (Constants.baseDB).collection("clubs").document(self.clubname).collection("members").whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        self.defaults.set(document.data()["role"], forKey: "role")
                        self.defaults.set(document.data()["date_of_birth"], forKey: "date_of_birth")
                        self.defaults.set(document.data()["email"], forKey: "email")
                        self.defaults.set(document.data()["first_name"], forKey: "first_name")
                        self.defaults.set(document.data()["last_name"], forKey: "last_name")
                        self.defaults.set(document.data()["club"], forKey: "club")
                        self.defaults.set(document.data()["password"], forKey: "password")
                    }
                    
                    if querySnapshot!.documents.count > 0
                    {
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        
                        //empty textfields:
                        self.tf_club.text = ""
                        self.tf_email.text = ""
                        self.tf_password.text = ""
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Error", message: "Error getting user information", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    
                }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func md5(_ string: String) -> String {
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
    
    @objc func hideKeyboard()
    {
        view.endEditing(true)
        view.resignFirstResponder()
    }
}

