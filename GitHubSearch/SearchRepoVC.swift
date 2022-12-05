//
//  ViewController.swift
//  GitHubSearch
//
//  Created by Wilson Garcia on 12/1/22.
//

import UIKit
import WebKit

class SearchRepoVC: UIViewController {

    fileprivate var repositories: [Repository] = [] {
        didSet {
            self.repoTableView.reloadData()
        }
    }
    var timer: Timer?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var repoTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
    }
}

extension SearchRepoVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = repositories[indexPath.row].fullName
        if let language = repositories[indexPath.row].language {
            cell.detailTextLabel?.text = language
        }
        return cell
    }
}

extension SearchRepoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let sb = self.storyboard else { return }
        let vc = sb.instantiateViewController(withIdentifier: "RepoPageVC") as! RepoPageVC
        vc.url = repositories[indexPath.row].htmlUrl
        vc.title = repositories[indexPath.row].fullName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchRepoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.search), userInfo: nil, repeats: false)
    }

    @objc func search() {
        self.repositories.removeAll()
        guard let query = self.searchBar.text else { return }
        if query == "" { return }
        self.activityIndicator.startAnimating()
        SearchRepository(query: query).request { (result) in
            switch result {
                
            case .success(let response):
                DispatchQueue.main.async {
                    self.repositories.append(contentsOf: response.items)
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

