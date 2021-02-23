//
//  MainViewController.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainViewInput {
    var itemsObservable: Driver<[SectionEntity]> { get }
}

final class MainViewController: UIViewController {
    // MARK: IBOutlets
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
    
    // MARK: Attributes
    private let presenter: MainViewInput
    private let disposeBag =  DisposeBag()
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<SectionEntity, MainItemEntity>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionEntity, MainItemEntity>
    private lazy var dataSource = makeDataSource()
    
    init(presenter: MainViewInput) {
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
        configureLayout()
        collectionView.dataSource = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rxBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       self.navigationController?.isNavigationBarHidden = false;
    }
    
    // MARK: - Functions
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                switch item {
                case let itemEntity as ItemEntity:
                    let id = String(describing: ItemCell.self)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? ItemCell
                    cell?.setup(title: itemEntity.name, price: itemEntity.formattedValue)
                    cell?.separatorEnabled = indexPath.row != 0
                    return cell
                default:
                    return nil
                }
                
            })
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true, sections: [SectionEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func configureLayout() {
        let id = String(describing: ItemCell.self)
        collectionView.register(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 130 : 120)
            )
            let itemCount = isPhone ? 1 : 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            section.interGroupSpacing = 10
            return section
        })
    }
    
    private func rxBind() {
        presenter.itemsObservable
            .drive(onNext: { [weak self] sections in
                guard let self = self else { return }
                self.applySnapshot(animatingDifferences: true, sections: sections)
            }).disposed(by: disposeBag)
    }
}
