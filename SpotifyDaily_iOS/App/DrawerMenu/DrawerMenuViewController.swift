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
    
    private var selectedRow: Int = 1
    private let disposeBag = DisposeBag()
    
    private lazy var tableView = UITableView.tableView
    
    private lazy var appLabel = UILabel.appLabel
    private lazy var appLogo = UIImageView.appLogo
    
    var viewModel: DrawerMenuViewModel? {
        didSet {
            self.selectedRow = 1
            self.setUpBindings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    deinit {
        Logger.info("DrawerMenuViewController dellocated")
    }
    
    private func setUpView(){
        self.view.backgroundColor = ColorPreference.secondaryColor
        
        self.view.addSubview(self.appLabel)
        self.view.addSubview(self.appLogo)
        self.view.addSubview(self.tableView)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        self.appLogo.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16).isActive = true
        self.appLogo.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 2).isActive = true
        
        self.appLabel.leadingAnchor.constraint(equalTo: appLogo.trailingAnchor, constant: 12).isActive = true
        self.appLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 16).isActive = true
        
        self.tableView.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 30).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    }
    
    private func setUpBindings() {
        guard let viewModel = self.viewModel else { return }
        
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        viewModel.menuItems
            .bind(to: tableView.rx.items(cellIdentifier: "menuCell", cellType: UITableViewCell.self)) { [weak self] row, model, cell in
                cell.selectionStyle = .none
                cell.textLabel?.font = UIFont(helveticaStyle: .light, size: 20)
                cell.textLabel?.text = model.uppercased()
                cell.textLabel?.textColor = self?.selectedRow == row ? ColorPreference.tertiaryColor : ColorPreference.tertiaryColor
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
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }
}

extension UILabel {
    static var appLabel: UILabel {
        let label = UILabel()
        label.text = "Spotify Daily"
        label.font = UIFont(helveticaStyle: .bold, size: 30)
        label.textColor = ColorPreference.tertiaryColor
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}

extension UIImageView {
    static var appLogo: UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let image = UIImage(named: "logo")
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
}
