//
//  HomeViewControllerCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 21/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit

struct HomeViewCellItem{
    let title: String
}

class HomeViewControllerCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
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
        
        titleLabel.text = nil
    }
    
    func configureCell(with item: HomeViewCellItem){
        titleLabel.text = item.title
    }
}
