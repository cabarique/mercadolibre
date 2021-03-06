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
import SkeletonView

protocol ItemViewOutput {
    func back()
    func viewDidLoad()
    func openLink(url: URL)
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
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<ItemDetailSection, MainItemDetailSection>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ItemDetailSection, MainItemDetailSection>
    private lazy var dataSource = makeDataSource()
    
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
                case let detail as ItemDetailHeader:
                    let id = String(describing: ItemDetailHeaderCell.self)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? ItemDetailHeaderCell
                    cell?.setup(name: detail.name, condition: detail.condition, soldQuantity: detail.soldQuantity, soldBy: detail.soldBy)
                    return cell
                case let photo as ItemDetailPhoto:
                    let id = String(describing: ItemDetailPhotoCell.self)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? ItemDetailPhotoCell
                    cell?.set(image: photo.url)
                    return cell
                case let price as ItemDetailPrice:
                    let id = String(describing: ItemDetailPriceCell.self)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? ItemDetailPriceCell
                    cell?.setup(originalPrice: price.original,
                                basePrice: price.price,
                                discount: price.discount,
                                installments: "en \(price.installments.quantity)x \(price.installments.amount.toCurrency())")
                    return cell
                case is ItemDetailBuy:
                    let id = String(describing: ItemDetailBuyCell.self)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? ItemDetailBuyCell
                    return cell
                case is MainItemDetailLoadingSection:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath)
                    cell.contentView.isSkeletonable = true
                    cell.contentView.showAnimatedSkeleton()
                    let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
                    cell.contentView.showAnimatedSkeleton(usingColor: .concrete, animation: animation, transition: .none)
                    return cell
                default:
                    let errorMessage = (item as? MainItemDetailErrorSection)?.errorMessage
                    let id = String(describing: ErrorCell.self)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? ErrorCell
                    cell?.errorMessage = errorMessage
                    return cell
                }
            })
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true, sections: [ItemDetailSection]) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func configureLayout() {
        let id = String(describing: ItemDetailHeaderCell.self)
        collectionView.register(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
        let photo = String(describing: ItemDetailPhotoCell.self)
        collectionView.register(UINib(nibName: photo, bundle: nil), forCellWithReuseIdentifier: photo)
        let price = String(describing: ItemDetailPriceCell.self)
        collectionView.register(UINib(nibName: price, bundle: nil), forCellWithReuseIdentifier: price)
        let buy = String(describing: ItemDetailBuyCell.self)
        collectionView.register(UINib(nibName: buy, bundle: nil), forCellWithReuseIdentifier: buy)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "loadingCell")
        let errorId = String(describing: ErrorCell.self)
        collectionView.register(UINib(nibName: errorId, bundle: nil), forCellWithReuseIdentifier: errorId)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = self.input.sectionForIndex(sectionIndex) else {
                let size = NSCollectionLayoutSize(
                    widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                    heightDimension: NSCollectionLayoutDimension.absolute(0)
                )
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 0)
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
            switch sectionType {
            case .header:
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(100)
                )
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
                group.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .photos:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(0.7)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
                group.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 0)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            case .price:
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(100)
                )
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
                group.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .buy:
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(120)
                )
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
                group.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .other:
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(120)
                )
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
                group.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        })
    }
    
    // MARK: Rx
    func rxBind() {
        input.itemsObservable
            .drive(onNext: { [weak self] sections in
                guard let self = self else { return }
                self.applySnapshot(animatingDifferences: true, sections: sections)
            }).disposed(by: disposeBag)
    }
}

extension ItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let entity = dataSource.itemIdentifier(for: indexPath) else { return }
        if let buy = entity as? ItemDetailBuy, let url = buy.link {
            output.openLink(url: url)
        }
    }
}
