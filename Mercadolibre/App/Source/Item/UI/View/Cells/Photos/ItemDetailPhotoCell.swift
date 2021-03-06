//
//  ItemDetailPhotoCell.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 6/03/21.
//

import UIKit
import AlamofireImage

final class ItemDetailPhotoCell: UICollectionViewCell {
    @IBOutlet private weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.image = UIImage(systemName: "photo")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = UIImage(systemName: "photo")
    }
    func set(image: URL) {
        if let data = try? Data(contentsOf: image),
           let image = UIImage(data: data, scale: UIScreen.main.scale) {
            image.af.inflate()
            photoImageView.image = image
        }
    }
    
}
