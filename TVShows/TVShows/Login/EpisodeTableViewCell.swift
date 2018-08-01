//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit

struct episodeCellItems{
    let episodeNumber: String
    let episodeName: String
}

class EpisodeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var episodeNumber: UILabel!
    @IBOutlet weak var arrow: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        episodeName.text = nil
        episodeNumber.text = nil
    }
    
    func configureCell(with item: episodeCellItems){
        episodeName.text = item.episodeName
        episodeNumber.text = item.episodeNumber
        arrow.isEnabled = false
    }
    
}
