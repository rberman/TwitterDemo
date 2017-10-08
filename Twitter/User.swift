//
//  User.swift
//  Twitter
//
//  Created by ruthie_berman on 9/27/17.
//  Copyright © 2017 ruthie_berman. All rights reserved.
//

import UIKit

class User: NSObject {

  var id: Int?
  var name: String?
  var username: String?
  var tagline: String?
  var tweetsCount: Int?
  var followersCount: Int?
  var followingCount: Int?
  var profileImageUrl: URL?
  var backgroundImageUrl: URL?

  var dictionary: NSDictionary?

  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    id = dictionary["id"] as? Int
    name = dictionary["name"] as? String
    username = dictionary["screen_name"] as? String
    tagline = dictionary["description"] as? String
    tweetsCount = dictionary["statuses_count"] as? Int
    followersCount = dictionary["followers_count"] as? Int
    followingCount = dictionary["friends_count"] as? Int

    let profileImageUrlStr = dictionary["profile_image_url_https"] as? String
    if let profileImageUrlStr = profileImageUrlStr {
      profileImageUrl = URL(string: profileImageUrlStr)
    }
    let backgroundImageUrlStr = dictionary["profile_background_image_url_https"] as? String
    if let backgroundImageUrlStr = backgroundImageUrlStr {
      backgroundImageUrl = URL(string: backgroundImageUrlStr)
    }
  }

  static let userDidLogoutNotification = "UserDidLogout"
  static var _currentUser: User?
  class var currentUser: User? {
    get {
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: "currentUserData") as? Data
        if let userData = userData {
          let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
          _currentUser = User(dictionary: dictionary)
        }
      }
      return _currentUser
    }
    set(user) {
      _currentUser = user
      let defaults = UserDefaults.standard
      if let user = user {
        let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
        defaults.set(data, forKey: "currentUserData")
      } else {
        defaults.set(nil, forKey: "currentUserData")
      }
      defaults.synchronize()
    }
  }
}
