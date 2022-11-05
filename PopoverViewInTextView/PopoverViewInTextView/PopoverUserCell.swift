//
//  PopoverUserCell.swift
//  PopoverViewInTextView
//
//  Created by Dongyoung Kwon on 2022/11/05.
//

import UIKit

struct PopoverTableViewSection: Hashable {
    typealias Item = PopoverUserCellModel

    let items: [PopoverUserCellModel]
}

struct PopoverUserCellModel: Hashable {
    let name: String
    let group: String
}

final class PopoverUserCell: UITableViewCell {
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 24 / 2
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let groupLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray2
        return label
    }()
    
    // MARK: - life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopoverUserCell {
    func bind(with model: PopoverUserCellModel) {
        profileImageView.backgroundColor = .systemTeal
        nameLabel.text = model.name
        groupLabel.text = model.group
    }
}

// MARK: - action

extension PopoverUserCell {
    @objc
    private func profileImageViewTapped() {
        print(123)
    }
}

// MARK: - setup cell

extension PopoverUserCell {
    private func setUpUI() {
        setUpCell()
        setUpLayout()
    }
    
    private func setUpCell() {
        selectionStyle = .none
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    private func setUpLayout() {
        contentView.addSubview(containerStackView)
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        [profileImageView, nameLabel, groupLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
}
