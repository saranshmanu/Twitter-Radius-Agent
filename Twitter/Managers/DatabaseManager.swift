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
    
    public static func add(tweet: Tweet) {
        try! database?.write {
            database?.add(tweet)
        }
    }
    
    public static func getTweets() -> [Tweet] {
        return Array((database?.objects(Tweet.self))!)
    }
    
    public static func getTweets(withQuery text: String) -> [Tweet] {
        return Array((database?.objects(Tweet.self).filter(text))!)
    }
    
    public static func getFileURL() -> URL {
        return Realm.Configuration.defaultConfiguration.fileURL!
    }
    
}
