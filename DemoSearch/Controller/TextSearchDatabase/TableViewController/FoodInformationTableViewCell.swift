//
//  FoodInformationTableViewCell.swift
//  DemoSearch
//
//  Created by Gemma Jing on 11/11/2017.
//  Copyright © 2017 Gemma Jing. All rights reserved.
//

import UIKit
//MARK: element of the first cell
class FoodInformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: elememt of second cell
class FoodInformationSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var nutrientTypeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
