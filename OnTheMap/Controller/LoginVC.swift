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
    
    @IBAction func loginTapped(_ sender: Any) {
        setLogginIn(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(result:))
        
    }
    func handleLoginResponse(result: Result<Bool, Error>) {
        switch result {
        case .success(_):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTBC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            mainTBC.modalPresentationStyle = .fullScreen
            
            present(mainTBC, animated: true, completion: nil)
            clearTextFields()
        case .failure(let error):
            Alert.showBasicAlert(on: self, with: error.localizedDescription, message: "Please try again")
            setLogginIn(false)
        }
    }
    
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func setLogginIn(_ loggingIn: Bool) {
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
    
//    func showLoginFailure(message: String) {
//        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        show(alertVC, sender: nil)
//    }
}

