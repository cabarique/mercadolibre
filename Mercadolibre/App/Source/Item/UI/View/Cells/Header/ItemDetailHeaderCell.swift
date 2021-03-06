//
//  ItemDetailHeaderCell.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import UIKit

final class ItemDetailHeaderCell: UICollectionViewCell {
    @IBOutlet private weak var conditionLabel: UILabel! {
        didSet {
            conditionLabel.isHidden = true
            conditionLabel.font = Style.font.h3Regular
            conditionLabel.textColor = Style.color.lightGray
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = Style.font.h2Regular
            nameLabel.textColor = Style.color.gray
        }
    }
    @IBOutlet private weak var soldByLabel: UILabel! {
        didSet {
            soldByLabel.isHidden = true
            soldByLabel.font = Style.font.h3Regular
            soldByLabel.textColor = Style.color.lightGray
        }
    }
    
    func setup(name: String, condition: String?, soldQuantity: Int?, soldBy: String?) {
        nameLabel.text = name
        if let condition = condition {
            conditionLabel.isHidden = false
            var contitionText = condition
            if let soldQuantity = soldQuantity {
                contitionText += " | \(soldQuantity) vendidos"
            }
            conditionLabel.text = contitionText
        }
        if let soldBy = soldBy {
            soldByLabel.isHidden = false
            soldByLabel.text = "por " + soldBy
        }
        
    }
}
