//
//  ProfileTweetCell.swift
//  Twitter
//
//  Created by ruthie_berman on 10/5/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class ProfileTweetCell: UITableViewCell {

  @IBOutlet weak var retweetedIcon: UIImageView!
  @IBOutlet weak var retweetedLabel: UILabel!

  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!

  @IBOutlet weak var replyIcon: UIImageView!
  @IBOutlet weak var retweetIcon: UIImageView!
  @IBOutlet weak var favoriteIcon: UIImageView!

  var tweet: Tweet? {
    didSet {
      nameLabel.text = tweet?.user?.name ?? "Anonymous"
      usernameLabel.text = ("@" + (tweet?.user?.username!)!)
      tweetTextLabel.text = tweet?.text

      // Profile image
      let profileImageUrl = tweet?.user?.profileImageUrl
      profileImage.setImageWith(profileImageUrl!)

      // 'Retweeted from' section (at the top of the tweet)
      if (tweet?.wasRetweeted)! {
        retweetedLabel.text = tweet?.retweetedFromUsername
        retweetedIcon.isHidden = false
        retweetedLabel.isHidden = false
      } else {
        retweetedIcon.isHidden = true
        retweetedLabel.isHidden = true
      }

      // Timestamp
      let timestamp = tweet?.timestamp
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      timestampLabel.text = formatter.string(from: timestamp!)

      // Icons
      retweetedIcon.image = UIImage(named: "retweet-icon")

      // Reply Icon
      replyIcon.image = UIImage(named: "reply-icon")
      replyIcon.highlightedImage = UIImage(named: "reply-icon-highlighted")
      replyIcon.isHighlighted = tweet?.replied ?? false

      // Retweet Icon
      retweetIcon.image = UIImage(named: "retweet-icon")
      retweetIcon.highlightedImage = UIImage(named: "retweet-icon-highlighted")
      retweetIcon.isHighlighted = tweet?.retweeted ?? false

      // Favorite Icon
      favoriteIcon.image = UIImage(named: "favorite-icon")
      favoriteIcon.highlightedImage = UIImage(named: "favorite-icon-highlighted")
      favoriteIcon.isHighlighted = tweet?.favorited ?? false
    }
  }


  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
}
