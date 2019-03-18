//
//  GiphyListViewController.swift
//  GiphyApp
//
//  Created by Marcis Nimants on 17/03/2019.
//  Copyright © 2019 Marcis Nimants. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift

class GiphyTableViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "giphyCell"
    private let showDetailViewSegueIdentifier = "showDetailView"
    private let viewModel = GiphyTableViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Gifs"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        tableView.dataSource = nil
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 50.0
        
        definesPresentationContext = true
        
        searchController
            .searchBar.rx.text
            .orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchTextObservable)
            .disposed(by: disposeBag)
        
        viewModel
            .gifItemsObservable
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { index, model, cell in
                let giphyTableViewCell = cell as! GiphyTableViewCell
                giphyTableViewCell.configureCell(with: model)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: showDetailViewSegueIdentifier, sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! GiphyTableViewCell

        guard let gif = cell.gif else { return }
    
        let giphyDetailViewController = segue.destination as! GiphyDetailViewController
        giphyDetailViewController.gif = gif
    }
}
