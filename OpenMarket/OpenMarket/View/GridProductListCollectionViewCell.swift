//
//  GridOpenMarketCollectionViewCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/27.
//

import UIKit

class GridProductListCollectionViewCell: UICollectionViewCell, ProductListCellable {
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
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            bargainLabel.heightAnchor.constraint(equalTo: priceLabel.heightAnchor)
        ])
    }
}
