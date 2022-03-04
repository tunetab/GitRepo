//
//  RepoListTableViewController.swift
//  GitRepo
//
//  Created by Стажер on 01.03.2022.
//

import UIKit
import Alamofire

class RepositoriesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var repos: [Repo]?
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        updateView()
    }
    func updateView() {
        
        self.navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = .black
        self.tableView.backgroundColor = .black
        self.navigationItem.hidesBackButton = true
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
        print("user \(KeyValueStorage.shared.userName) quited account")
        print(KeyValueStorage.shared.userName)
        KeyValueStorage.shared.authToken = nil
        KeyValueStorage.shared.userName = nil
        print(KeyValueStorage.shared.userName)
        navigationController?.popViewController(animated: true)
    }
    
}
