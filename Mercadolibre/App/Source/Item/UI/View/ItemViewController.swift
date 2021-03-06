//
//  ItemViewController.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation
import UIKit

protocol ItemViewOutput {
    
}

final class ItemViewController: UIViewController {
    // MARK: Attributes
    private let input: ItemViewInput
    private let output: ItemViewOutput
    
    init(presenter: ItemViewInput & ItemViewOutput) {
        self.input = presenter
        self.output = presenter
        super.init(nibName: String(describing: ItemViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
