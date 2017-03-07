//
//  TableViewCell.swift
//  pset4 sem sturkenboom
//
//  Created by Sem Sturkenboom on 07-03-17.
//  Copyright © 2017 Sem Sturkenboom. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var toDo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
