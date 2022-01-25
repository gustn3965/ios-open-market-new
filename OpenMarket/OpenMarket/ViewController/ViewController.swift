//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

extension UIView {
    static var identifier: String {
        String(describing: self)
    }
}

class ViewController: UIViewController {
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl: UISegmentedControl = UISegmentedControl(items: [NSString("LIST"), NSString("GRID")])
        segmentControl.addTarget(self, action: #selector(segmentControlDidChanged(_:)), for: .valueChanged)
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.backgroundColor = .systemBackground
        segmentControl.selectedSegmentIndex = 0
        segmentControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentControl.layer.borderWidth = 1
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.2)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ListOpenMarketCollectionViewCell.self,
                                forCellWithReuseIdentifier: ListOpenMarketCollectionViewCell.identifier)
        collectionView.register(GridOpenMarketCollectionViewCell.self,
                                forCellWithReuseIdentifier: GridOpenMarketCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private var controlIndex: Int {
        segmentControl.selectedSegmentIndex
    }
    
    private var productList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        view.backgroundColor = .systemBackground
        fetchProductList()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = segmentControl
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        collectionView.dataSource = self
    }
    
    private func changeFlowLayout(controlIndex: Int) {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        if controlIndex == 0 {
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.2)
            collectionView.collectionViewLayout = flowLayout
        } else {
            
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.7)
            collectionView.collectionViewLayout = flowLayout
        }
        collectionView.reloadData()
    }
    
    @objc
    func segmentControlDidChanged(_ control: UISegmentedControl) {
        print(control.selectedSegmentIndex)
        changeFlowLayout(controlIndex: controlIndex)
    }
    
    func fetchProductList() {
        ProductListViewModel().getProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let productList):
                self.productList = productList.pages ?? []
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if controlIndex == 0 {
            guard let cell: ListOpenMarketCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListOpenMarketCollectionViewCell.identifier, for: indexPath) as? ListOpenMarketCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.updateView(by: productList[indexPath.item])
            return cell
        } else {
            guard let cell: GridOpenMarketCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GridOpenMarketCollectionViewCell.identifier, for: indexPath) as? GridOpenMarketCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.updateView(by: productList[indexPath.item])
            return cell
        }
    }
}

class ListOpenMarketCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.text = "MAC mini"
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "USD 800"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bargainLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "USD 800"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.text = "잔여수량"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [bargainLabel, priceLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleStockStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, stockLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var totalLabelStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [titleStockStackView, priceStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [imageView, totalLabelStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init didn't implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        stockLabel.text = ""
        priceLabel.text = ""
        bargainLabel.text = ""
    }
    
    func setupView() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    func updateView(by product: Product) {
        titleLabel.text = product.name
        priceLabel.text = "\(product.currency ?? "") \(product.price ?? 0)"
        stockLabel.text = "잔여수량: \(product.stock ?? 0)"
    }
}

class GridOpenMarketCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.text = "MAC mini"
        label.lineBreakMode = .byTruncatingTail
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "USD 800"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bargainLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "USD 800"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.text = "잔여수량"
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [imageView,
                                                                    titleLabel,
                                                                    bargainLabel,
                                                                    priceLabel,
                                                                    stockLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init didn't implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        stockLabel.text = ""
        priceLabel.text = ""
        bargainLabel.text = ""
    }
    
    func setupView() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    func updateView(by product: Product) {
        titleLabel.text = product.name
        priceLabel.text = "\(product.currency ?? "") \(product.price ?? 0)"
        stockLabel.text = "잔여수량: \(product.stock ?? 0)"
    }
}

