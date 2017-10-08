//
//  ClearCell.swift
//  Twitter
//
//  Created by ruthie_berman on 10/7/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class ClearCell: UITableViewCell {


  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = UITableViewCellSelectionStyle.none
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
