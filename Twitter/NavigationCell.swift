//
//  NavigationCell.swift
//  Twitter
//
//  Created by ruthie_berman on 10/6/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class NavigationCell: UITableViewCell {

  @IBOutlet weak var label: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
