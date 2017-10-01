//
//  Tweet.swift
//  Twitter
//
//  Created by ruthie_berman on 9/27/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class Tweet: NSObject {

  var id: Int?
  var user: User?
  var text: String?
  var timestamp: Date?
  var retweetCount: Int = 0
  var favoritesCount: Int = 0
  var retweeted: Bool = false
  var favorited: Bool = false
  var replied: Bool = false
  var wasRetweeted: Bool = false
  var retweetedFromUsername: String?

  var replyIconHighlighted: Bool = false
  var retweetIconHighlighted: Bool = false
  var favoriteIconHighlighted: Bool = false

  init(dictionary: NSDictionary) {
    id = dictionary["id"] as? Int
    text = dictionary["text"] as? String
    retweetCount = dictionary["retweet_count"] as? Int ?? 0
    favoritesCount = dictionary["favourites_count"] as? Int ?? 0
    retweeted = dictionary["retweeted"] as! Bool
    favorited = dictionary["favorited"] as! Bool

    let retweetedTweetDictionary = dictionary["retweeted_status"] as? NSDictionary
    if let retweetedTweetDictionary = retweetedTweetDictionary {
      let retweetedTweet = Tweet(dictionary: retweetedTweetDictionary)
      retweetedFromUsername = retweetedTweet.user?.username
      wasRetweeted = true
    }

    let userData = dictionary["user"] as? NSDictionary
    if let userData = userData {
      user = User(dictionary: userData)
    } else {
      print("NO USER")
    }

    let timestampString = dictionary["created_at"] as? String
    if let timestampString = timestampString {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timestamp = formatter.date(from: timestampString)
    }
  }

  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    for dictionary in dictionaries {
      let tweet = Tweet(dictionary: dictionary)
      tweets.append(tweet)
    }
    return tweets
  }
}

