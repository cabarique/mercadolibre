//
//  ItemCell.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 20/02/21.
//

import UIKit
import SkeletonView
import RxSwift
import Alamofire
import AlamofireImage

final class ItemCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var thumbImage: UIImageView! {
        didSet {
            thumbImage.backgroundColor = .clear
        }
    }
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
            usedLabel.textColor = Style.color.lightGray
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        thumbImage.image = nil
    }
    
    var separatorEnabled: Bool = true {
        didSet {
            separatorView.isHidden = !separatorEnabled
        }
    }
    func setup(title: String, price: String, thumb: URL? = nil, installments: String? = nil, condition: String? = nil) {
        titleLabel.text = title
        priceLabel.text = price
        installmentLabel.text = installments
        usedLabel.text = condition
        if let thumb = thumb,
           let data = try? Data(contentsOf: thumb),
           let image = UIImage(data: data, scale: UIScreen.main.scale) {
            image.af.inflate()
            thumbImage.image = image
        }
        
    }
}
