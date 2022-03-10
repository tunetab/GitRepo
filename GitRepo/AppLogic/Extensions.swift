//
//  Extensions.swift
//  GitRepo
//
//  Created by Стажер on 09.03.2022.
//

import Foundation
import UIKit

// MARK: ResponseStatusEnum
enum ResponseStatus {
    case disabled
    case active
    case invalid
}
extension ResponseStatus {
    var color: UIColor {
        get {
            switch self {
            case .disabled:
                return UIColor(red: 33.0/255, green: 38.0/255, blue: 45.0/255, alpha: 1.0)
            case .active:
                return UIColor(red: 88.0/255, green: 166.0/255, blue: 255.0/255, alpha: 1.0)
            case .invalid:
                return UIColor(red: 176.0/255, green: 0.0/255, blue: 32.0/255, alpha: 1.0)
            }
        }
    }
}

// MARK: String
extension String {
    func getRidOfProtocol() -> String {
        var newUrl = self
        if newUrl.contains("https://") {
            newUrl = newUrl.replacingOccurrences(of: "https://", with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        return newUrl
    }
    func readmeDecoded() -> NSAttributedString? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else { return nil }
        
        let decodedString = String(data: data, encoding: .utf8)
        let attributedString = try? NSAttributedString(markdown: (decodedString)!)
        return attributedString
    }
}

// MARK: LanguageColors
enum CodingLang: String {
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

extension UIImageView{
    func rotate() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .repeat, animations: { () -> Void in
            self.transform = self.transform.rotated(by: .pi)
        })
    }
    func stoprotating()  {
        self.layer.removeAllAnimations()
    }
}
