//
//  ItemDetailPriceCell.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 6/03/21.
//

import UIKit

final class ItemDetailPriceCell: UICollectionViewCell {
    @IBOutlet weak var originalPriceLabel: UILabel! {
        didSet {
            originalPriceLabel.isHidden = true
            originalPriceLabel.font = Style.font.h2Regular
            originalPriceLabel.textColor = Style.color.lightGray
        }
    }
    @IBOutlet weak var basePriceLabel: UILabel! {
        didSet {
            basePriceLabel.font = Style.font.titleRegular
            basePriceLabel.textColor = Style.color.gray
        }
    }
    @IBOutlet weak var discountLabel: UILabel! {
        didSet {
            discountLabel.font = Style.font.h2Regular
            discountLabel.textColor = Style.color.green
        }
    }
    @IBOutlet weak var installmentLabel: UILabel! {
        didSet {
            installmentLabel.font = Style.font.h2Regular
            installmentLabel.textColor = Style.color.gray
        }
    }
    
    func setup(originalPrice: Float?, basePrice: Float, discount: Int?, installments: String) {
        if let originalPrice = originalPrice, let discount = discount {
            originalPriceLabel.isHidden = false
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: originalPrice.toCurrency())
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                             value: 1,
                                             range: NSMakeRange(0, attributeString.length))
            originalPriceLabel.attributedText = attributeString
            basePriceLabel.text = basePrice.toCurrency()
            discountLabel.text = "\(discount)% OFF"
        } else {
            discountLabel.isHidden = true
            originalPriceLabel.isHidden = true
            basePriceLabel.text = basePrice.toCurrency()
        }
        installmentLabel.text = installments
    }
}
