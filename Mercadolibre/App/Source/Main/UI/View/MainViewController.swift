//
//  MainViewController.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: Attributes
    private let presenter: MainPresenterProtocol
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = Style.color.background
        }
    }
    @IBOutlet private weak var headerView: UIView! {
        didSet {
            headerView.backgroundColor = Style.color.mercadolibre
        }
    }
    @IBOutlet private weak var searchView: UISearchBar! {
        didSet {
            searchView.searchTextField.backgroundColor = .white
            searchView.searchTextField.layer.masksToBounds = true
            searchView.searchTextField.layer.cornerRadius = 15
            searchView.backgroundImage = UIImage()
            searchView.searchTextField.font = Style.font.h3Regular
            searchView.searchTextField.textColor = Style.color.gray
            searchView.searchTextField.placeholder = "Buscar en Mercado Libre"
        }
    }
    @IBOutlet private weak var cartImage: UIImageView!
    @IBOutlet private weak var locationImage: UIImageView!
    @IBOutlet private weak var addressLable: UILabel! {
        didSet {
            addressLable.font = Style.font.h3Regular
            addressLable.textColor = Style.color.gray
            addressLable.text = "Enviar a Luis Cabarique - calle 159 # 54 - 81 >"
        }
    }
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: MainViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Style.color.background
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
