//
//  EditPrudctViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//
import UIKit

let secret: String = "xNE6fW$zqmK2A?Df"

enum TextFieldTouchType {
    case beginTouch
    case endTouch
}

enum BottomInset: CGFloat {
    case max = 250
    case min = 0
    
    var height: CGFloat {
        self.rawValue
    }
}

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
            case Section.contents.section, Section.description.section:
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
            default:
                fatalError("Section index out of range")
            }
        }
        return layout
    }()
    
    // MARK: - Properties
    private let product: Product?
    private var postProduct: PostProduct = PostProduct(secret: secret)
    private let postLoader: PostProductLoader = PostProductLoader()
    private lazy var postProductContentsTextFieldDelegate: PostProductContentsTextFieldDelegate = {
        PostProductContentsTextFieldDelegate(postProduct: postProduct)
    }()
    private lazy var postProductDescriptionTextViewDelegate: PostProductDescriptionTextViewDelegate = {
        PostProductDescriptionTextViewDelegate(postProduct: postProduct)
    }()
    
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
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.title = product == nil ? "상품등록" : "상품수정"
        let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(clickCancelButton))
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(clickPostButton))
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
    
    private func setupImagePicker() {
        imagePickerController.delegate = self
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
    // MARK: - Method
    @objc
    func clickCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func clickPostButton() {
        if !postLoader.isProductAllRequired(postProduct, images: selectImages) {
            showAlert(title: "아래 중 하나 이상이 없습니다", message: "(이름, 가격, 통화, 설명, secret)")
            return
        }
        
        postLoader.post(postProduct, images: selectImages) { result in
            switch result {
            case .success(_):
                print("Good")
            case .failure(let error):
                self.showAlert(title: error.localizedDescription)
            }
            DispatchQueue.mainThread {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showAlert(title: String?, message: String? = nil) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
}

// MARK: - Collection DataSource
extension PostProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectImages.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Section.image.section:
            guard let cell: PostProductImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostProductImageCell.identifier,
                                                                                      for: indexPath) as? PostProductImageCell else {
                return UICollectionViewCell() }
            cell.updateView(by: selectImages[indexPath.item])
            cell.touchImageViewCompletion = { [weak self] in
                guard let imagePicker: UIImagePickerController = self?.imagePickerController else { return }
                if self?.selectImages[indexPath.item] == nil {
                    self?.present(imagePicker, animated: true)
                } else if self?.isPlusImageEmpty == true {
                    self?.appendPlusImage()
                }
            }
            return cell
        case Section.contents.section:
            guard let cell: PostProductContentsCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostProductContentsCell.identifier,
                                                                                         for: indexPath) as? PostProductContentsCell else {
                return UICollectionViewCell() }
            cell.updateView(by: postProduct, delegate: postProductContentsTextFieldDelegate)
            postProductContentsTextFieldDelegate.touchTextFieldCompletion = { [weak self] touchType in
                switch touchType {
                case .beginTouch:
                    self?.setupCollectionViewBottomInset(height: BottomInset.max.height, indexPath: indexPath)
                case .endTouch:
                    self?.setupCollectionViewBottomInset(height: BottomInset.min.height, indexPath: indexPath)
                }
            }
            return cell
        case Section.description.section:
            guard let cell: PostProductDescriptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostProductDescriptionCell.identifier, for: indexPath) as? PostProductDescriptionCell else {
                return UICollectionViewCell() }
            postProductDescriptionTextViewDelegate.touchTextFieldCompletion = { [weak self] touchType in
                switch touchType {
                case .beginTouch:
                    self?.setupCollectionViewBottomInset(height: BottomInset.max.height, indexPath: indexPath)
                case .endTouch:
                    self?.setupCollectionViewBottomInset(height: BottomInset.min.height, indexPath: indexPath)
                }
            }
            cell.updateView(by: postProduct,
                            textViewDelegate: postProductDescriptionTextViewDelegate)
            
            return cell
        default:
            fatalError("Section index out of range")
        }
    }
    
    private func appendPlusImage() {
        selectImages.append(nil)
        collectionView.reloadSections(IndexSet(integer: Section.image.section))
    }
    
    private var isPlusImageEmpty: Bool {
        selectImages.filter({ $0 == nil }).isEmpty
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
        
        print(image.jpegData(compressionQuality: 1.0)?.count)
        selectImages.removeLast()
        selectImages.append(image)
        collectionView.reloadSections(IndexSet(integer: Section.image.section))
    }
}

