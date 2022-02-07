//
//  ContentsPostProductCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//

import UIKit

class PostProductContentsCell: UICollectionViewCell {
    // MARK: - Views
    private lazy var titleTextField: UITextField = createTextField(text: "상품명")
    private lazy var priceTextField: UITextField = createTextField(text: "상품가격")
    private lazy var discountTextField: UITextField = createTextField(text: "할인금액")
    private lazy var stockTextField: UITextField = createTextField(text: "재고수량")
    
    private lazy var currencySegmentControl: UISegmentedControl = {
        let segmentControl: UISegmentedControl = UISegmentedControl(items: [NSString("KRW"), NSString("USD")])
        segmentControl.addTarget(self, action: #selector(segmentControlDidChanged(_:)), for: .valueChanged)
        segmentControl.selectedSegmentTintColor = .systemBackground
        segmentControl.backgroundColor = .systemGray4
        segmentControl.selectedSegmentIndex = 0
        segmentControl.layer.borderColor = UIColor.systemGray4.cgColor
        segmentControl.layer.borderWidth = 1
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [priceTextField,
                                                                    currencySegmentControl])
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [titleTextField,
                                                                    priceStackView,
                                                                    discountTextField,
                                                                    stockTextField])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    var didTouchTextFieldCompletion: (() -> Void)?
    var endTouchTextFieldCompletion: (() -> Void)?
    private let textFieldHeight: CGFloat = 30
    
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
            titleTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            priceTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            discountTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            stockTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        ])
        
        titleTextField.delegate = self
        priceTextField.delegate = self
        discountTextField.delegate = self
        stockTextField.delegate = self
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
        titleTextField.inputAccessoryView = keyboardToolBar
        priceTextField.inputAccessoryView = keyboardToolBar
        discountTextField.inputAccessoryView = keyboardToolBar
        stockTextField.inputAccessoryView = keyboardToolBar
    }

    @objc
    private func dismissKeyboard() {
        endEditing(true)
        endTouchTextFieldCompletion?()
    }
    
    @objc
    func segmentControlDidChanged(_ control: UISegmentedControl) {
        if control.selectedSegmentIndex == 0 {
            print()
        } else {
            print()
        }
    }
    
    private func createTextField(text: String) -> UITextField{
        let textField: UITextField = UITextField()
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.backgroundColor = .systemBackground
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 0.5
        textField.placeholder = text
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

// MARK: - TextField Delegate
extension PostProductContentsCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didTouchTextFieldCompletion?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
