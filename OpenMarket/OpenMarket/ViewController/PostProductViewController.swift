//
//  EditPrudctViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//
import UIKit

class PostProductViewController: UIViewController {
    private let product: Product?
    
    init(product: Product? = nil) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard didn't implemented")
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.title = product == nil ? "상품등록" : "상품수정"
        let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPosting))
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePosting))
        navigationItem.setRightBarButton(doneButton, animated: true)
        navigationItem.setLeftBarButton(cancelButton, animated: true)
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
