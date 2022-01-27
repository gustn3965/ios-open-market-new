//
//  ListOpenMarketCollectionViewCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/27.
//

import UIKit

class ListProductListCollectionViewCell: UICollectionViewCell, ProductListCellable {
    // MARK: - Views
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
    
    private let chevronRightButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [bargainLabel, priceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleStockStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, stockLabel, chevronRightButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
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
    
    // MARK: - Init
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
    
    // MARK: - Setup View
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
