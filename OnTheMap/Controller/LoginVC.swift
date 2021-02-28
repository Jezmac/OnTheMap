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
        initUI()
    }
    
    //MARK: - Actions
    
    // Direct user to udacity sign-up page if button is pressed
    @IBAction func signUpTapped(_sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com") {
            UIApplication.shared.open(url)
        }
    }
    
    // login function makes login call via network client.
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        NetworkClient.login(username: emailTF.text ?? "", password: passwordTF.text ?? "", completion: handleLoginResponse(result:))
    }
    
    // If login succesful both user data and studentLocations are fetched from API. Failure calls the alert handler.
    func handleLoginResponse(result: Result<Bool, Error>) {
        switch result {
        case .failure(_):
            Alert.showInvalidIDAlert(on: self)
            setLoggingIn(false)
        case .success(_):
            NetworkClient.getUserData(completion: self.handleGetUserDataResponse(result:))
            NetworkClient.getStudentLocations(completion: BaseViewController.handleGetStudentLocationsResponse(result:))
        }
    }
    
    // If User data is succesfully received and decoded the main tab bar is presented. Failure results in an alert message.
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
            initUI()
        }
    }
    
    // Initialise UI
    func initUI() {
        emailTF.text = ""
        passwordTF.text = ""
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
    }
    
    // Calls activity Indicator and disables UI while neetwork is making request
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
            self.view.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            self.view.alpha = 1
        }
        emailTF.isEnabled = !loggingIn
        passwordTF.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        loginViaFacebookButton.isEnabled = !loggingIn
    }
}

//MARK:- Extension for TextField Behaviours

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTF:
            self.passwordTF.becomeFirstResponder()
        case self.passwordTF:
            if loginButton.isEnabled {
                setLoggingIn(true)
                NetworkClient.login(username: emailTF.text ?? "", password: passwordTF.text ?? "", completion: handleLoginResponse(result:))
            }
            self.passwordTF.resignFirstResponder()
        default:
            self.passwordTF.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var activeTF = textField
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

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        return true
    }
}
        
