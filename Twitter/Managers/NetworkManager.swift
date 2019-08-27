//
//  NetworkManager.swift
//  Twitter
//
//  Created by Saransh Mittal on 21/08/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import Alamofire

// the Network Handler class manages the network request for GET and POST requests
class NetworkHandler {
    // .get network request to handle the error and other network parameters
    public static func get(url: String, header: HTTPHeaders, completion: @escaping (Bool, NSDictionary?) -> ()) {
        Alamofire.request(url, method: .get, headers: header).responseJSON { response in
            if response.result.isFailure == true || response.error != nil || response.result.value == nil{
                completion(true, nil)
            } else {
                let result = response.result.value as! NSDictionary
                completion(false, result)
            }
        }
    }
    
    // .post network request to handle the error and other network parameters
    public static func post(url: String, header: HTTPHeaders, parameters: Parameters, completion: @escaping (Bool, NSDictionary?) -> ()) {
        Alamofire.request(url, method: .post, parameters: parameters, headers: header).responseJSON { response in
            if response.result.isFailure == true || response.error != nil || response.result.value == nil {
                completion(true, nil)
            } else {
                let result = response.result.value as! NSDictionary
                completion(false, result)
            }
        }
    }
    
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public static func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        var image: UIImage?
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            image = UIImage(data: data)
            completion(image)
        }
    }
}

// the Network Manager class mannages the differnt requests to the Twitter backend to fetech results
class NetworkManager {
    // to authenticate the user and fetch the token for accessing the application
    public static func authenticate(encodedKey: String, completion: @escaping (Bool, String?) -> ()) {
        let url: String = "https://api.twitter.com/oauth2/token"
        let header = [
            "Authorization" : "Basic \(encodedKey)",
            "Content-Type"  : "application/x-www-form-urlencoded"
            ] as HTTPHeaders
        let parameters = [
            "grant_type"    : "client_credentials"
            ] as Parameters
        
        NetworkHandler.post(url: url, header: header, parameters: parameters) { (error, result) in
            if error == false {
                let response = result!
                if let token = response["access_token"] as? String {
                    AuthenticationKeys.token = token
                    completion(true, token)
                } else {
                    completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }
    }
    
    // to get the tweets from search query by the user
    public static func getTweets(query: String, completion: @escaping (Bool, NSDictionary?) -> ()) {
        let url = "https://api.twitter.com/1.1/search/tweets.json" + "?q=" + query
        let header = [
            "Authorization": "Bearer \(AuthenticationKeys.token)",
            ] as HTTPHeaders
        
        NetworkHandler.get(url: url, header: header) { (error, tweets) in
            if error == false {
                completion(true, tweets)
            } else {
                completion(false, nil)
            }
        }
    }
    
    public static func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        NetworkHandler.downloadImage(from: URL(string:url)!) { (image) in
            completion(image)
        }
    }
}
