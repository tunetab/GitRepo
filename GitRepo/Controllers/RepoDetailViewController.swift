//
//  RepoDetailViewController.swift
//  GitRepo
//
//  Created by Стажер on 03.03.2022.
//

import UIKit

class RepositoryDetailInfoViewController: UIViewController {

    let appLogic = AppRepository()

    var repo: Repo?
    private var repoDetails: RepoDetails?
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var linkButton: UIButton!
    @IBOutlet private var licenseLabel: UILabel!
    @IBOutlet private var starsLabel: UILabel!
    @IBOutlet private var forksLabel: UILabel!
    @IBOutlet private var watchersLabel: UILabel!
    @IBOutlet private var readmeLabel: UILabel!
    
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        guard let repo = repo else {
            print("RepoId is Missing")
            return
        }
        
        appLogic.getRepository(repoId: repo.name) { [weak self] (repoDetail, error) in
            switch (repoDetail, error) {
            case (let repo, nil):
                self?.reloadView(repo: repo!)
            case (nil, let error):
                print(error!)
                if error as? RepoErrors == RepoErrors.accessTokenIsMissing {
                    self?.exitAccount()
                }
            default:
                print("switch in RepoDetails get default")
                return
            }
        }
        appLogic.getRepositoryReadme(ownerName: repo.owner.username, repositoryName: repo.name, branchName: "") { [weak self] (readme, error) in
            switch (readme, error) {
            case (let content, nil):
                self?.readmeLabel.text = content?.base64Decoded()
            case (nil, let error):
                print(error!)
                
            default:
                print("switch in RepoDetails get default")
                return
            }
        }
    }
    
    //MARK: reloadView()
    func reloadView(repo: RepoDetails) {
        self.activityIndicator.stopAnimating()
        self.repoDetails = repo
        self.scrollView.isHidden = false
        self.fillContentView()
    }
    
    // MARK: setView()
    func setView() {
        self.navigationItem.title = repo?.name ?? "Repo not found"
        view.backgroundColor = .black
    }
    
    // MARK: fillContentView()
    func fillContentView() {
        guard let repoDetails = self.repoDetails else {
            print("details missed")
            return
        }
        linkButton.setTitle(repoDetails.html_url.getRidOfProtocol(), for: .normal)
        linkButton.setTitleColor(UIColor(red: 88.0/255, green: 166.0/255, blue: 255.0/255, alpha: 1.0), for: .normal)
        
        licenseLabel.text = repoDetails.license?.name ?? "Unlicensed"
        starsLabel.text = String(repoDetails.stargazers_count)
        forksLabel.text = String(repoDetails.forks_count)
        watchersLabel.text = String(repoDetails.watchers_count)
        
    }
    // MARK: followLink()
    @IBAction func followLink(_ sender: Any) {
        let url = URL(string: self.repoDetails?.html_url ?? "https://apple.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
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
