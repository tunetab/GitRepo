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
    var repoDetails: RepoDetails?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        scrollView.isHidden = true
        
        guard let repoName = repo?.name else {
            print("RepoId is Missing")
            return
        }
        
        appLogic.getRepository(repoId: repoName) { [weak self] (repoDetail, error) in
            switch (repoDetail, error) {
            case (let repo, nil):
                self?.reloadView(repo: repo!)
            case (nil, let error):
                print(error)
            default:
                print("switch in RepoDetails get default")
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        linkButton.titleLabel?.text = repoDetails.html_url.getRidOfProtocol()
        linkButton.titleLabel?.textColor = UIColor(red: 88.0/255, green: 166.0/255, blue: 255.0/255, alpha: 1.0)
        
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
    @IBAction func exitAccount(_ sender: Any) {
        print("user \(String(describing: KeyValueStorage.shared.userName)) quited account")

        KeyValueStorage.shared.authToken = nil
        KeyValueStorage.shared.userName = nil

        self.navigationController?.popToRootViewController(animated: true)
    }
    
}


// MARK: extensions
extension String {
    func getRidOfProtocol() -> String {
        var newUrl = self
        if newUrl.contains("https://") {
            newUrl = newUrl.replacingOccurrences(of: "https://", with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        return newUrl
    }
}
