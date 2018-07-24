//
//  DescriptionTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit

struct descriptionCellItems{
    let imageUrl: String
    let title: String
    let description: String
    let numberOfEpisodes: Int
}

class DescriptionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showDescription: UILabel!
    @IBOutlet weak var numberOfEpisodes: UILabel!
    
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
        showImage.image = nil
        showTitle.text = nil
        showDescription.text = nil
        numberOfEpisodes.text = nil
    }
    
    func configureCell(with item: descriptionCellItems){
        showTitle.text = item.title
        showDescription.text = item.description
        showDescription.sizeToFit()
        showDescription.adjustsFontSizeToFitWidth = true
        numberOfEpisodes.text = String(item.numberOfEpisodes)
        if let url = NSURL(string: item.imageUrl), let data = NSData(contentsOf: url as URL){
            showImage.image = UIImage(data: data as Data)
        }
    }
    
}
