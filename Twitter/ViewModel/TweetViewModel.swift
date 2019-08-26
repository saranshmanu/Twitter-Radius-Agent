//
//  TweetsViewModel.swift
//  Twitter
//
//  Created by Saransh Mittal on 21/08/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation

class TweetViewModel {
    
    // parse the date in the tweet
    private static func parseDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss +0000 yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from:date)!
        return date
    }
    
    // cache the tweets from the newly fetched data on twitter
    private static func cacheData(tweets: NSDictionary) {
        let flag = tweets[TwitterKeys.status] as! [NSDictionary]
        for i in flag {
            let tweet = Tweet()
            tweet.id = i[TwitterKeys.tweetId] as? String
            tweet.text = i[TwitterKeys.text] as? String
            let user = i[TwitterKeys.user] as! NSDictionary
            tweet.username = user[TwitterKeys.username] as? String
            let date = i["created_at"] as? String
            tweet.date = self.parseDate(date: date!)
            DatabaseManager.addTweet(tweet: tweet)
        }
    }
    
    // get the tweets those were cached in the Realm Database
    public static func getTweets() -> [Tweet] {
        return DatabaseManager.getTweets()
    }
    
    // get the tweets with query in the cached database
    public static func getTweets(withQuery text: String) -> [Tweet] {
        return DatabaseManager.getTweets(withQuery: text)
    }
    
    // refresh the tweets with new query and cache them
    public static func refreshTweets(query: String, completion: @escaping (Bool, [Tweet]) -> ()) {
        let encoding = AuthenticationKeys.encoding.toBase64()
        NetworkManager.authenticate(encodedKey: encoding) { (success, result) in
            if success == true {
                AuthenticationKeys.token = result!
                NetworkManager.getTweets(query: query, completion: { (success, tweets) in
                    if success == true {
                        self.cacheData(tweets: tweets!)
                        completion(true, self.getTweets())
                    } else {
                        completion(false, self.getTweets())
                    }
                })
            } else {
                completion(false, self.getTweets())
            }
        }
    }
}
