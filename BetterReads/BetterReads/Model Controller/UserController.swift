//
//  UserController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/21/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import JWTDecode

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case existingUser
    case noUser
}

class UserController {
    typealias JWT = String
    private var baseURL = URL(string: "https://api.readrr.app/api")!
    private var authToken: JWT?
    var user: User? = nil
    var isNewUser: Bool?
    var bookThumbnails: [String]?
        
    static let shared = UserController()
        
    private init() { }
    
    typealias CompletionHandler = (Error?) -> Void
    
    //MARK: - Sign Up
    func signUp(fullName: String, emailAddress: String, password: String, completion: @escaping CompletionHandler = { _ in }) {
        let signUpURL = baseURL.appendingPathComponent("auth")
        .appendingPathComponent("signup")
        let parameters = ["fullName": fullName, "emailAddress": emailAddress, "password": password]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        AF.request(signUpURL,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).responseJSON { response in
                    switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        let authToken = jsonData["token"].stringValue
                        self.authToken = authToken
                        self.user = User(id: Int(), fullName: fullName, emailAddress: emailAddress)
                        completion(nil)
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(NetworkError.otherError)
                    }
        }
    }
    
    //MARK: - Sign In
    func signIn(emailAddress: String, password: String, completion: @escaping CompletionHandler = { _ in }) {
        let signInURL = baseURL.appendingPathComponent("auth")
        .appendingPathComponent("signin")
        let parameters = ["emailAddress": emailAddress, "password": password]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        AF.request(signInURL,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).responseJSON { response in
                    switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        guard let authToken = jsonData["token"].string else { return completion(NetworkError.noDecode) }
                        self.authToken = authToken
                        do {
                            let jwt = try decode(jwt: authToken)
                            let fullNameClaim = jwt.claim(name: "fullName")
                            // get the id from the token NOT the user
                            let idClaim = jwt.claim(name: "subject")
                            guard let fullName = fullNameClaim.string,
                                let id = idClaim.integer else {
                                    return completion(NetworkError.otherError) }
                            self.user = User(id: id, fullName: fullName, emailAddress: emailAddress)
                            completion(nil)
                        } catch {
                            completion(NetworkError.otherError)
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(NetworkError.otherError)
                    }
        }
    }
    
    //MARK: - Forgot Password Email
    func forgotPasswordEmail(emailAddress: String, completion: @escaping CompletionHandler = { _ in }) {
        let forgotPasswordEmailURL = baseURL.appendingPathComponent("auth")
        .appendingPathComponent("reset").appendingPathComponent("requestreset")
        let parameters = ["email": emailAddress]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        AF.request(forgotPasswordEmailURL,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).responseJSON { response in
                    switch (response.result) {
                    case .success(_):
                        completion(nil)
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(NetworkError.otherError)
                    }
        }
    }
    
    //MARK: - Recommendations
    func getRecommendations(completion: @escaping CompletionHandler = { _ in }) {
        guard let user = user,
            let authToken = authToken else { return completion(NetworkError.otherError) }
        
        let getRecommendationsURL = baseURL.appendingPathComponent("\(user.id)").appendingPathComponent("recommendations")
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        
        AF.request(getRecommendationsURL,
                   method: .get,
                   headers: headers).responseJSON { response in
                    switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        guard let recommendationsObject = jsonData["recommendations"].dictionary,
                            let recommendationsArray = recommendationsObject["recommendations"]?.array else { return completion(NetworkError.noDecode) }
                        let bookThumbnails = recommendationsArray.map { $0["thumbnail"].stringValue }
                        self.bookThumbnails = bookThumbnails
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(NetworkError.otherError)
                    }
        }
    }
}
