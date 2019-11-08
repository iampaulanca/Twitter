//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Paul Ancajima on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var favorited = false
    var tweetId = -1
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBAction func favButton(_ sender: Any) {
        let toBeFavorited = !favorited
        if toBeFavorited {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(isFavorited: true)
            }, failure: { (Error) in
                print("\(Error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(isFavorited: false)
            }, failure: { (Error) in
                print("\(Error)")
            })
        }
    }
    @IBAction func retweetButton(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(isRetweeted: true)
        }, failure: { (Error) in
            print("\(Error)")
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setFavorited(isFavorited: Bool){
        favorited = isFavorited
        if favorited {
            favButton.setImage(UIImage(named:"favor-icon-red"), for: .normal)
        } else {
            favButton.setImage(UIImage(named:"favor-icon"), for: .normal)
        }
    }
    func setRetweeted(isRetweeted: Bool) {
        if isRetweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            retweetButton.isEnabled = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
