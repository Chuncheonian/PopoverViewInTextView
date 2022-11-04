//
//  ViewController.swift
//  PopoverViewInTextView
//
//  Created by Dongyoung Kwon on 2022/11/04.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("화면 이동", for: .normal)
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func handleButtonTapped() {
        let editVC = EditController()
        let navi = UINavigationController(rootViewController: editVC)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
}
