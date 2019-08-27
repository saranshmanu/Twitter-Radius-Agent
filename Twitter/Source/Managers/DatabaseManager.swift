//
//  DatabaseManager.swift
//  Twitter
//
//  Created by Saransh Mittal on 21/08/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    private static var database: Realm?
    
    init() {
        DatabaseManager.database = try! Realm()
    }
    
    // get the cached image
    public static func getImage(path: String) -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: path) as? Data,
            let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }
    
    // download the image and save at path with URL as the key
    public static func addImage(url: String) {
        NetworkManager.getImage(url: url) { (image) in
            UserDefaults.standard.set(UIImagePNGRepresentation(image!), forKey: url)
        }
    }
    
    // add twitter feed to the Realm database
    public static func addTweet(tweet: Tweet) {
        try! database?.write {
            database?.add(tweet)
        }
    }
    
    // remove all the twitter feed from the Realm database
    public static func removeTweets() {
        try! database?.write {
            database?.deleteAll()
        }
    }
    
    // fetch the twitter feed from the Realm database
    public static func getTweets() -> [Tweet] {
        return Array((database?.objects(Tweet.self))!)
    }
    
    // fetch the twitter feed from the Realm database with a keyword query
    public static func getTweets(withQuery text: String) -> [Tweet] {
        return Array((database?.objects(Tweet.self).filter(text))!)
    }
    
    // get the Realm offline storage path
    public static func getFileURL() -> URL {
        return Realm.Configuration.defaultConfiguration.fileURL!
    }
    
}
