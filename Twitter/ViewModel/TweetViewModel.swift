//
//  TweetsViewModel.swift
//  Twitter
//
//  Created by Saransh Mittal on 21/08/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation

class TweetViewModel {
    
    private static func cacheData(tweets: [NSDictionary]) {
        for i in 0...(tweets.count-1) {
            let tweet = Tweet()
            let tweetFlag = tweets[i] as NSDictionary
            tweet.text = tweetFlag["tweet"] as? String
            tweet.username = tweetFlag["username"] as? String
            tweet.date = Date.init(timeIntervalSince1970: TimeInterval(tweetFlag["date"] as! Int))
            DatabaseManager.add(tweet: tweet)
        }
    }
    
    public static func getTweets() -> [Tweet] {
        return DatabaseManager.getTweets()
    }
    
    public static func getTweets(withQuery text: String) -> [Tweet] {
        return DatabaseManager.getTweets(withQuery: text)
    }
    
    public static func refreshTweets(query: String, completion: @escaping (Bool, [Tweet]) -> ()) {
        NetworkManager.getTweets(query: query) { (success, tweets) in
            if success == true {
                // clean the tweets
                self.cacheData(tweets: [tweets!])
                completion(true, DatabaseManager.getTweets())
            } else {
                completion(false, DatabaseManager.getTweets())
            }
        }
    }
}
