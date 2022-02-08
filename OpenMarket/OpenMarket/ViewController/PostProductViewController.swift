//
//  EditPrudctViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//
import UIKit

class PostProductViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case image, contents, description
        
        var section: Int {
            self.rawValue
        }
    }
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PostProductImageCell.self, forCellWithReuseIdentifier: PostProductImageCell.identifier)
        collectionView.register(PostProductContentsCell.self, forCellWithReuseIdentifier: PostProductContentsCell.identifier)
        collectionView.register(PostProductDescriptionCell.self, forCellWithReuseIdentifier: PostProductDescriptionCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    private let compositionLayout: UICollectionViewCompositionalLayout = {
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _ : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let padding: CGFloat = 16
            switch sectionIndex {
            case Section.image.section:
                let imagePadding: CGFloat = 4.0
                let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0),
                                                                              heightDimension: .fractionalHeight(1.0))
                let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(300),
                                                                               heightDimension: .fractionalWidth(0.3))
                let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: imagePadding, leading: imagePadding, bottom: imagePadding, trailing: imagePadding)
                let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                                        subitems: [item])
                let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: imagePadding + padding, bottom: 0, trailing: imagePadding + padding)
                return section
            default:
                var itemSize: NSCollectionLayoutSize
                if sectionIndex == Section.contents.section {
                    itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(150))
                } else {
                    itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                }
                let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                               heightDimension: .estimated(400))
                let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                                        subitems: [item])
                let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
                return section
            }
        }
        return layout
    }()
    
    // MARK: - Properties
    private let product: Product?
    var selectImages: [UIImage?] = [nil]
    
    // MARK: - Init
    init(product: Product? = nil) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard didn't implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupCollectionView()
        setupImagePicker()
        
        let product: PostProduct = PostProduct(name: "vapor",
                                               amount: 500,
                                               currency: "KRW",
                                               secret: "xNE6fW$zqmK2A?Df",
                                               descriptions: "안녕하세요 테스트에요",
                                               price: 123456)
        let image: [UIImage?] = [UIImage(systemName: "plus"),
                                 UIImage(systemName: "plus")]
        PostProductLoader().postProduct(product, images: image) { result in
            switch result {
            case .success(let product):
                print(product.identifier)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.title = product == nil ? "상품등록" : "상품수정"
        let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPosting))
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePosting))
        navigationItem.setRightBarButton(doneButton, animated: true)
        navigationItem.setLeftBarButton(cancelButton, animated: true)
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
    
    private func setupCollectionViewBottomInset(height: CGFloat,
                                                indexPath: IndexPath) {
        DispatchQueue.mainThread {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear) {
                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
                self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            } completion: { _ in
                if height == 0 { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    private func setupImagePicker() {
        imagePickerController.delegate = self
    }
    
    @objc
    func cancelPosting() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func donePosting() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Collection DataSource
extension PostProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Section.image.section:
            guard let cell: PostProductImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostProductImageCell.identifier, for: indexPath) as? PostProductImageCell else {
                return UICollectionViewCell() }
            cell.addImageCompletion = { [weak self] in
                guard self?.selectImages[indexPath.item] == nil,
                      let imagePicker: UIImagePickerController = self?.imagePickerController else {
                          if self?.selectImages.filter({ $0 == nil }).isEmpty == false { return }
                          self?.selectImages.append(nil)
                          self?.collectionView.reloadSections(IndexSet(integer: Section.image.section))
                          return
                      }
                self?.present(imagePicker, animated: true)
            }
            cell.updateView(by: selectImages[indexPath.item])
            return cell
        case Section.contents.section:
            guard let cell: PostProductContentsCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostProductContentsCell.identifier, for: indexPath) as? PostProductContentsCell else {
                return UICollectionViewCell() }
            cell.didTouchTextFieldCompletion = { [weak self] in
                self?.setupCollectionViewBottomInset(height: 200, indexPath: indexPath)
            }
            cell.endTouchTextFieldCompletion = { [weak self] in
                self?.setupCollectionViewBottomInset(height: 0, indexPath: indexPath)
            }
            return cell
        case Section.description.section:
            guard let cell: PostProductDescriptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostProductDescriptionCell.identifier, for: indexPath) as? PostProductDescriptionCell else {
                return UICollectionViewCell() }
            cell.didTouchTextFieldCompletion = { [weak self] in
                self?.setupCollectionViewBottomInset(height: 200, indexPath: indexPath)
            }
            cell.endTouchTextFieldCompletion = { [weak self] in
                self?.setupCollectionViewBottomInset(height: 0, indexPath: indexPath)
            }
            return cell
        default:
            fatalError(#function)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectImages.count
        } else {
            return 1
        }
    }
}

extension PostProductViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image: UIImage = info[.editedImage] as? UIImage else {
            print("\(#function): No edited image were found.")
            return
        }
        selectImages.removeLast()
        selectImages.append(image)
        collectionView.reloadSections(IndexSet(integer: Section.image.section))
    }
}

