//
//  ItemDetailBuyCell.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 6/03/21.
//

import UIKit

final class ItemDetailBuyCell: UICollectionViewCell {
    @IBOutlet private weak var buyNowButton: UIButton! {
        didSet {
            buyNowButton.layer.masksToBounds = true
            buyNowButton.layer.cornerRadius = 4
            buyNowButton.backgroundColor = Style.color.blue
            buyNowButton.setTitleColor(.white, for: .normal)
            buyNowButton.setTitle("Comprar ahora", for: .normal)
        }
    }
    @IBOutlet private weak var addCartButton: UIButton! {
        didSet {
            addCartButton.layer.masksToBounds = true
            addCartButton.layer.cornerRadius = 4
            addCartButton.layer.borderWidth = 1
            addCartButton.layer.borderColor = Style.color.blue.cgColor
            addCartButton.backgroundColor = .white
            addCartButton.setTitleColor(Style.color.blue, for: .normal)
            addCartButton.setTitle("Agregar al carrito", for: .normal)
        }
    }
    
    
}
