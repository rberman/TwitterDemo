//
//  ProfileViewController.swift
//  Twitter
//
//  Created by ruthie_berman on 10/5/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var headerImage: UIImageView!
  @IBOutlet weak var profileView: UIView!

  var user: User = User.currentUser!

  private var tweets = [Tweet]()
  private var tableViewOriginalTopConstraint: CGFloat?
  private let tableViewMaxHeight: CGFloat = 100.0
  private var tableViewMinHeight: CGFloat = 0.0

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    UITableView.appearance().backgroundColor = UIColor.clear

    TwitterClient.sharedInstance?.userTimeline(userId: user.id!, success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print("Error: \(error.localizedDescription)")
    })
    
    let headerImageUrl = user.backgroundImageUrl
    headerImage.setImageWith(headerImageUrl!)

    if User.currentUser == user {
      let logoutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(onLogoutButton))
      self.navigationItem.setLeftBarButton(logoutButton, animated: true)
      self.navigationController?.navigationBar.tintColor = UIColor.white;
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count + 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
      cell.user = user
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTweetCell", for: indexPath) as! ProfileTweetCell
      cell.tweet = tweets[indexPath.row - 1]
      return cell
    }
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundView?.backgroundColor = UIColor.clear
    cell.backgroundColor = UIColor.clear
  }

//  @IBAction func onProfileViewPanGesture(_ panGesture: UIPanGestureRecognizer) {
//    if panGesture.state == .began {
//      tableViewOriginalTopConstraint = tableViewTopConstraint.constant
//    } else if panGesture.state == .changed {
//      var y = tableViewOriginalTopConstraint! + panGesture.translation(in: self.view).y
//      if y > tableViewMaxHeight {
//        y = tableViewMaxHeight
//      } else if y < tableViewMinHeight {
//        y = tableViewMinHeight
//      }
//      tableViewTopConstraint.constant = y
//    } else if panGesture.state == .ended {
//
//    }
//  }

  @IBAction func onLogoutButton(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
    // TODO: Redirect to home?
  }

   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ProfileNewTweetSegue" {
      let navController = segue.destination as! UINavigationController
      let newTweetViewController = navController.topViewController as! NewTweetViewController
      newTweetViewController.tweetPostedHandler = {(newTweet: Tweet) -> Void in
//        self.pushNewTweet(newTweet: newTweet)
      }
    }


   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }


}
