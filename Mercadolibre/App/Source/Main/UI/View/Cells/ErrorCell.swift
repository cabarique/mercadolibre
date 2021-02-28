//
//  ErrorCell.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 28/02/21.
//

import UIKit

class ErrorCell: UICollectionViewCell {
    @IBOutlet private weak var iconImage: UIImageView! {
        didSet {
            iconImage.image = UIImage(systemName: "magnifyingglass.circle.fill")
            iconImage.tintColor = Style.color.gray
        }
    }
    @IBOutlet private weak var errorMsgView: UITextView! {
        didSet {
            errorMsgView.backgroundColor = .clear
            errorMsgView.font = Style.font.h1Regular
            errorMsgView.textColor = Style.color.gray
            errorMsgView.textAlignment = .center
        }
    }
    
    var errorMessage: String? {
        didSet {
            errorMsgView.text = errorMessage
        }
    }
}
