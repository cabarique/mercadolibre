//
//  MainViewController.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 15/02/21.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

protocol MainViewOutput {
    func viewDidLoad()
    func search(_ query: String)
    func showItem(_ item: ItemEntity)
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
            searchView.rx.text.orEmpty
                .throttle(.milliseconds(500), latest: true, scheduler: MainScheduler.instance)
                .asObservable()
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] value in
                    self?.output.search(value)
                }).disposed(by: disposeBag)
        }
    }
    @IBOutlet private weak var cartImage: UIImageView!
    @IBOutlet private weak var locationImage: UIImageView! {
        didSet {
            locationImage.image = UIImage(systemName: "mappin.and.ellipse")
            locationImage.tintColor = Style.color.gray
        }
    }
    @IBOutlet private weak var addressLable: UILabel! {
        didSet {
            addressLable.font = Style.font.h3Regular
            addressLable.textColor = Style.color.gray
            addressLable.text = "Enviar a Luis Cabarique - " + input.currentAddress
        }
    }
    
    // MARK: Attributes
    private let input: MainViewInput
    private let output: MainViewOutput
    private let disposeBag =  DisposeBag()
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<SectionEntity, MainItemEntity>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionEntity, MainItemEntity>
    private lazy var dataSource = makeDataSource()
    
    init(presenter: MainViewInput & MainViewOutput) {
        self.input = presenter
        self.output = presenter
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
        collectionView.delegate = self
        output.viewDidLoad()
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
    
    // MARK: - CollectionView Layout
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                switch item {
                case let itemEntity as ItemEntity:
                    let id = String(describing: ItemCell.self)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? ItemCell
                    let condition = itemEntity.attributes.first(where: {$0.type == .condition})
                    cell?.setup(title: itemEntity.name,
                                price: itemEntity.formattedValue,
                                thumb: itemEntity.imageUrl,
                                installments: itemEntity.formatedInstallment,
                                condition: condition?.value)
                    cell?.separatorEnabled = indexPath.row != 0
                    return cell
                case is ItemLoadingEntity:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath)
                    cell.contentView.isSkeletonable = true
                    cell.contentView.showAnimatedSkeleton()
                    let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
                    cell.contentView.showAnimatedSkeleton(usingColor: .concrete, animation: animation, transition: .none)
                    return cell
                default:
                    let errorMessage = (item as? ItemErrorEntity)?.errorMsg
                    let id = String(describing: ErrorCell.self)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? ErrorCell
                    cell?.errorMessage = errorMessage
                    return cell
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "loadingCell")
        let errorId = String(describing: ErrorCell.self)
        collectionView.register(UINib(nibName: errorId, bundle: nil), forCellWithReuseIdentifier: errorId)
        
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
    
    // MARK: input
    private func rxBind() {
        input.itemsObservable
            .drive(onNext: { [weak self] sections in
                guard let self = self else { return }
                self.applySnapshot(animatingDifferences: true, sections: sections)
            }).disposed(by: disposeBag)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let entity = dataSource.itemIdentifier(for: indexPath) else { return }
        switch entity {
        case let item as ItemEntity: output.showItem(item)
        case is ItemErrorEntity:
            print("error") 
        default: break
        }
        
    }
}
