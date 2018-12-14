//
//  OpenTasksTableViewController.swift
//  TareasApp
//
//  Created by Trèvier Gittens on 30/11/2018.
//  Copyright © 2018 Gindora Global. All rights reserved.
//

import UIKit
import Firebase

class OpenTasksTableViewController: UITableViewController {

    let defaults = UserDefaults.standard
    var OpenTasks = NSMutableArray()
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
            
            (Constants.baseDB).collection("clubs").document(clubname).collection("tasks").whereField("assigned", isEqualTo: false)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        self.OpenTasks.removeAllObjects()
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let task = OpenTask()
                            task.title = document.data()["title"] as! String
                            task.taskdescription = document.data()["description"] as! String
                            task.minpeopleneeded = document.data()["minpeopleneeded"] as! Int
                            task.assigned = document.data()["assigned"] as! Bool
                            
                            let deadline:Timestamp = document.data()["deadline"] as? Timestamp ?? Timestamp()
                            task.Deadline = deadline.dateValue()
                            
                            self.OpenTasks.add(task)
                        }
                        
                        DispatchQueue.main.async() {
                            self.tableView.reloadData()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            if self.OpenTasks.count == 0
                            {
                                let footerView = UIView()
                                let screenSize = UIScreen.main.bounds
                                let screenWidth = screenSize.width
                                let screenHeight = screenSize.height
                                let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth-10, height: 21))
                                label.center = CGPoint(x: screenWidth/2, y: screenHeight/3)
                                label.textAlignment = .center
                                label.font = UIFont(name: "HelveticaNeue", size: CGFloat(20))
                                label.text = "Momenteel zijn er geen open taken"
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
        return OpenTasks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenTaskCell", for: indexPath) as! OpenTasksTableViewCell
        
        let row:OpenTask = self.OpenTasks[indexPath.row] as! OpenTask
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
            let DestViewController = segue.destination as! OpenTaskDetailViewController
            DestViewController.task = self.OpenTasks[selectedRow]  as! OpenTask
        }
    }

    func alertMessageOke(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
