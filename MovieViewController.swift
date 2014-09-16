//
//  MovieViewController.swift
//  Rotten
//
//  Created by Jason Mitchell on 9/9/14.
//  Copyright (c) 2014 Jason Mitchell. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigatorItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notificationView: UIView!
    
    private let API_KEY = "dagqdghwaq3e3mxyrp7kmmj5"
    private var refreshControl:UIRefreshControl!
    private var movies: [NSDictionary]! = []
    private var selectedIndex: Int?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.loadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            self.loadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.loadData(searchString: searchBar.text)
    }
    
    func refresh(sender: AnyObject)
    {
        self.loadData()
    }
    
    func loadData(searchString: String? = nil) {
        self.activityIndicator.startAnimating()
        
        var apiUrl = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=\(API_KEY)&limit=20&country=us"
        
        if(searchString != nil) {
            apiUrl = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=\(API_KEY)&limit=20&country=us&q=\(searchBar.text)"
        }
        
        let request = NSURLRequest(URL: NSURL(string: apiUrl))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if(error != nil) {
                self.notificationView.hidden = false
            } else {
                var objects = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
                self.movies = objects["movies"] as [NSDictionary]
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("movieCell") as MovieCell
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
    
        let posters = movie["posters"] as NSDictionary
        let posterUrl = posters["thumbnail"] as String
        
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        return cell;
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "modalMovie" {
            let modalController = segue.destinationViewController as ModalController
            modalController.movies = self.movies;
            modalController.currentRow = tableView.indexPathForSelectedRow()!.row
        }
    }
}
