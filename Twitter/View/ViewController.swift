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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var twitterNewsFeed: TwitterNewsFeedViewModel?
    var searchText = ""
    
    func addNavigationBarImage() {
        let navController = navigationController!
        let image = UIImage(named: "Twitter.png") //Your logo url here
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    func initTableView() {
        tableView.delegate = self
        twitterNewsFeed = TwitterNewsFeedViewModel()
        twitterNewsFeed?.newsFeed.bind(to: tableView.rx.items(cellIdentifier: "tweet", cellType: NewsFeedTableViewCell.self)) { row, model, cell in
            let date: String = self.twitterNewsFeed?.dateSummary(date: model.date!) as! String
            cell.nameLabel.text = "\(model.name!)"
            cell.usernameLabel.text = "@\(model.username!)﹒\(date)"
            cell.tweetLabel.text = "\(model.text!)"
            cell.retweetButton.setTitle(" \(model.retweetCount)", for: .init())
            cell.likeButton.setTitle(" \(model.likeCount)", for: .init())
            cell.userImageView.image = self.twitterNewsFeed?.getImage(path: model.imageUrl!)
            if model.bannerUrl != nil {
                self.twitterNewsFeed?.getImage(path: model.bannerUrl!)
            } else {
                cell.tweetImageView.isHidden = true
            }
            }.disposed(by: twitterNewsFeed!.disposeBag)
    }
    
    func searchForTweets(query: String) {
        DispatchQueue.main.async {
            self.twitterNewsFeed?.refreshTwitterFeed(query: query) {(success, tweets) in
                if success == true {
                    print("New tweets added")
                } else {
                    print("No new tweet available for the keyword")
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initSearchBar()
        addNavigationBarImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(DatabaseManager.getFileURL())
    }
}

extension TwitterFeedViewController: UISearchBarDelegate {
    func initSearchBar() {
        searchBar.delegate = self
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchForTweets(query: searchText)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}

