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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        appLogic.getRepositories{ [weak self] (repos, error) in
            switch (repos, error) {
            case (let repos, nil):
                self?.loadDataSource(repos: repos!)
            case (nil, let error):
                print(error!)
                if error as? RepoErrors == RepoErrors.accessTokenIsMissing {
                    self?.exitAccount()
                }
            default:
                print("switch in in RepoList get default")
                return
            }
        }
    }
    
    // MARK: reloadView()
    func loadDataSource(repos: [Repo]) {
        self.activityIndicator.stopAnimating()
        self.repos = repos
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    // MARK: setView()
    func setView() {
        self.view.backgroundColor = .black
        self.navigationItem.hidesBackButton = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView?.backgroundColor = .black
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
        cell.selectionStyle = .none
        
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
        if let repoDetailVC = storyboard?.instantiateViewController(withIdentifier: "RepoDetailVC") as? RepositoryDetailInfoViewController {
            repoDetailVC.repo = repo
            self.navigationController?.pushViewController(repoDetailVC, animated: true)
        }
    }
    
    // MARK: exitAccount()
    @IBAction func exitButtonPushed(_ sender: Any) {
        print("user \(String(describing: KeyValueStorage.shared.userName)) quited account")

        KeyValueStorage.shared.authToken = nil
        KeyValueStorage.shared.userName = nil

        self.exitAccount()
    }
    
    func exitAccount() {
        if let authVC = storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthViewController {
            self.navigationController?.setViewControllers([authVC], animated: true)
        }
    }
}
