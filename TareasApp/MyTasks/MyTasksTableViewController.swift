//
//  MyTasksTableViewController.swift
//  TareasApp
//
//  Created by Trèvier Gittens on 30/11/2018.
//  Copyright © 2018 Gindora Global. All rights reserved.
//

import UIKit
import Firebase

class MyTasksTableViewController: UITableViewController {

    let defaults = UserDefaults.standard
    var MyTasks = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(hex: "#FAFAFA")
        self.tableView.separatorColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    // MARK: - Data retrieval and parsing
    
    func getData()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if Auth.auth().currentUser != nil { //checks if a user is signed in
            let clubname = self.defaults.string(forKey: "club")!
            print("club: \(clubname)")
            
            (Constants.baseDB).collection("clubs").document(clubname).collection("planning").whereField("membersperforming", arrayContains: self.defaults.string(forKey: "email")!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        self.MyTasks.removeAllObjects()
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let task = OpenTask()
                            let taskDoc = document.data()["task"] as! [String : Any]

                            
                            task.title = taskDoc["title"] as! String
                            task.taskdescription = taskDoc["taskdescription"] as! String
                            task.minpeopleneeded = taskDoc["minpeopleneeded"] as! Int
                            task.assigned = taskDoc["assigned"] as! Bool
                            
                            let deadline:Timestamp = taskDoc["deadline"] as? Timestamp ?? Timestamp()
                            task.Deadline = deadline.dateValue()
                            task.completed =  document.data()["completed"] as! Bool
                            task.documentID = document.documentID
                            
                            self.MyTasks.add(task)
                        }
                        
                        DispatchQueue.main.async() {
                            self.tableView.reloadData()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            if self.MyTasks.count == 0
                            {
                                let footerView = UIView()
                                let screenSize = UIScreen.main.bounds
                                let screenWidth = screenSize.width
                                let screenHeight = screenSize.height
                                let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth-10, height: 21))
                                label.center = CGPoint(x: screenWidth/2, y: screenHeight/3)
                                label.textAlignment = .center
                                label.font = UIFont(name: "HelveticaNeue", size: CGFloat(20))
                                label.text = "Momenteel heeft u geen taken staan"
                                footerView.addSubview(label)
                                
                                self.tableView.tableFooterView = footerView
                            }
                            else
                            {
                                self.tableView.tableFooterView = UIView()
                            }
                        }
                    }
            }
        } else {
            alertMessageOke(title: "Error", message: "You need to be logged in to perform this action!")
        }
    }
    
    
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MyTasks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTaskCell", for: indexPath) as! OpenTasksTableViewCell
        
        let row:OpenTask = self.MyTasks[indexPath.row] as! OpenTask
        cell.lbl_taskTitle.text = row.title
        cell.lbl_taskDesc.text = row.taskdescription
        
        return cell
    }
    
    
    // MARK: - Navigation

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let DestViewController = segue.destination as! MyTaskViewController
            DestViewController.task = self.MyTasks[selectedRow]  as! OpenTask
        }
    }

    func alertMessageOke(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
