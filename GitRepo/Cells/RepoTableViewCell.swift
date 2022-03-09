//
//  RepoTableViewCell.swift
//  GitRepo
//
//  Created by Стажер on 01.03.2022.
//

import UIKit

private enum CodingLang: String {
    case kotlin = "Kotlin"
    case swift = "Swift"
    case javaScript = "JavaScript"
    case python = "Python"
}

extension CodingLang {
    var color: UIColor {
        get {
            switch self {
            case .kotlin:
                return UIColor(red: 163.0/255, green: 122.0/255, blue: 238.0/255, alpha: 1.0)
            case .swift:
                return UIColor(red: 240.0/255, green: 81.0/255, blue: 56.0/255, alpha: 1.0)
            case .javaScript:
                return UIColor(red: 244.0/255, green: 226.0/255, blue: 100.0/255, alpha: 1.0)
            case .python:
                return UIColor(red: 53.0/255, green: 114.0/255, blue: 165.0/255, alpha: 1.0)
            }
        }
    }
}

class RepoTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "RepoCell"
    
    @IBOutlet private var repoNameLabel: UILabel!
    @IBOutlet private var languageLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    func updateCell(repo: Repo) {
        repoNameLabel.text = repo.name
        if let lang = repo.language {
            languageLabel.text = lang
            let langEnum: CodingLang? = CodingLang(rawValue: lang)
            languageLabel.textColor = langEnum?.color ?? .yellow
        } else {
            languageLabel.isHidden = true
        }
        if let desc = repo.description { descriptionLabel.text = desc } else { descriptionLabel.isHidden = true }
    }
}