//
//  TableViewCell.swift
//  ClearSky
//
//  Created by Sihem on 07/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
 
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
