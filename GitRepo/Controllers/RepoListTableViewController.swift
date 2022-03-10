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
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIImageView!
    @IBOutlet weak var emptyListView: UIView!
    @IBOutlet weak var connectionErrorView: UIView!
    
    var repos: [Repo]?
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadRepoList()
    }
    
    // MARK: loadRepoList()
    private func loadRepoList() {
        tableView.isHidden = true
        emptyListView.isHidden = true
        connectionErrorView.isHidden = true
        activityIndicator.rotate()
        activityIndicator.isHidden = false
        
        appLogic.getRepositories{ [weak self] (repos, error) in
            switch (repos, error) {
            case (let repos, nil):
                self?.setContentView(repos: repos!)
            case (nil, let error):
                print(error!)
                guard error as? RepoErrors == RepoErrors.accessTokenIsMissing else {
                    self?.exitAccount()
                    return
                }
                self?.connectionErrorView.isHidden = false
            default:
                print("switch in in RepoList get default")
                self?.emptyListView.isHidden = false
                return
            }
        }
    }
    
    // MARK: setView()
    private func setView() {
        self.view.backgroundColor = .black
        self.navigationItem.hidesBackButton = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView?.backgroundColor = .black
    }
    
    // MARK: setContentView()
    private func setContentView(repos: [Repo]) {
        self.activityIndicator.isHidden = true
        self.repos = repos
        self.tableView.isHidden = false
        self.tableView.reloadData()
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
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = repos?[indexPath.item]
        if let item = item {
            self.openRepo(repo: item)
        }
    }
    
    private func openRepo(repo: Repo) {
        if let repoDetailVC = storyboard?.instantiateViewController(withIdentifier: "RepoDetailVC") as? RepositoryDetailInfoViewController {
            repoDetailVC.repo = repo
            self.navigationController?.pushViewController(repoDetailVC, animated: true)
        }
    }
    
    // MARK: Buttons
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.loadRepoList()
    }
    
    // MARK: exitAccount()
    @IBAction private func exitButtonPushed(_ sender: Any) {
        print("user \(String(describing: KeyValueStorage.shared.userName)) quited account")

        KeyValueStorage.shared.authToken = nil
        KeyValueStorage.shared.userName = nil

        self.exitAccount()
    }
    
    private func exitAccount() {
        if let authVC = storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthViewController {
            self.navigationController?.setViewControllers([authVC], animated: true)
        }
    }
}
