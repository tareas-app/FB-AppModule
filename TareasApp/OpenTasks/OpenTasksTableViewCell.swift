//
//  OpenTasksTableViewCell.swift
//  TareasApp
//
//  Created by Trèvier Gittens on 30/11/2018.
//  Copyright © 2018 Gindora Global. All rights reserved.
//

import UIKit

class OpenTasksTableViewCell: UITableViewCell {
    @IBOutlet weak var cellBGView: UIView!
    @IBOutlet weak var lbl_taskTitle: UILabel!
    @IBOutlet weak var lbl_taskDesc: UITextView!
    @IBOutlet weak var lbl_taskDeadline: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellBGView.backgroundColor = UIColor.white
        cellBGView.layer.cornerRadius = 10
        
        
        cellBGView.layer.borderWidth = 1
        let gray = UIColor(hex: "#F7F7F7")
        cellBGView.layer.borderColor = gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
