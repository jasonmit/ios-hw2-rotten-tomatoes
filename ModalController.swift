//
//  ModalController.swift
//  Rotten
//
//  Created by Jason Mitchell on 9/9/14.
//  Copyright (c) 2014 Jason Mitchell. All rights reserved.
//

import UIKit

class ModalController: UIViewController {
    // repeated.. need to figure out to be DRY
    private let API_KEY = "dagqdghwaq3e3mxyrp7kmmj5"
    
    var movies: [NSDictionary]! = []
    var currentRow: Int?
    
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movie = movies[self.currentRow!]
        let posters = movie["posters"] as NSDictionary
        let posterUrl = posters["thumbnail"] as String
        
        //
        // replace _tmb with _ori for full-screen image
        //
        
        posterImage.setImageWithURL(NSURL(string: posterUrl))
        let originalUrl = posterUrl.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        self.synopsisLabel.text = movie["synopsis"]! as? String
        self.posterImage.setImageWithURL(NSURL(string: originalUrl))
    }

    @IBAction func dismissTouched(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
