//
//  DrawerMenuViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DrawerMenuViewController: UIViewController {
    
    private var selectedRow: Int = 0
    private let disposeBag = DisposeBag()
    
    private lazy var tableView = UITableView.tableView
    
    private lazy var appLabel = UILabel.appLabel
    
    var viewModel: DrawerMenuViewModel? {
        didSet {
            self.setUpBindings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    private func setUpView(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.appLabel)
        self.view.addSubview(self.tableView)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        self.appLabel.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        self.appLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 16).isActive = true
        
        self.tableView.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 30).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    }
    
    private func setUpBindings() {
        guard let viewModel = self.viewModel else { return }
        
        self.selectedRow = 0
        
        viewModel.menuItems
            .bind(to: tableView.rx.items(cellIdentifier: "menuCell", cellType: UITableViewCell.self)) { [weak self] row, model, cell in
                Logger.info("Called")
                cell.selectionStyle = .none
                cell.textLabel?.text = model.uppercased()
                cell.textLabel?.textColor = self?.selectedRow == row ? .white : .darkGray
                cell.backgroundColor = self?.selectedRow == row
                    ? ColorPreference.mainColor
                    : UIColor.clear
            }
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                
                self.selectedRow = indexPath.row
                self.tableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.dismiss(animated: true) {
                        let selectedScreen = DrawerMenuScreen(rawValue: indexPath.row) ?? .dashboard
                        viewModel.didSelectScreen.onNext(selectedScreen)
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        self.tableView.reloadData()
    }
}

extension UITableView {
    static var tableView: UITableView {
        Logger.info("Tableview")
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }
}

extension UILabel {
    static var appLabel: UILabel {
        let label = UILabel()
        label.text = "Spotify Daily"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        Logger.info("App label")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
