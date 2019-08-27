//
//  TwitterFeedViewController.swift
//  Twitter
//
//  Created by Saransh Mittal on 21/08/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit
import RxSwift

class TwitterFeedViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var twitterNewsFeed: TwitterNewsFeedViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        twitterNewsFeed = TwitterNewsFeedViewModel()
        twitterNewsFeed?.newsFeed.bind(to: tableView.rx.items(cellIdentifier: "tweet", cellType: NewsFeedTableViewCell.self)) { row, model, cell in
            cell.usernameLabel.text = "@\(model.username!)﹒\(model.date!)"
            cell.tweetLabel.text = "@\(model.text!)"
            cell.retweetButton.setTitle(" \(model.retweetCount)", for: .init())
            cell.likeButton.setTitle(" \(model.likeCount)", for: .init())
            cell.userImageView.image = self.twitterNewsFeed?.getImage(path: model.imageUrl!)
            }.disposed(by: twitterNewsFeed!.disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(DatabaseManager.getFileURL())
        DispatchQueue.main.async {
            self.checkForTweetUpdates(query: "france")
        }
    }

    func checkForTweetUpdates(query: String) {
        twitterNewsFeed?.refreshTwitterFeed(query: query) {(success, tweets) in
            if success == true {
                // updates available and updating the UI accordingly
                print("New tweets added")
            } else {
                // no new tweet updates available for the UI updation
                print("No new tweet available for the keyword")
            }
        }
    }

}

