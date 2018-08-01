//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 28/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {

    var imageUrl: String?
    var episodeName: String?
    var episodeNumber: String?
    var episodeDescription: String?
    var episodeId: String?
    var token: String?
    
    
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodeNameLabel.text = episodeName
        episodeNumberLabel.text = episodeNumber
        if episodeDescription != "" {
            episodeDescriptionLabel.text = episodeDescription
        } else {
            episodeDescriptionLabel.text = "No description available!"
        }
        if imageUrl != "" {
            let url = URL(string: "https://api.infinum.academy" + imageUrl!)
            episodeImage.kf.setImage(with: url)
        } else {
            episodeImage.image = UIImage(named: "ic-camera")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let commentViewController: CommentViewController = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        commentViewController.episodeId = self.episodeId!
        commentViewController.token = self.token
        self.navigationController?.pushViewController(commentViewController, animated: true)
    }
}
