//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Paul Ancajima on 10/31/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    @IBOutlet weak var tweetBarButton: UIBarButtonItem!
    
    
    @IBAction func onLogout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var refresher: UIRefreshControl = {
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshTweets), for: .valueChanged)
        return refreshControl
    }()
    
    @objc
    func refreshTweets(){
        let deadline = DispatchTime.now() + .milliseconds(888)
        loadTweets()
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        tableView.refreshControl = refresher
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    func loadTweets() {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 10]
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: myParams, success: {
            (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Could not load tweets")
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
        }
        
        cell.setFavorited(isFavorited: tweetArray[indexPath.row]["favorited"] as! Bool)
        
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
