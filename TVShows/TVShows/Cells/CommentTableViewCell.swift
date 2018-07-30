//
//  CommentTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit

struct commentCellItems{
    let id: String?
    let text: String
    let userEmail: String
    let image: UIImage?
}

class CommentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
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
        
        userEmailLabel.text = nil
        commentLabel.text = nil
        userImage.image = nil
    }
    
    func configureCell(with item: commentCellItems){
        userEmailLabel.text = item.userEmail
        commentLabel.text = item.text
        userImage.image = item.image
    }
    
}
