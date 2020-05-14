//
//  SearchTableViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit


var myBooksArray = [Book]()


class SearchTableViewController: UITableViewController {

    
    @IBOutlet var searchBar: UISearchBar!
    
    // FIXME: change so cancel/x button act like they do in Goodreads/Apple Books?
    // FIXME: add swipe gesture to dismiss keyboard instead of having "Hide" button?
    
    let searchController = SearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.tintColor = .trinidadOrange
        setupToolBar()
    }
    
    // hi
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if searchBar.text == "" {
            searchBar.becomeFirstResponder()
        }
    }
    
    private func setupToolBar() {
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Hide",
                                   style: .plain,
                                   target: self,
                                   action: #selector(hideKeyboardAndCancelButton))
        done.tintColor = .trinidadOrange
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, done]
        bar.sizeToFit()
        searchBar.inputAccessoryView = bar
    }
    
    // FIXME: this should also be called inside searchBarSearchButtonClicked and searchClicked
    @objc private func hideKeyboardAndCancelButton() {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.searchResultBooks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // was 175 when we started
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }

        let book = searchController.searchResultBooks[indexPath.row]
        cell.book = book
        return cell
    }
    
    // MARK: - Navigation

    // FIXME: add segue that goes to BookDetailViewController?
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToDetail" {
            print("SearchToDetail")
            if let detailVC = segue.destination as? BookDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                // FIXME: pass in controller so user can add book to my books or other shelf
                detailVC.book = searchController.searchResultBooks[indexPath.row]
                let cell = tableView.cellForRow(at: indexPath) as? SearchResultTableViewCell
                detailVC.bookCoverImageView.image = cell?.mainView.imageView.image
                detailVC.blurredBackgroundView.image = cell?.mainView.imageView.image
            }
        }
    }

    // MARK: - Helpers
    
    private func searchByTerm(searchTerm: String) {
            // searchFuntion() then DispatchQueue.main.async {self.tableView.reloadData()}

//            SearchController.searchByTitle(title: searchTerm) { (response) in
//
//                switch response.result {
//
//                case .success(let data):
//                    print(data)
//                case .failure(let error):
//                    print(error)
//                }
//            }

//            let booksWithSearchTerm = fakeBooksArray.filter {
//                $0.title.lowercased().contains(searchTerm.lowercased()) || $0.author.lowercased().contains(searchTerm.lowercased())
//            }
//            myBooksArray = booksWithSearchTerm
            
        }
    
}

// MARK: - Extensions

extension SearchTableViewController: UISearchBarDelegate {

    // FIXME: - Scroll dismisses keyboard (onScroll?)
    // Search when typing each letter
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //searchBar.showsCancelButton = true
//        guard let searchTerm = searchBar.text else {
//            print("Empty searchbar")
//            return
//        }
//        print(searchTerm)
//        searchByTerm(searchTerm: searchTerm)
//        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchController.searchResultBooks = []
        tableView.reloadData() // FIXME: clear table another way?
        hideKeyboardAndCancelButton()
    }
    
    // dismiss keyboard so user can view all results
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {
            print("Empty searchbar")
            return
        }
        
        print("SearchButtonClicked (tapped return/search)")
        searchController.searchBook(with: searchTerm) { (error) in
            DispatchQueue.main.async {
                print("searchBook called in searchBarSearchButtonClicked")
                print("array count now: \(self.searchController.searchResultBooks.count)")
                self.tableView.reloadData()
            }
        }
        
        hideKeyboardAndCancelButton()
    }
}
