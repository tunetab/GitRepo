//
//  AuthLogic.swift
//  GitRepo
//
//  Created by Стажер on 01.03.2022.
//

import Foundation
import Alamofire

enum RepoErrors: Error {
    case accessTokenIsMissing
    case validationFailed
}

class AppLogic {
    
    func signIn(token: String, completion: @escaping (UserInfo?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "token \(token)"
        ]
        request("https://api.github.com/user", headers: headers).validate().responseData { responseData in
            switch responseData.result {
            case .success(let value):
                if let decodedData = try? JSONDecoder().decode(UserInfo.self, from: value) {
                    print(decodedData)
                    completion(decodedData, nil)
                } else {
                    completion(nil, RepoErrors.validationFailed)
                    return
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getRepositories(completion: @escaping ([Repo]?, Error?) -> Void) {
        guard let token = KeyValueStorage.shared.authToken else {
            completion(nil, RepoErrors.accessTokenIsMissing)
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "token \(token)"
        ]
        request("https://api.github.com/user/repos", headers: headers).validate().responseData { responseData in
            switch responseData.result {
            case .success(let value):
                if let decodedData = try? JSONDecoder().decode(Array<Repo>.self, from: value) {
                    print(decodedData)
                    completion(decodedData, nil)
                } else {
                    completion(nil, RepoErrors.validationFailed)
                    return
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getRepository(repoId: String, completion: @escaping (RepoDetails?, Error?) -> Void) {
        // TODO:
    }
          
    func getRepositoryReadme(ownerName: String, repositoryName: String, branchName: String, completion: @escaping (String?, Error?) -> Void) {
        // TODO:
    }

}
