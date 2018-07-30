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
    
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
   
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodeNameLabel.text = episodeName
        episodeNumberLabel.text = episodeNumber
        if episodeDescription != ""{
            episodeDescriptionLabel.text = episodeDescription
        } else {
            episodeDescriptionLabel.text = "No description available!"
        }
        
        let url = URL(string: "https://api.infinum.academy" + imageUrl!)
        episodeImage.kf.setImage(with: url)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
