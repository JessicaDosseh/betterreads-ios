//
//  LoginViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez & Ciara "CC" Beitel on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    enum LoginType {
        case signup
        case signin
    }
    
    var loginType = LoginType.signup
    
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
    }
    
    func seg() {
        print("Called seg()")
        performSegue(withIdentifier: "LoginSuccessSegue", sender: self)
    }
    
    // MARK: - Methods
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        print("segmented control value changed")
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        print("signUpTapped")
        guard let fullname = fullNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !fullname.isEmpty,
            !email.isEmpty,
            !password.isEmpty else { return }
        seg()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
