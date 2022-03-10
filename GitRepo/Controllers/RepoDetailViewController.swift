//
//  RepoDetailViewController.swift
//  GitRepo
//
//  Created by Стажер on 03.03.2022.
//

import UIKit
import MarkdownKit

class RepositoryDetailInfoViewController: UIViewController {

    let appLogic = AppRepository()

    var repo: Repo?
    private var repoDetails: RepoDetails?
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var connectionErrorView: UIView!
    @IBOutlet private var loadErrorView: UIView!
    
    @IBOutlet private var activityIndicator: UIImageView!
    
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
    
    // MARK: viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadRepoDetail()
        loadReadme()
    }
    
    // MARK: setView()
    private func setView() {
        self.navigationItem.title = repo?.name ?? "Repo lost"
        view.backgroundColor = .black
    }
    
    // MARK: loadRepoDetail()
    private func loadRepoDetail(){
        self.scrollView.isHidden = true
        self.connectionErrorView.isHidden = true
        self.loadErrorView.isHidden = true
        self.readmeLabel.isHidden = true
        
        guard let repo = repo else {
            print("RepoId is Missing")
            return
        }
        appLogic.getRepository(repoId: repo.name) { [weak self] (repoDetail, error) in
            switch (repoDetail, error) {
            case (let repo, nil):
                self?.setContentView(repo: repo!)
            case (nil, let error):
                guard error as? RepoErrors != RepoErrors.badTokenAccess else {
                    self?.exitAccount()
                    return
                }
                print(error!)
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stoprotating()
                self?.connectionErrorView.isHidden = false
            default:
                print("switch in RepoDetails get default")
                return
            }
        }
    }
    
    // MARK: loadReadme()
    private func loadReadme() {
        self.connectionErrorView.isHidden = true
        self.loadErrorView.isHidden = true
        self.activityIndicator.rotate()
        self.activityIndicator.isHidden = false
        
        guard let repo = repo else {
            print("RepoId is Missing")
            return
        }
        
        appLogic.getRepositoryReadme(ownerName: repo.owner.username, repositoryName: repo.name, branchName: "") { [weak self] (readme, error) in
            switch (readme, error) {
            case (let content, nil):
                self?.setReadmeView(content: content)
            case (nil, let error):
                guard error as? RepoErrors != RepoErrors.badTokenAccess else {
                    self?.exitAccount()
                    return
                }
                print(error!)
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stoprotating()
                self?.loadErrorView.isHidden = false
            default:
                print("switch in RepoDetails get default")
                return
            }
        }
    }
    
    //MARK: setContentView()
    private func setContentView(repo: RepoDetails) {
        self.repoDetails = repo
        self.scrollView.isHidden = false
        
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
    
    // MARK: setReadmeView()
    private func setReadmeView(content: String?){
        self.activityIndicator.isHidden = true
        self.activityIndicator.stoprotating()
        let decodedContent = content?.decodeBase64()
        
        if let decodedContent = decodedContent {
            let markdownParser = MarkdownParser(font: UIFont.systemFont(ofSize: 16), color: UIColor.white)
            self.readmeLabel.attributedText = markdownParser.parse(decodedContent)
        } else {
            self.readmeLabel.text = "No README.md"
        }
        
        
        self.readmeLabel.isHidden = false
    }
    
    // MARK: Buttons
    @IBAction func refreshRepoDetailButtonTapped(_ sender: Any) {
        self.loadRepoDetail()
        self.loadReadme()
    }
    @IBAction func refreshReadmeButtonTapped(_ sender: Any) {
        self.loadReadme()
    }
    
    // MARK: followLink()
    @IBAction private func followLink(_ sender: Any) {
        let url = URL(string: self.repoDetails?.html_url ?? "https://apple.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
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
