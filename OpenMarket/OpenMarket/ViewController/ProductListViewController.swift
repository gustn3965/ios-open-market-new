//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductListViewController: UIViewController {
    // MARK: - Views
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
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ListProductListCollectionViewCell.self,
                                forCellWithReuseIdentifier: ListProductListCollectionViewCell.identifier)
        collectionView.register(GridProductListCollectionViewCell.self,
                                forCellWithReuseIdentifier: GridProductListCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Properties
    private var productList: [Product] = []
    private var productListImageCache: NSCache = NSCache<NSString, UIImage>()
    private var controlIndex: Int {
        segmentControl.selectedSegmentIndex
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupIndicatorView()
        view.backgroundColor = .systemBackground
        fetchProductList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProductList()
    }
    
    // MARK: - Setup View
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
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = segmentControl
        let addBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPostButton))
        navigationItem.setRightBarButton(addBarButton, animated: true)
    }
    
    // MARK: - Method
    @objc
    func addPostButton() {
        let postProductViewController: PostProductViewController = PostProductViewController()
        navigationController?.pushViewController(postProductViewController, animated: true)
    }
    
    @objc
    func segmentControlDidChanged(_ control: UISegmentedControl) {
        changeFlowLayout(controlIndex: control.selectedSegmentIndex)
    }
    
    private func changeFlowLayout(controlIndex: Int) {
        if controlIndex == 0 {
            flowLayout.itemSize = listCollectionItemSize
            collectionView.collectionViewLayout = flowLayout
        } else {
            flowLayout.itemSize = gridCollectionItemSize
            collectionView.collectionViewLayout = flowLayout
        }
        collectionView.reloadData()
    }
    
    func fetchProductList() {
        indicatorView.startAnimating()
        ProductListLoader().getProductList(pageNumber: 1, itemsPerPage: 20) { result in
            self.productListImageCache.removeAllObjects()
            switch result {
            case .success(let productList):
                self.productList = productList.pages ?? []
            case .failure(let error):
                self.productList = []
                print(error)
            }
            DispatchQueue.mainThread {
                self.indicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - CollectionView Data Source
extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var productListCell: ProductListCellable
        if controlIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListProductListCollectionViewCell.identifier, for: indexPath) as? ListProductListCollectionViewCell else {
                return UICollectionViewCell()
            }
            productListCell = cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridProductListCollectionViewCell.identifier, for: indexPath) as? GridProductListCollectionViewCell else {
                return UICollectionViewCell()
            }
            productListCell = cell
        }
        
        productListCell.updateView(by: productList[indexPath.item],
                                   cache: productListImageCache)
        return productListCell
    }
}
