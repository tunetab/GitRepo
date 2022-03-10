//
//  AuthViewController.swift
//  GitRepo
//
//  Created by Стажер on 01.03.2022.
//

import UIKit
import Alamofire

class AuthViewController: UIViewController {
    let appLogic = AppRepository()
    
    @IBOutlet private var tokenTextField: UITextField!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var authButton: UIButton!
    @IBOutlet private var activityIndicator: UIImageView!
    
    private var buttonConstraint: NSLayoutConstraint?
    private var originalButtonText: String?
    private var textStatus: ResponseStatus = .disabled

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tokenTextField.text = nil
    }
    
    // MARK: setView()
    private func setView(){
        errorLabel.isHidden = true
        activityIndicator.isHidden = true
        
        tokenTextField.layer.borderWidth = 1
        tokenTextField.layer.cornerRadius = 8
        tokenTextField.attributedPlaceholder = NSAttributedString(
            string: "Personal access token",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: tokenTextField.frame.size.height))
        tokenTextField.leftView = paddingView
        tokenTextField.leftViewMode = .always
        tokenTextField.rightView = paddingView
        tokenTextField.rightViewMode = .always

        setBorderColor(status: textStatus)
        
        buttonConstraint = authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        buttonConstraint!.isActive = true
    
        activityIndicator.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tokenTextField.addTarget(self, action: #selector(refreshBorderColor(_:)), for: .editingChanged)
    }
    
    //MARK: AuthAction
    @IBAction private func auth(_ sender: Any) {
        showLoading()
        if let token = tokenTextField.text, token.isEmpty == false {
            appLogic.signIn(token: token) { [weak self] (userInfo, error) in
                switch (userInfo, error) {
                case (let user, nil):
                    self?.hideLoading()
                    guard let user = user else { return }
                    
                    KeyValueStorage.shared.authToken = token
                    KeyValueStorage.shared.userName = user.username
                    
                    self?.openRepos()
                case (nil, let error):
                    self?.hideLoading()
                    if let error = error {
                        self?.turnEverythingRed()
                        print(error)
                    }
                default:
                    self?.hideLoading()
                    print("switch in signIn get default")
                    return
                }
            }
        } else {
            self.turnEverythingRed()
        }
    }
    
    // MARK: borderColor()
    private func setBorderColor(status: ResponseStatus) {
        tokenTextField.layer.borderColor = status.color.cgColor
    }
    private func turnEverythingRed(){
        self.textStatus = .invalid
        setBorderColor(status: .invalid)
        errorLabel.isHidden = false
    }
    
    // MARK: textFieldTarget
    @objc private func refreshBorderColor(_ textField: UITextField) {
        self.setBorderColor(status: tokenTextField.isFirstResponder ? .active : .disabled)
        self.errorLabel.isHidden = true
    }
    
    // MARK: keyboardObserver
    @objc private func keyboardWillShow(_ notification: Notification) {
        setBorderColor(status: textStatus == .invalid ? .invalid : .active)
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        buttonConstraint?.constant = -keyboardHeight
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        setBorderColor(status: textStatus == .invalid ? .invalid : .disabled)
        buttonConstraint?.constant = -50
    }
    
    // MARK: addProgressView()
    private func showLoading() {
        originalButtonText = authButton.titleLabel?.text
        authButton.setTitle("", for: .normal)
        
        activityIndicator.isHidden = false
        activityIndicator.rotate()
    }
    private func hideLoading() {
        authButton.setTitle(originalButtonText, for: .normal)
        activityIndicator.isHidden = true
        activityIndicator.stoprotating()
    }
    
    // MARK: Segues
    private func openRepos() {
        if let repoListVC = storyboard?.instantiateViewController(withIdentifier: "RepoListVC") as? RepositoriesListViewController {
            self.navigationController?.pushViewController(repoListVC, animated: true)
        }
    }
}
