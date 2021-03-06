//
//  ItemViewController.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 5/03/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ItemViewOutput {
    func back()
}

final class ItemViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private weak var headerView: UIView! {
        didSet {
            headerView.backgroundColor = Style.color.mercadolibre
        }
    }
    @IBOutlet private weak var cartButton: UIButton! {
        didSet {
            cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
            cartButton.tintColor = Style.color.gray
        }
    }
    @IBOutlet private weak var searchButton: UIButton! {
        didSet {
            searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            searchButton.tintColor = Style.color.gray
        }
    }
    @IBOutlet private weak var likeButton: UIButton! {
        didSet {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = Style.color.gray
        }
    }
    @IBOutlet private weak var backButton: UIButton! {
        didSet {
            backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            backButton.tintColor = Style.color.gray
            backButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.output.back()
            }).disposed(by: disposeBag)
        }
    }
    @IBOutlet private weak var locationImage: UIImageView! {
        didSet {
            locationImage.image = UIImage(systemName: "mappin.and.ellipse")
            locationImage.tintColor = Style.color.gray
        }
    }
    @IBOutlet private weak var locationLabel: UILabel! {
        didSet {
            locationLabel.text = "Enviar a Luis Cabarique - " + input.currentAddress
            locationLabel.font = Style.font.h3Regular
            locationLabel.textColor = Style.color.gray
        }
    }
    
    // MARK: Subjects
    
    
    // MARK: Attributes
    private let disposeBag = DisposeBag()
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
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Style.color.background
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       self.navigationController?.isNavigationBarHidden = false;
    }
}
