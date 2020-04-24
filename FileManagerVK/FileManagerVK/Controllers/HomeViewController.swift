//
//  HomeViewController.swift
//  FileManagerVK
//
//  Created by Станислав on 22.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var files = [FileModel]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        title = "Files"
        
        view = HomeTableView()
        view().delegate = self
        view().dataSource = self
        view().header.delegate = self
        setSearchController()
    }
    
    func view() -> HomeTableView {
        return self.view as! HomeTableView
    }
    
    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.isHidden = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
//            self.files.remove(at: indexPath.row)
            self.view().deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        if #available(iOS 13.0, *) {
            action.image = UIImage(systemName: "trash.fill")
        } else {
            // Fallback on earlier versions
            action.title = "Del"
        }
        return action
    }
    func editAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
//                self.files[indexPath.row].title
                completion(true)
            }
            action.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            if #available(iOS 13.0, *) {
                action.image = UIImage(systemName: "square.and.pencil")
            } else {
                // Fallback on earlier versions
                action.title = "Edit"
            }
            return action
        }
    
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = view().dequeueReusableCell(withIdentifier: HomeTableViewCell.reusedID, for: indexPath) as! HomeTableViewCell
        return cell
    }
}
extension HomeViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
extension HomeViewController: TableHeaderControlsDelegate{
    func selectSort() {
        let sortAlert = UIAlertController(title: "Сортировка по:", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        sortAlert.addAction(cancel)
        
        sortAlert.addAction(UIAlertAction(title: "Имя", style: .default, handler: { _ in
            self.view().header.sortButton.setTitle("Сортировка по имени", for: .normal)
        }))
        sortAlert.addAction(UIAlertAction(title: "Дата", style: .default, handler: { _ in
            self.view().header.sortButton.setTitle("Сортировка по дате", for: .normal)
        }))
        sortAlert.addAction(UIAlertAction(title: "Тип", style: .default, handler: { _ in
            self.view().header.sortButton.setTitle("Сортировка по типу", for: .normal)
        }))
        sortAlert.pruneNegativeWidthConstraints()
        
        self.present(sortAlert, animated: false, completion: nil)
    }
    
    
}
extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
