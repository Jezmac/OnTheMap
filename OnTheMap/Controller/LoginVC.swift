//
//  ViewController.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 10/02/2021.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginViaFacebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentTextField = UITextField()
    
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
        
        emailTF.delegate = self
        passwordTF.delegate = self
        clearTextFields()
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        
        
    }
    
    //MARK: - Actions
    
    
    @IBAction func signUpTapped(_sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        NetworkClient.login(username: emailTF.text ?? "", password: passwordTF.text ?? "", completion: handleLoginResponse(result:))
        
    }
    
    func handleLoginResponse(result: Result<Bool, Error>) {
        switch result {
        case .success(_):
            NetworkClient.getUserData(completion: self.handleGetUserDataResponse(result:))
            NetworkClient.getStudentLocations { result in
                if case .success(let response) = result {
                    StudentModel.student = response
                }
            }
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
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTF.isEnabled = !loggingIn
        passwordTF.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        loginViaFacebookButton.isEnabled = !loggingIn
    }
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchTextFieldControl(textField)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let otherTextField: UITextField
        if textField == emailTF {
            otherTextField = passwordTF
        } else {
            otherTextField = emailTF
        }
        if otherTextField.text == "" {
                    loginButton.isEnabled = false
            loginButton.alpha = 0.5
        } else {
            if !text.isEmpty {
                loginButton.isEnabled = true
                loginButton.alpha = 1
            } else {
                loginButton.isEnabled = false
                loginButton.alpha = 0.5
            }
        }
        return true
    }
        
        
        private func switchTextFieldControl(_ textField: UITextField) {
            switch textField {
            case self.emailTF:
                self.passwordTF.becomeFirstResponder()
            case self.passwordTF:
                NetworkClient.login(username: emailTF.text ?? "", password: passwordTF.text ?? "", completion: handleLoginResponse(result:))
            default:
                self.passwordTF.resignFirstResponder()
            }
        }
    }
