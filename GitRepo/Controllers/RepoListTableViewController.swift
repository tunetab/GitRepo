//
//  RepoListTableViewController.swift
//  GitRepo
//
//  Created by Стажер on 01.03.2022.
//

import UIKit
import Alamofire

class RepositoriesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let appLogic = AppRepository()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var repos: [Repo]?
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        loadRepos()
    }
    
    // MARK: reloadView()
    func loadDataSource() {
        self.activityIndicator.stopAnimating()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: setView()
    func setView() {
        self.view.backgroundColor = .black
        self.tableView.backgroundColor = .black
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: loadRepos()
    func loadRepos() {
        appLogic.getRepositories{ [weak self] (repos, error) in
            switch (repos, error) {
            case (let repos, nil):
                if let repos = repos {
                    self?.repos = repos
                    self?.loadDataSource()
                } else {
                    print("repos missed in loadRepos() func")
                }
            case (nil, let error):
                if let error = error {
                    print(error)
                    if error as! RepoErrors == RepoErrors.accessTokenIsMissing {
                        self?.navigationController?.title = "Access Token is Invalid"
                    }
                }
            default:
                print("switch in loadRepos get default")
                return
            }
        }
    }

    // MARK: - Table view data source
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos?.count ?? 0
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.reuseIdentifier, for: indexPath)
        guard let cell = cell  as? RepoTableViewCell,
              let repo = repos?[indexPath.row] else { return cell }

        cell.updateCell(repo: repo)
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 1))
        separatorView.backgroundColor = UIColor(red: 33.0/255, green: 38.0/255, blue: 45.0/255, alpha: 1.0)
        cell.addSubview(separatorView)
        
        return cell
    }
    
    //MARK: Segues
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = repos?[indexPath.item]
        
        if let item = item {
            self.openRepo(repo: item)
        }
    }
    
    func openRepo(repo: Repo) {
        performSegue(withIdentifier: "goToRepo", sender: repo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "goToRepo",
              let repoDetailVC = segue.destination as? RepositoryDetailInfoViewController else { return }
        
        if let repo = sender as? Repo {
            repoDetailVC.repo = repo
        }
    }
    @IBAction func exitAccount(_ sender: Any) {
        print("user \(String(describing: KeyValueStorage.shared.userName)) quited account")

        KeyValueStorage.shared.authToken = nil
        KeyValueStorage.shared.userName = nil

        // TODO: jump to AuthController
    }
    
}
