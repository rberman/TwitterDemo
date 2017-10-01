//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by ruthie_berman on 9/30/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var tweetText: UITextView!
  @IBOutlet weak var countdownLabel: UILabel!

  var isReply: Bool = false
  var replyToId: Int?
  var replyToUsername: String?
  var tweetPostedHandler: ((Tweet) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()

    tweetText.delegate = self

    nameLabel.text = User.currentUser?.name
    usernameLabel.text = User.currentUser?.username
    let profileImageUrl = User.currentUser?.profileImageUrl
    profileImage.setImageWith(profileImageUrl!)
    if isReply && (replyToUsername != nil) && (replyToId != nil) {
      tweetText.text = "@\(replyToUsername!): "
      let charsRemaining = 140 - tweetText.text.characters.count
      countdownLabel.text = String(describing: charsRemaining)
    } else {
      isReply = false
    }
  }

  func textViewDidChange(_ textView: UITextView) {
    let charsRemaining = 140 - textView.text.characters.count
    countdownLabel.text = String(describing: charsRemaining)

    if charsRemaining <= 0 {
      textView.backgroundColor = UIColor.red
    }
  }

  @IBAction func tweetButtonTapped(_ sender: Any) {
    print("tweetbuttontapped")
    if isReply {
      TwitterClient.sharedInstance?.reply(status: tweetText.text, replyToTweet: replyToId!, success: { (newTweet: Tweet) in
        self.tweetPostedHandler?(newTweet)
        self.dismiss(animated: true, completion: nil)
      }, failure: { (error: Error) in
        let alertController = UIAlertController(title: "Tweet Failed", message: "Something went wrong. \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
      })
    }
    else if (tweetText.text != "") && (tweetText.text != nil) {
      TwitterClient.sharedInstance?.newTweet(status: tweetText.text, success: { (newTweet: Tweet) in
        self.tweetPostedHandler?(newTweet)
        self.dismiss(animated: true, completion: nil)
      }, failure: { (error: Error) in
        let alertController = UIAlertController(title: "Tweet Failed", message: "Something went wrong. \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
      })
    }


  }

  @IBAction func cancelButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */

}
