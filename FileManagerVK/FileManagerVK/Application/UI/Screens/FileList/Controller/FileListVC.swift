//
//  FileListVC.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit
import QuickLook

final class FileListVC<View: FileListViewImpl>: BaseViewController<View>, QLPreviewControllerDelegate, QLPreviewControllerDataSource, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, HomeTableViewCellDelegate, TableHeaderControlsDelegate {
    
    private var loadFiles = [FileModel]()
    private var files = [FileModel]()
    private let networkingService: NetworkingService
    private let sortManager: SortManager
    private var sortBy: TypeSorted = .name
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    
    init(networkingService: NetworkingService, sortManager: SortManager) {
        self.networkingService = networkingService
        self.sortManager = sortManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Files"
        
        loadData()

        rootView.delegate = self
        rootView.dataSource = self
        rootView.header.delegate = self
        setSearchController()
    }
    
    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "Searchbar placeholder")
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
            self?.rootView.reloadData()
        }, onError: { (error) in
            print(error)
        })
    }
    
    func edit(file: FileModel){
        let alert = UIAlertController(
            title: NSLocalizedString("Exchange", comment: "Exchange"),
            message: NSLocalizedString("Enter new name to file", comment: "Enter new name to file Alert massage"),
            preferredStyle: .alert
        )
        
        alert.addTextField { (textField) in
            textField.text = "\(file.title)"
        }
        
        let cancel = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "Cancel"),
            style: .cancel,
            handler: nil
        )
        alert.addAction(cancel)
        
        let ok = UIAlertAction(
            title: NSLocalizedString("Accept", comment: "Accept"),
            style: .default,
            handler: { [weak alert] (_) in
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
        let alert = UIAlertController(
            title: NSLocalizedString("Delete", comment: "Delete title Allert"),
            message: NSLocalizedString("Want to delete", comment: "Want to delete? Allert") + "\(file.title)?",
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "Cancel title Allert"),
            style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(
            title: NSLocalizedString("OK", comment: "OK - accept"),
            style: .default,
            handler: { (_) in
                self.networkingService.deleteFile(file: file, onComplete: { [weak self] in
                    self?.files.remove(at: indexPath.row)
                    self?.rootView.deleteRows(at: [indexPath], with: .automatic)
                }) { (error) in
                    print(error)
                }
        })
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableViewDelegate
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
        
        let quickLookController = QLPreviewController()
        quickLookController.delegate = self
        quickLookController.dataSource = self
        quickLookController.currentPreviewItemIndex = indexPath.row
        self.navigationController?.pushViewController(quickLookController, animated: true)
        
    }
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rootView.dequeueReusableCell(withIdentifier: FileTableViewCell.reusedID, for: indexPath) as! FileTableViewCell
        let file = files[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        cell.configureCell(for: file)
        return cell
    }
    
    // MARK: - SearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if !searchBarIsEmpty{
            files = sortManager.filtredFor(files: loadFiles, searchText: searchController.searchBar.text!) ?? [FileModel]()
        } else {
            files = loadFiles
        }
        rootView.reloadData()
    }
    
    // MARK: - QLPreviewControllerDataSource
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        if let previewItem = files[index].destinationURL {
            return previewItem as QLPreviewItem
        }
        return NSURL(string: Bundle.main.resourcePath ?? "" + "/file") ?? NSURL() as QLPreviewItem
    }
    
    // MARK: - HomeTableViewCellDelegate
    func loadFile(indexCell: Int) {
        let cell = rootView.cellForRow(at: IndexPath(row: indexCell, section: 0)) as! FileTableViewCell
        
        files[indexCell].state = .loading
        cell.setImageLoadButton(for: files[indexCell])
       
        self.networkingService.downloadFile(files[indexCell], isUserInitiated: true) { (isComplete, destinationURL) in
            guard isComplete, destinationURL != nil else {
                return
            }
            
            self.files[indexCell].destinationURL = destinationURL
            self.files[indexCell].state = .loaded
            cell.setImageLoadButton(for: self.files[indexCell])
        }
    }
    
    // MARK: - HeaderControlsDelegate
    func selectSort() {
        let sortAlert = UIAlertController(
            title: NSLocalizedString("Sorted by:", comment: "Sorted by: - alert title"),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cancel = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "Cancel"),
            style: .cancel,
            handler: nil
        )
        
        sortAlert.addAction(cancel)
        
        sortAlert.addAction(UIAlertAction(
            title: NSLocalizedString("Name", comment: "Name"),
            style: .default,
            handler: { _ in
                self.rootView.header.sortButton.setTitle(
                    NSLocalizedString("TableHeaderView.sortButton.name", comment: "Table title sorted by name"),
                    for: .normal
                )
                
                self.files = self.sortManager.sortedFor(files: self.files, by: .name) ?? [FileModel]()
                self.loadFiles = self.sortManager.sortedFor(files: self.loadFiles, by: .name) ?? [FileModel]()
                self.rootView.reloadData()
        }))
        
        sortAlert.addAction(UIAlertAction(
            title: NSLocalizedString("Date", comment: "Date alert button"),
            style: .default,
            handler: { _ in
                self.rootView.header.sortButton.setTitle(
                    NSLocalizedString("TableHeaderView.sortButton.date", comment: "Table title sorted by date"),
                    for: .normal
                )
                
                self.files = self.sortManager.sortedFor(files: self.files, by: .date) ?? [FileModel]()
                self.loadFiles = self.sortManager.sortedFor(files: self.loadFiles, by: .date) ?? [FileModel]()
                self.rootView.reloadData()
        }))
        
        sortAlert.addAction(UIAlertAction(
            title: NSLocalizedString("Type", comment: "Type alert button"),
            style: .default,
            handler: { [weak self] _ in
                self?.rootView.header.sortButton.setTitle(
                    NSLocalizedString("TableHeaderView.sortButton.type", comment: "Table title sorted by type"),
                    for: .normal
                )
                
                self?.files = self?.sortManager.sortedFor(files: self?.files, by: .type) ?? [FileModel]()
                self?.loadFiles = self?.sortManager.sortedFor(files: self?.loadFiles, by: .type) ?? [FileModel]()
                self?.rootView.reloadData()
        }))
        
        sortAlert.pruneNegativeWidthConstraints()
        
        self.present(sortAlert, animated: true, completion: nil)
    }
}
