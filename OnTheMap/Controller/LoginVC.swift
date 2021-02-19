//
//  ViewController.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 10/02/2021.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginViaFacebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // Restrict orientation to portrait only
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearTextFields()
        
    }

    //MARK: - Actions
    
    
    @IBAction func signUpTapped(_sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        NetworkClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(result:))
        
    }
    func handleLoginResponse(result: Result<Bool, Error>) {
        switch result {
        case .success(_):
            NetworkClient.getUserData(completion: self.handleGetUserDataResponse(result:))
        case .failure(_):
            Alert.showInvalidIDAlert(on: self)
            setLoggingIn(false)
        }
    }
    
    func handleGetUserDataResponse(result: Result<User, Error>) {
        switch result {
        case .failure(_):
        Alert.showNoUserDataAlert(on: self)
            setLoggingIn(false)
        case .success(_):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTBC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            mainTBC.modalPresentationStyle = .fullScreen
            present(mainTBC, animated: true, completion: nil)
            setLoggingIn(false)
            clearTextFields()
        }
    }
    
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        loginViaFacebookButton.isEnabled = !loggingIn
    }
}

