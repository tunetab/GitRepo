//
//  RepoTableViewCell.swift
//  GitRepo
//
//  Created by Стажер on 01.03.2022.
//

import UIKit

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
