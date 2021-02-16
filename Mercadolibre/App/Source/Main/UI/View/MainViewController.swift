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
