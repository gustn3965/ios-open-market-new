//
//  ContentsDescriptionPostProductCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//

import UIKit

class PostProductDescriptionCell: UICollectionViewCell {
    // MARK: - Views
    let textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = """
        Complaint that PorchCam can't pick up voices ssssssssccccc  speech when there's a loud
        """
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        textView.sizeToFit()
        textView.adjustsFontForContentSizeCategory = true
        return textView
    }()
    
    private let bottomLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [textView, bottomLineView])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    private var touchTextFieldCompletion: ((TextFieldTouchType) -> Void)?
    private var postProduct: PostProduct?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("didn't implemented")
    }
    
    // MARK: - Setup
    func setupView() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 0.5),
            bottomLineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    private func setupToolbar() {
        let keyboardToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        keyboardToolBar.barStyle = .default
        let successButton: UIButton = {
            let button: UIButton = UIButton()
            button.setTitle("완료", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
            return button
        }()
        let successBarButton: UIBarButtonItem = UIBarButtonItem(customView: successButton)
        keyboardToolBar.barTintColor = .systemGray4
        keyboardToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), successBarButton]
        keyboardToolBar.sizeToFit()
        textView.inputAccessoryView = keyboardToolBar
    }
    
    @objc
    private func dismissKeyboard(_ button: UIButton) {
        endEditing(true)
        touchTextFieldCompletion?(.endTouch)
    }
    
    func updateView(by postProduct: PostProduct,
                    textViewDelegate: PostProductDescriptionTextViewDelegate) {
        self.postProduct = postProduct
        textView.text = postProduct.descriptions
        textView.delegate = (textViewDelegate as? UITextViewDelegate)
        touchTextFieldCompletion = textViewDelegate.touchTextFieldCompletion
    }
}
