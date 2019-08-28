//
//  TweetsViewModel.swift
//  Twitter
//
//  Created by Saransh Mittal on 21/08/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TwitterNewsFeedViewModel {
    
    let disposeBag = DisposeBag()
    public var newsFeed: BehaviorRelay<[Tweet]> = BehaviorRelay(value: [])
    
    init() {
        updateNewsFeed()
    }
    
    // parse the date in the tweet
    private func parseDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss +0000 yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from:date)!
        return date
    }
    
    // get the date summary of how old a date is from the current date
    public func dateSummary(date: Date) -> String {
        let tweetDate = Calendar.current.dateComponents([.day, .hour, .second, .minute], from: date)
        let currentDate = Calendar.current.dateComponents([.day, .hour, .second, .minute], from: Date.init())
        let seconds = currentDate.second! - tweetDate.second!
        let minutes = currentDate.minute! - tweetDate.minute!
        let hours = currentDate.hour! - tweetDate.hour!
        let days = currentDate.day! - tweetDate.day!
        if days >= 1 {
            return "\(String(describing: days))d"
        } else if hours >= 1 {
            return "\(String(describing: hours))h"
        } else if minutes >= 1 {
            return "\(String(describing: minutes))m"
        } else if seconds >= 1 {
            return "\(String(describing: seconds))s"
        } else {
            return ""
        }
    }
    
    // get the cached image
    public func getImage(path: String) -> UIImage? {
        return DatabaseManager.getImage(path: path)
    }

    // download the image and save at path with URL as the key
    private func saveImage(url: String) {
        DatabaseManager.addImage(url: url)
    }

    // cache the tweets from the newly fetched data on twitter
    private func cacheData(tweets: NSDictionary) {
        DatabaseManager.removeTweets()
        let flag = tweets["statuses"] as! [NSDictionary]
        for i in flag {
            let tweet = Tweet()
            tweet.id = i["id_str"] as? String
            tweet.text = i["text"] as? String
            tweet.retweetCount = i["retweet_count"] as! Int
            tweet.likeCount = i["favorite_count"] as! Int
            tweet.date = self.parseDate(date: i["created_at"] as! String)
            let user = i["user"] as! NSDictionary
            tweet.username = user["screen_name"] as? String
            tweet.name = user["name"] as? String
            tweet.imageUrl = user["profile_image_url_https"] as? String
            self.saveImage(url: tweet.imageUrl!)
            let entities = i["entities"] as! NSDictionary
            if let media = entities["media"] as! [NSDictionary]? {
                let a = media[0]
                tweet.bannerUrl = a["media_url_https"] as? String
                self.saveImage(url: tweet.bannerUrl!)
            }
            DatabaseManager.addTweet(tweet: tweet)
        }
        updateNewsFeed()
    }
    
    // authenticate the authentivation keys to get the latest token
    private func authenticateTwitterCredentials(completion: @escaping (Bool, String?) -> ()) {
        let encoding = AuthenticationKeys.encoding.toBase64()
        NetworkManager.authenticate(encodedKey: encoding) { (success, result) in
            if success == true {
                completion(true, result!)
            } else {
                completion(false, nil)
            }
        }
    }
    
    // update the cached tweets
    private func updateNewsFeed() {
        newsFeed.accept(DatabaseManager.getTweets())
    }
    
    // get the tweets with query in the cached database
    public func getTwitterFeed(withQuery text: String) -> [Tweet] {
        return DatabaseManager.getTweets(withQuery: text)
    }
    
    // refresh the tweets with new query and cache them
    public func refreshTwitterFeed(query: String, completion: @escaping (Bool, [Tweet]) -> ()) {
        self.authenticateTwitterCredentials { (success, token) in
            if success == true {
                AuthenticationKeys.token = token!
                NetworkManager.getTweets(query: query, completion: { (success, tweets) in
                    if success == true {
                        self.cacheData(tweets: tweets!)
                        if DatabaseManager.getTweetCount() == 0 {
                            completion(false, self.newsFeed.value)
                        } else {
                            completion(true, self.newsFeed.value)
                        }
                    } else {
                        completion(false, self.newsFeed.value)
                    }
                })
            } else {
                completion(false, self.newsFeed.value)
            }
        }
    }
}
