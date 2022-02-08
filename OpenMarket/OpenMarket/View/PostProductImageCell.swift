//
//  PostProductImageCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//

import UIKit

class PostProductImageCell: UICollectionViewCell {
    // MARK: - Views
    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAddImage)))
        return imageView
    }()
    
    private let addButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemBlue
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    var touchImageViewCompletion: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError(#function)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        touchImageViewCompletion = nil
        backgroundColor = .systemGray4
        addButton.isHidden = false
        imageView.image = nil 
    }
    
    // MARK: - Setup
    func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(addButton)
        backgroundColor = .systemGray4
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc
    func clickAddImage() {
        touchImageViewCompletion?()
    }
    
    func updateView(by image: UIImage?) {
        if image != nil {
            backgroundColor = .systemBackground
            addButton.isHidden = true
        }
        imageView.image = image
    }
}
