//
//  ProfileHeaderCell.swift
//  Twitter
//
//  Created by ruthie_berman on 10/5/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var numTweetsLabel: UILabel!
  @IBOutlet weak var numFollowingLabel: UILabel!
  @IBOutlet weak var numFollowersLabel: UILabel!

  var user: User = User.currentUser! {
    didSet {
      setAttributes()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyle.none
    setAttributes()
  }

  func setAttributes() {
    nameLabel.text = user.name
    usernameLabel.text = user.username
    numTweetsLabel.text = "\(user.tweetsCount!)"
    numFollowingLabel.text = "\(user.followingCount!)"
    numFollowersLabel.text = "\(user.followersCount!)"
    let profileImageUrl = user.profileImageUrl
    profileImage.layer.cornerRadius = 8.0
    profileImage.setImageWith(profileImageUrl!)
    profileImage.clipsToBounds = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
