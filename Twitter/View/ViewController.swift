//
//  ViewController.swift
//  Twitter
//
//  Created by Saransh Mittal on 21/08/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var twitterNewsFeed: TwitterNewsFeedViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        twitterNewsFeed = TwitterNewsFeedViewModel()
        twitterNewsFeed?.newsFeed.bind(to: tableView.rx.items(cellIdentifier: "tweet")) { row, model, cell in
//            cell.textLabel?.text = "\(model.name), \(model.desc)"
            }.disposed(by: twitterNewsFeed!.disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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

