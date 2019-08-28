//
//  AllTableCell.swift
//  SCBFirstAssignment
//
//  Created by Thapakorn Tuwaemuesa on 27/8/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import UIKit

protocol AllTableCellDelegate : class {
    func didSelectFav(cell: AllTableCell)
}

class AllTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var thumbnailImageView : UIImageView!
    
    var delegate : AllTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didTapFav(_ sender: UIButton) {
        delegate?.didSelectFav(cell: self)
        if !sender.isSelected {
            sender.isSelected = true
        }else{
            sender.isSelected = false
        }
    }
}