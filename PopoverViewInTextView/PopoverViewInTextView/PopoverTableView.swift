//
//  FloatingView.swift
//  PopoverViewInTextView
//
//  Created by Dongyoung Kwon on 2022/11/04.
//

import UIKit

final class PopoverTableView: UIViewController {
    
    private var cellModels: [PopoverUserCellModel] = [
        .init(name: "권동영", group: "iOS팀"),
        .init(name: "김성준", group: "iOS팀"),
        .init(name: "김진형", group: "iOS팀"),
        .init(name: "김호연", group: "iOS팀"),
        .init(name: "박혜리", group: "iOS팀"),
        .init(name: "이상범", group: "iOS팀"),
        .init(name: "조유빈", group: "iOS팀"),
        .init(name: "김성진", group: "안드로이드팀"),
        .init(name: "이상경", group: "서버개발팀")
    ]
    
    // MARK: - ui componenty property
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.register(PopoverUserCell.self, forCellReuseIdentifier: String(describing: PopoverUserCell.self))
        return tableView
    }()
    
    private lazy var dataSource = dataSourceOf(tableView)
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        apply()
    }
}

extension PopoverTableView {
    private func apply() {
        var snapshot = NSDiffableDataSourceSnapshot<PopoverTableViewSection, PopoverTableViewSection.Item>()
        snapshot.appendSections([.init(items: cellModels)])
        snapshot.appendItems(cellModels)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PopoverTableView {
    private func dataSourceOf(
        _ tableView: UITableView
    ) -> UITableViewDiffableDataSource<PopoverTableViewSection, PopoverTableViewSection.Item> {
        .init(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PopoverUserCell.self), for: indexPath) as? PopoverUserCell
                
                // TODO: indexPath로 말고, 다른 걸로
                if indexPath.row == 0 {
                    cell?.backgroundColor = .systemGray6
                }
                
                cell?.bind(with: item)
                
                return cell
            }
        )
    }
}

// MARK: -  setup ui

extension PopoverTableView {
    private func setUpUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
        ])
    }
}

// MARK: - UITableViewDelegate

extension PopoverTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .systemGray6
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
    }
}
