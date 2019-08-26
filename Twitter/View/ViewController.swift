//
//  ViewController.swift
//  Twitter
//
//  Created by Saransh Mittal on 21/08/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateCachedTweets()
        DispatchQueue.main.async {
            self.checkForTweetUpdates(query: "elon")
        }
    }

    func updateCachedTweets() {
        let tweets: [Tweet] = TweetViewModel.getTweets()
        // make all the following UI updates to proceed
        print(tweets.count)
    }

    func checkForTweetUpdates(query: String) {
        TweetViewModel.refreshTweets(query: query) {(success, tweets) in
            if success == true {
                // updates available and updating the UI accordingly
                self.updateCachedTweets()
            } else {
                // no new tweet updates available for the UI updation
            }
        }
    }

}

