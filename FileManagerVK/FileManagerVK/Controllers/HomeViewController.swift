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
    let homeView = HomeTableView()
    let networkingService = NetworkingService()
    
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
        
        loadData()
        
        homeView.delegate = self
        homeView.dataSource = self
        homeView.header.delegate = self
        setSearchController()
        view = homeView
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
    func loadData() {
        networkingService.loadFiles(onComplete: { [weak self] (files) in
            self?.files = files
            self?.homeView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    func edit(file: FileModel){
        let alert = UIAlertController(title: "Изменить", message: "Введите новое имя файла", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "\(file.title)"
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "Подтвердить", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields?[0]
            guard let newName = textField?.text else {return}
            self.networkingService.editFile(id: file.id, newName: newName, onComplete: { [weak self] in
                self?.loadData()
            }) { (error) in
                print(error)
            }
        })
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete(file: FileModel, indexPath: IndexPath){
        let alert = UIAlertController(title: "Удаление", message: "Удалить \(file.title)?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "Да", style: .default, handler: { (_) in
            self.networkingService.deleteFile(file: file, onComplete: { [weak self] in
                self?.files.remove(at: indexPath.row)
                self?.homeView.deleteRows(at: [indexPath], with: .automatic)
            }) { (error) in
                print(error)
            }
        })
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate {
    //SwipeActions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let file = self.files[indexPath.row]
            self.delete(file: file, indexPath: indexPath)
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
            let file = self.files[indexPath.row]
            self.edit(file: file)
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
// MARK: -DataSourse
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.dequeueReusableCell(withIdentifier: FileTableViewCell.reusedID, for: indexPath) as! FileTableViewCell
        let file = files[indexPath.row]
        cell.configureCell(for: file)
        return cell
    }
}
// MARK: -SearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
// MARK: -HeaderControlsDelegate
extension HomeViewController: TableHeaderControlsDelegate{
    func selectSort() {
        let sortAlert = UIAlertController(title: "Сортировка по:", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        sortAlert.addAction(cancel)
        
        sortAlert.addAction(UIAlertAction(title: "Имя", style: .default, handler: { _ in
            self.homeView.header.sortButton.setTitle("Сортировка по имени", for: .normal)
        }))
        sortAlert.addAction(UIAlertAction(title: "Дата", style: .default, handler: { _ in
            self.homeView.header.sortButton.setTitle("Сортировка по дате", for: .normal)
        }))
        sortAlert.addAction(UIAlertAction(title: "Тип", style: .default, handler: { _ in
            self.homeView.header.sortButton.setTitle("Сортировка по типу", for: .normal)
        }))
        sortAlert.pruneNegativeWidthConstraints()
        
        self.present(sortAlert, animated: true, completion: nil)
    }   
}

