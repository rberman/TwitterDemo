//
//  TweetsViewController.swift
//  Twitter
//
//  Created by ruthie_berman on 9/27/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!

  var tweets: [Tweet]?
  var showMentions: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)

    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100.0

    if showMentions {
      TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
        self.tweets = tweets
        self.tableView.reloadData()
      }, failure: { (error: Error) in
        print("Error: \(error.localizedDescription)")
      })
      print("showMentions")
    } else {
      TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
        self.tweets = tweets
        self.tableView.reloadData()
      }, failure: { (error: Error) in
        print("Error: \(error.localizedDescription)")
      })
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let tweet = tweets?[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
    cell.tweet = tweet
    cell.pushProfilePage = {(tappedUser: User) -> Void in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
      profileViewController.user = tappedUser
      self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    return cell
  }

  @IBAction func onLogoutButton(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
  }

  func refreshControlAction(_ refreshControl: UIRefreshControl) {
    TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
      self.tweets = tweets
    }, failure: { (error: Error) in
      print("Error: \(error.localizedDescription)")
    })
    tableView.reloadData()
    refreshControl.endRefreshing()
  }

  func resetTweet(indexPath: IndexPath, newTweet: Tweet) {
    if let cell = tableView.cellForRow(at: indexPath) {
      tweets?[indexPath.row] = newTweet
      (cell as! TweetCell).tweet = newTweet
    }
  }

  func pushNewTweet(newTweet: Tweet) {
    tweets?.insert(newTweet, at: 0)
    tableView.reloadData()
  }

   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
    if segue.identifier == "TweetDetailsSegue" {
      let cell = sender as! TweetCell
      let indexPath = tableView.indexPath(for: cell)
      let tweet = tweets?[indexPath!.row]

      let tweetViewController = segue.destination as! TweetViewController
      tweetViewController.tweet = tweet
      tweetViewController.tweetChangedHandler = {(newTweet: Tweet) -> Void in
        self.resetTweet(indexPath: indexPath!, newTweet: newTweet)
      }
    }
    if segue.identifier == "NewTweetSegue" {
      let navController = segue.destination as! UINavigationController
      let newTweetViewController = navController.topViewController as! NewTweetViewController
      newTweetViewController.tweetPostedHandler = {(newTweet: Tweet) -> Void in
        self.pushNewTweet(newTweet: newTweet)
      }
    }
  }
}
