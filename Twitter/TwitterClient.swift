//
//  TwitterClient.swift
//  Twitter
//
//  Created by ruthie_berman on 9/27/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

  static let sharedInstance = TwitterClient(
    baseURL: URL(string: "https://api.twitter.com"),
    consumerKey: "FCTAhrBqWYbYKop2KaZHdaMVc",
    consumerSecret: "so8pD7chRocxtRbiQUEvCf6ovzKhjBHTYx3YuYpnYKF5GUFB87")

  var loginSuccess: (() -> ())?
  var loginFailure: ((Error) -> ())?

  func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    loginSuccess  = success
    loginFailure = failure

    deauthorize()
    fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
      let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
      UIApplication.shared.open(url)
    }, failure: { (error: Error?) in
      print("error: \(String(describing: error?.localizedDescription))")
      self.loginFailure?(error!)
    })
  }

  func logout() {
    User.currentUser = nil
    deauthorize()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
  }

  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success:
      { (accessToken: BDBOAuth1Credential!) in
        self.currentAccount(success: { (user: User) -> () in
          User.currentUser = user
          self.loginSuccess?()
        }, failure: { (error: Error) -> () in
          self.loginFailure?(error)
        })
      }, failure: { (error: Error!) in
        self.loginFailure?(error)
      })
  }

  func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success:
      { (task: URLSessionDataTask, response: Any?) in
        let userDictionary = response as! NSDictionary
        let user = User(dictionary: userDictionary)
        User.currentUser = user
        success(user)
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        failure(error)
      })
  }

  func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success:
      { (task: URLSessionDataTask, response: Any?) in
        let dictionaries = response as! [NSDictionary]
        let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
        success(tweets)
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }

  func getMoreTweets(lastTweetId: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/statuses/home_timeline.json", parameters: ["max_id": lastTweetId], progress: nil, success:
      { (task: URLSessionDataTask, response: Any?) in
        let dictionaries = response as! [NSDictionary]
        let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
        success(tweets)
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }

  func newTweet(status: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    post("1.1/statuses/update.json", parameters: ["status": status], progress: nil, success:
      { (task: URLSessionDataTask, response: Any?) in
        let dictionary = response as! NSDictionary
        let tweet = Tweet(dictionary: dictionary)
        success(tweet)
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }

  func reply(status: String, replyToTweet id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    post("1.1/statuses/update.json", parameters: ["status": status, "in_reply_to_status_id": id], progress: nil, success:
      { (task: URLSessionDataTask, response: Any?) in
        let dictionary = response as! NSDictionary
        let tweet = Tweet(dictionary: dictionary)
        success(tweet)
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        failure(error)
      })
  }

  func retweet(tweetId: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    post("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success:
      { (task: URLSessionDataTask, response: Any?) in
        let dictionary = response as! NSDictionary
        let tweet = Tweet(dictionary: dictionary)
        success(tweet)
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        failure(error)
      })
  }

  func unretweet(tweetId: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    post("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil, success:
      { (task: URLSessionDataTask, response: Any?) in
        let dictionary = response as! NSDictionary
        let tweet = Tweet(dictionary: dictionary)
        success(tweet)
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        failure(error)
      })
  }

  func favorited(tweetId: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    post("1.1/favorites/create.json", parameters: ["id": tweetId], progress: nil, success:
      { (task: URLSessionDataTask, response: Any?) in
        let dictionary = response as! NSDictionary
        let tweet = Tweet(dictionary: dictionary)
        success(tweet)
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        failure(error)
      })
  }

  func unfavorited(tweetId: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    post("1.1/favorites/destroy.json", parameters: ["id": tweetId], progress: nil, success:
      { (task: URLSessionDataTask, response: Any?) in
        let dictionary = response as! NSDictionary
        let tweet = Tweet(dictionary: dictionary)
        success(tweet)
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        failure(error)
      })
  }
}


