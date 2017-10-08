//
//  TweetViewController.swift
//  Twitter
//
//  Created by ruthie_berman on 9/29/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

  @IBOutlet weak var retweetedIcon: UIImageView!
  @IBOutlet weak var retweetedLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  @IBOutlet weak var replyIcon: UIImageView!
  @IBOutlet weak var retweetIcon: UIImageView!
  @IBOutlet weak var favoriteIcon: UIImageView!


  var tweet: Tweet?
  var tweetChangedHandler: ((Tweet) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.navigationItem.hidesBackButton = true
    nameLabel.text = tweet?.user?.name ?? "Anonymous"
    usernameLabel.text = ("@" + (tweet?.user?.username!)!)
    tweetTextLabel.text = tweet?.text
    retweetCountLabel.text = String((tweet?.retweetCount)!)
    favoriteCountLabel.text = String((tweet?.favoritesCount)!)


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
    replyIcon.isUserInteractionEnabled = true
    let replyIconTap = UITapGestureRecognizer(target: self, action: #selector(replyIconTapped))
    replyIcon.addGestureRecognizer(replyIconTap)

      // Retweet Icon
    retweetIcon.image = UIImage(named: "retweet-icon")
    retweetIcon.highlightedImage = UIImage(named: "retweet-icon-highlighted")
    retweetIcon.isHighlighted = tweet?.retweeted ?? false
    retweetIcon.isUserInteractionEnabled = true
    let retweetIconTap = UITapGestureRecognizer(target: self, action: #selector(retweetIconTapped))
    retweetIcon.addGestureRecognizer(retweetIconTap)

      // Favorite Icon
    favoriteIcon.image = UIImage(named: "favorite-icon")
    favoriteIcon.highlightedImage = UIImage(named: "favorite-icon-highlighted")
    favoriteIcon.isHighlighted = tweet?.favorited ?? false
    favoriteIcon.isUserInteractionEnabled = true
    let favoriteIconTap = UITapGestureRecognizer(target: self, action: #selector(favoriteIconTapped))
    favoriteIcon.addGestureRecognizer(favoriteIconTap)
  }

  func replyIconTapped(sender: UITapGestureRecognizer) {
    let navController = UIStoryboard(name:"Main", bundle: nil)
      .instantiateViewController(withIdentifier: "NewTweetViewController") as! UINavigationController
    let newTweetVC = navController.topViewController as! NewTweetViewController
    newTweetVC.isReply = true
    newTweetVC.replyToId = tweet?.id
    newTweetVC.replyToUsername = tweet?.user?.username
    newTweetVC.tweetPostedHandler = {(newTweet: Tweet) -> Void in
      self.tweet = newTweet
    }
    self.navigationController?.present(navController, animated: true, completion: nil)
  }

  func retweetIconTapped(sender: UITapGestureRecognizer) {
    if !retweetIcon.isHighlighted {
      TwitterClient.sharedInstance?.retweet(tweetId: (tweet?.id)!, success:
        { (newTweet: Tweet) in
          self.tweet = newTweet
          self.tweet?.retweetCount += 1

      }, failure: { (error: Error) in
        self.createAlert(title: "Retweet failed", error: error)
      })
    } else {
      TwitterClient.sharedInstance?.unretweet(tweetId: (tweet?.id)!, success:
        { (newTweet: Tweet) in
          self.tweet = newTweet
          self.tweet?.retweetCount -= 1
      }, failure: { (error: Error) in
        self.createAlert(title: "Unretweet failed", error: error)
      })
    }
    retweetIcon.isHighlighted = tweet?.retweeted ?? false
  }

  func favoriteIconTapped(sender: UITapGestureRecognizer)  {
    if !favoriteIcon.isHighlighted {
      TwitterClient.sharedInstance?.favorited(tweetId: (tweet?.id)!, success:
        { (newTweet: Tweet) in
          self.tweet = newTweet
          self.tweet?.favoritesCount += 1
      }, failure: { (error: Error) in
        self.createAlert(title: "Favorite failed", error: error)
      })
    } else {
      TwitterClient.sharedInstance?.unfavorited(tweetId: (tweet?.id)!, success:
        { (newTweet: Tweet) in
          self.tweet = newTweet
          self.tweet?.favoritesCount -= 1
      }, failure: { (error: Error) in
        self.createAlert(title: "Unfavorite failed", error: error)
      })
    }
    favoriteIcon.isHighlighted = tweet?.favorited ?? false
  }

  func createAlert(title: String, error: Error) {
    let alertController = UIAlertController(title: title, message: "Something went wrong. \n\(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func backButtonTapped(_ sender: Any) {
    tweetChangedHandler?(self.tweet!)
    self.navigationController?.popViewController(animated: true)
  }

   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "replyButtonSegue" {
      let navController = segue.destination as! UINavigationController
      let newTweetVC = navController.topViewController as! NewTweetViewController

      newTweetVC.isReply = true
      newTweetVC.replyToId = tweet?.id
      newTweetVC.replyToUsername = tweet?.user?.username
    }

   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }


}
