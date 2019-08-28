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
    
    var navController: UINavigationController? = nil
    var activityLoader: UIActivityIndicatorView? = nil
    
    func addNavigationBarImage() {
        navController = navigationController!
        let image = UIImage(named: "Twitter.png")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController?.navigationBar.frame.size.width
        let bannerHeight = navController?.navigationBar.frame.size.height
        let bannerX = bannerWidth! / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight! / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth!, height: bannerHeight!)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    func addActivityLoader() {
        activityLoader = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        let refreshBarButton: UIBarButtonItem = UIBarButtonItem(customView: activityLoader!)
        self.navigationItem.rightBarButtonItem = refreshBarButton
    }
    
    func showAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func updateTableCell(cell: NewsFeedTableViewCell, model: Tweet) {
        let date = self.twitterNewsFeed?.dateSummary(date: model.date!)
        cell.nameLabel.text = "\(model.name!)"
        cell.tweetLabel.text = "\(model.text!)"
        cell.usernameLabel.text = "@\(model.username!)﹒\(String(describing: date!))"
        cell.likeButton.setTitle(" \(model.likeCount)", for: .init())
        cell.retweetButton.setTitle(" \(model.retweetCount)", for: .init())
        cell.userImageView.image = self.twitterNewsFeed?.getImage(path: model.imageUrl!)
        if model.bannerUrl != nil {
            cell.tweetImageView.isHidden = false
            cell.tweetImageView.image = self.twitterNewsFeed?.getImage(path: model.bannerUrl!)
        } else {
            cell.tweetImageView.isHidden = true
        }
    }
    
    func initTableView() {
        tableView.delegate = self
        twitterNewsFeed = TwitterNewsFeedViewModel()
        twitterNewsFeed?.newsFeed.bind(to: tableView.rx.items(cellIdentifier: "tweet", cellType: NewsFeedTableViewCell.self)) { row, model, cell in
            self.updateTableCell(cell: cell, model: model)
        }.disposed(by: twitterNewsFeed!.disposeBag)
    }
    
    func searchForTweets(query: String) {
        activityLoader?.startAnimating()
        DispatchQueue.main.async {
            self.twitterNewsFeed?.refreshTwitterFeed(query: query) {(success, tweets) in
                if success == true {
                    // New feed updated to the Realm Database
                } else {
                    self.showAlert(message: "Feed not found for the searched query", title: "Error")
                }
                self.activityLoader?.stopAnimating()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initSearchBar()
        addNavigationBarImage()
        addActivityLoader()
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

