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
        updateTweets()
        DispatchQueue.main.async {
            self.checkForTweetUpdates(query: "")
        }
    }
    
    func updateTweets() {
        let _: [Tweet] = TweetViewModel.getTweets()
        // make all the following UI updates to proceed
    }
    
    func checkForTweetUpdates(query: String) {
        TweetViewModel.refreshTweets(query: query) {(success, tweets) in
            if success == true {
                // updates available and updating the UI accordingly
                self.updateTweets()
            } else {
                // no new tweet updates available for the UI updation
            }
        }
    }

}

