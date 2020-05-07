//
//  HomeViewController.swift
//  FileManagerVK
//
//  Created by Станислав on 22.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit
import QuickLook

class HomeViewController: UIViewController, QLPreviewControllerDelegate {
    
    var loadFiles = [FileModel]()
    var files = [FileModel]()
    let homeView = HomeTableView()
    let networkingService = NetworkingService()
    let sortManager = SortManager()
    var sortBy: TypeSorted = .name
    
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
        networkingService.loadFiles(onComplete: { [weak self] (loadFiles) in
            self?.loadFiles = loadFiles
            for i in 0..<loadFiles.count {
                self?.networkingService.downloadFile(loadFiles[i], isUserInitiated: false, completion: { (isComplete, destinationURL) in
                    if isComplete{
                        self?.loadFiles[i].destinationURL = destinationURL
                        self?.loadFiles[i].state = .loaded
                    }
                })
            }
            self?.loadFiles = self?.sortManager.sortedFor(files: self?.loadFiles, by: .name) ?? [FileModel]()
            self?.files = self?.loadFiles ?? [FileModel]()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.files[indexPath.row].destinationURL != nil else {
            return
        }
        //Попробовать через ReloadData
        let quickLookController = QLPreviewController()
        quickLookController.delegate = self
        quickLookController.dataSource = self
        quickLookController.currentPreviewItemIndex = indexPath.row
        self.navigationController?.pushViewController(quickLookController, animated: true)
        
    }
    
}
// MARK: - DataSourse
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.dequeueReusableCell(withIdentifier: FileTableViewCell.reusedID, for: indexPath) as! FileTableViewCell
        let file = files[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        cell.configureCell(for: file)
        return cell
    }
}
// MARK: - SearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if !searchBarIsEmpty{
            files = sortManager.filtredFor(files: loadFiles, searchText: searchController.searchBar.text!) ?? [FileModel]()     
        } else {
            files = loadFiles
        }
        homeView.reloadData()
    }
}
// MARK: - QLPreviewControllerDataSource
extension HomeViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        if let previewItem = files[index].destinationURL {
            return previewItem as QLPreviewItem
        }
        return NSURL(string: Bundle.main.resourcePath ?? "" + "/file") ?? NSURL() as QLPreviewItem
    }
}
// MARK: - HomeTableViewCellDelegate
extension HomeViewController: HomeTableViewCellDelegate {
    func loadFile(indexCell: Int) {
        print("Нажата кнопка загрузки")
        let cell = homeView.cellForRow(at: IndexPath(row: indexCell, section: 0)) as! FileTableViewCell
        
        files[indexCell].state = .loading
        cell.setImageLoadButton(for: files[indexCell])
       
        self.networkingService.downloadFile(files[indexCell], isUserInitiated: true) { (isComplete, destinationURL) in
            if isComplete {
                guard destinationURL != nil else {
                    return
                }
                self.files[indexCell].destinationURL = destinationURL
                self.files[indexCell].state = .loaded
                cell.setImageLoadButton(for: self.files[indexCell])
            }
        }
    }
}
// MARK: - HeaderControlsDelegate
extension HomeViewController: TableHeaderControlsDelegate{
    func selectSort() {
        let sortAlert = UIAlertController(title: "Сортировка по:", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        sortAlert.addAction(cancel)
        
        sortAlert.addAction(UIAlertAction(title: "Имя", style: .default, handler: { _ in
            self.homeView.header.sortButton.setTitle("Сортировка по имени", for: .normal)
            self.files = self.sortManager.sortedFor(files: self.files, by: .name) ?? [FileModel]()
            self.loadFiles = self.sortManager.sortedFor(files: self.loadFiles, by: .name) ?? [FileModel]()
            self.homeView.reloadData()
        }))
        sortAlert.addAction(UIAlertAction(title: "Дата", style: .default, handler: { _ in
            self.homeView.header.sortButton.setTitle("Сортировка по дате", for: .normal)
            self.files = self.sortManager.sortedFor(files: self.files, by: .date) ?? [FileModel]()
            self.loadFiles = self.sortManager.sortedFor(files: self.loadFiles, by: .date) ?? [FileModel]()
            self.homeView.reloadData()
        }))
        sortAlert.addAction(UIAlertAction(title: "Тип", style: .default, handler: { _ in
            self.homeView.header.sortButton.setTitle("Сортировка по типу", for: .normal)
            self.files = self.sortManager.sortedFor(files: self.files, by: .type) ?? [FileModel]()
            self.loadFiles = self.sortManager.sortedFor(files: self.loadFiles, by: .type) ?? [FileModel]()
            self.homeView.reloadData()
        }))
        sortAlert.pruneNegativeWidthConstraints()
        
        self.present(sortAlert, animated: true, completion: nil)
    }   
}

