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
    @objc dynamic var username: String?
    @objc dynamic var text: String?
    @objc dynamic var date: Date?
}
