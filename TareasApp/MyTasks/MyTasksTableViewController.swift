//
//  MyTasksTableViewController.swift
//  TareasApp
//
//  Created by Trèvier Gittens on 30/11/2018.
//  Copyright © 2018 Gindora Global. All rights reserved.
//

import UIKit

class MyTasksTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(hex: "#FAFAFA")
        self.tableView.separatorColor = UIColor.clear
    }
    
//    // MARK: - Data retrieval and parsing
//    
//    func getData()
//    {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        let userID:String = (Auth.auth().currentUser?.uid)!
//        if Auth.auth().currentUser != nil {
//            (variables.baseDB).collection("vehicles").whereField("tribe_userID", isEqualTo: userID)
//                .getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                    } else {
//                        self.MyTrucks.removeAllObjects()
//                        for document in querySnapshot!.documents {
//                            //print("\(document.documentID) => \(document.data())")
//                            let truck = Truck()
//                            truck.Event = document.data()["event"] as! String
//                            truck.TribeUserID = document.data()["tribe_userID"] as! String
//                            truck.vehicle_name = document.data()["vehicle_name"] as! String
//                            truck.vehicle_number = document.data()["vehicle_number"] as? String ?? "-"
//                            
//                            //optional values
//                            truck.vehicleLat = document.data()["tribe_userID"] as? Double ?? 0.0
//                            truck.vehicleLong = document.data()["tribe_userID"] as? Double ?? 0.0
//                            let updated:Timestamp = document.data()["tribe_userID"] as? Timestamp ?? Timestamp()
//                            truck.LastUpdated = updated.dateValue()
//                            truck.BeingSet = document.data()["tribe_userID"] as? Bool ?? false
//                            truck.BeingSetBy = document.data()["tribe_userID"] as? String ?? ""
//                            truck.startedOn = document.data()["tribe_userID"] as? String ?? ""
//                            
//                            self.MyTrucks.add(truck)
//                        }
//                        
//                        DispatchQueue.main.async() {
//                            self.tableView.reloadData()
//                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                            if self.MyTrucks.count == 0
//                            {
//                                let footerView = UIView()
//                                let screenSize = UIScreen.main.bounds
//                                let screenWidth = screenSize.width
//                                let screenHeight = screenSize.height
//                                let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth-10, height: 21))
//                                label.center = CGPoint(x: screenWidth/2, y: screenHeight/3)
//                                label.textAlignment = .center
//                                label.font = UIFont(name: "HelveticaNeue", size: CGFloat(20))
//                                label.text = "You don't have any vehicles yet.. \nPress + to add one!"
//                                footerView.addSubview(label)
//                                
//                                self.tableView.tableFooterView = footerView
//                            }
//                            else
//                            {
//                                self.tableView.tableFooterView = UIView()
//                            }
//                        }
//                    }
//            }
//        } else {
//            alertMessageOk(title: "Error", message: "You need to be logged in to add a vehicle to your tribe!")
//        }
//        
//    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
