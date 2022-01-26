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

extension DispatchQueue {
    static func mainThread(_ completion: @escaping () -> Void ) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

class ViewController: UIViewController {
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
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
    
    private let listCollectionItemSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.25)
    private let gridCollectionItemSize: CGSize = CGSize(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.8)
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = listCollectionItemSize
        print(UIScreen.main.bounds.width)
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
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
    private var productListImageCache: NSCache = NSCache<NSString, UIImage>()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupIndicatorView()
        view.backgroundColor = .systemBackground
        fetchProductList()
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
    
    func setupIndicatorView() {
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = segmentControl
        let addBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPostButton))
        navigationItem.setRightBarButton(addBarButton, animated: true)
    }
    
    @objc func addPostButton() {
        
    }
    
    private func changeFlowLayout(controlIndex: Int) {
        print(UIScreen.main.bounds.width)
        if controlIndex == 0 {
            flowLayout.itemSize = listCollectionItemSize
            collectionView.collectionViewLayout = flowLayout
        } else {
            flowLayout.itemSize = gridCollectionItemSize
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
        indicatorView.startAnimating()
        ProductListViewModel().getProductList(pageNumber: 1, itemsPerPage: 200) { result in
            self.productListImageCache.removeAllObjects()
            switch result {
            case .success(let productList):
                self.productList = productList.pages ?? []
            case .failure(let error):
                DispatchQueue.mainThread {
                    self.indicatorView.stopAnimating()
                    self.productList = []
                }
                print(error)
            }
            DispatchQueue.mainThread {
                self.indicatorView.stopAnimating()
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
        var productListCell: ProductListCellable
        if controlIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListOpenMarketCollectionViewCell.identifier, for: indexPath) as? ListOpenMarketCollectionViewCell else {
                return UICollectionViewCell()
            }
            productListCell = cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridOpenMarketCollectionViewCell.identifier, for: indexPath) as? GridOpenMarketCollectionViewCell else {
                return UICollectionViewCell()
            }
            productListCell = cell
        }
        
        productListCell.updateView(by: productList[indexPath.item],
                                   cache: productListImageCache)
        return productListCell
    }
}

protocol ProductListCellable: UICollectionViewCell {
    var imageView: UIImageView { get }
    var titleLabel: UILabel { get }
    var priceLabel: UILabel { get }
    var stockLabel: UILabel { get }
    var bargainLabel: UILabel { get }
    
    func updateView(by product: Product, cache: NSCache<NSString, UIImage>)
    
    func resetView()
}

extension ProductListCellable {
    func updateView(by product: Product, cache: NSCache<NSString, UIImage>) {
        titleLabel.text = product.name
        if let bargainPrice: Double = product.bargainPrice {
            bargainLabel.text = bargainPrice == 0 ? "" : "\(product.currency ?? "") \(product.bargainPrice ?? 0)"
            bargainLabel.isHidden = bargainPrice == 0
        }
        bargainLabel.text = "\(product.currency ?? "") \(product.bargainPrice ?? 0)"
        priceLabel.text = "\(product.currency ?? "") \(product.price ?? 0)"
        if let stock: Int = product.stock {
            stockLabel.textColor = stock == 0 ? .systemOrange : .systemGray
            stockLabel.text = stock == 0 ? "품절" : "잔여수량: \(product.stock ?? 0)"
        }
        
        guard let thumbnailStr = product.thumbnail else {
            imageView.image = nil
            return
        }
        let thumbnaiNSStr: NSString = NSString(string: thumbnailStr)
        if let cacheImage: UIImage = cache.object(forKey: thumbnaiNSStr) {
            imageView.image = cacheImage
            return
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: thumbnailStr),
                  let image = try? UIImage(data: Data(contentsOf: url, options: .alwaysMapped))
            else {
                cache.removeObject(forKey: thumbnaiNSStr)
                DispatchQueue.mainThread {
                    self.imageView.image = nil
                }
                return
            }
            cache.setObject(image, forKey: thumbnaiNSStr)
            DispatchQueue.mainThread {
                self.imageView.image = image
            }
        }
    }
    
    func resetView() {
        titleLabel.text = ""
        stockLabel.text = ""
        priceLabel.text = ""
        bargainLabel.text = ""
        imageView.image = nil
        bargainLabel.isHidden = false
        stockLabel.textColor = .systemGray
    }
}

class ListOpenMarketCollectionViewCell: UICollectionViewCell, ProductListCellable {
    let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
        label.text = "MAC mini"
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "USD 800"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    let bargainLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "USD 800"
        label.textColor = .systemRed
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stockLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.text = "잔여수량"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [bargainLabel, priceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
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
    
    let bottomSeparatorView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [imageView, totalLabelStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [contentStackView, bottomSeparatorView])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let padding: Double = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init didn't implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    func setupView() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.18),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}

class GridOpenMarketCollectionViewCell: UICollectionViewCell, ProductListCellable {
    let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
        label.text = "MAC mini"
        label.lineBreakMode = .byTruncatingTail
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "USD 800"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bargainLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "USD 800"
        label.textColor = .systemRed
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stockLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.text = "잔여수량"
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let layerBorderView: UIView = {
        let view: UIView = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let padding: Double = 8
    
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
        resetView()
    }
    
    func setupView() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(layerBorderView)
        layerBorderView.addSubview(stackView)
        NSLayoutConstraint.activate([
            layerBorderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            layerBorderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            layerBorderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            layerBorderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            
            stackView.leadingAnchor.constraint(equalTo: layerBorderView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: layerBorderView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: layerBorderView.bottomAnchor, constant: -padding),
            stackView.topAnchor.constraint(equalTo: layerBorderView.topAnchor, constant: padding),
            
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}

