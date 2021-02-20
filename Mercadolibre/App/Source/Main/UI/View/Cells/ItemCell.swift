//
//  ItemCell.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 20/02/21.
//

import UIKit

final class ItemCell: UICollectionViewCell {
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Style.font.h2Regular
            titleLabel.textColor = Style.color.gray
        }
    }
    @IBOutlet private weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = Style.font.h1Bold
            priceLabel.textColor = Style.color.gray
        }
    }
    @IBOutlet private weak var installmentLabel: UILabel! {
        didSet {
            installmentLabel.font = Style.font.h3Regular
            installmentLabel.textColor = Style.color.gray
        }
    }
    @IBOutlet private weak var usedLabel: UILabel! {
        didSet {
            usedLabel.font = Style.font.h3Regular
            usedLabel.textColor = .lightGray
        }
    }
    
    var separatorEnabled: Bool = true {
        didSet {
            separatorView.isHidden = !separatorEnabled
        }
    }
    func setup(title: String, price: String) {
        titleLabel.text = title
        priceLabel.text = price
    }
}
