//
//  Tweets.swift
//  Twitter
//
//  Created by Saransh Mittal on 21/08/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import RealmSwift

class Tweet: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var username: String?
    @objc dynamic var text: String?
    @objc dynamic var date: Date?
    @objc dynamic var retweetCount: Int = 0
    @objc dynamic var likeCount: Int = 0
    @objc dynamic var imageUrl: String?
    @objc dynamic var bannerUrl: String?
}
