//
//  ViewController.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 10/02/2021.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore

class LoginVC: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginViaFacebookButton: CustomButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: Properties
    
    weak var activeTF: UITextField!
    weak var inactiveTF: UITextField!
    let fbLoginManager = LoginManager()

    
    // Restrict orientation to portrait only
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    //MARK: Lifecycle
    
    // Set textField delegates and initialise the UI
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
        initUI()
    }
    
    
    //MARK: - Actions
    
    
    // Calls method for facebook authentication.
    @IBAction func fbLoginTapped(_ sender: Any) {
            fbLogin()
    }
    

    // Direct user to udacity sign-up page if button is pressed.
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
    
    
    // Tap outside of textFields dismisses UIKeyboard if active.
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
    
    
    //MARK:- Methods
    
    
    // If login succesful both user data and studentLocations are fetched from API. Failure calls the alert handler.
    func handleLoginResponse(result: Result<Bool, Error>) {
        switch result {
        case .failure(_):
            Alert.showInvalidIDAlert(on: self)
            setLoggingIn(false)
        case .success(_):
            NetworkClient.getUserData(completion: self.handleGetUserDataResponse(result:))
            NetworkClient.getStudentLocations(completion: self.handleGetStudentLocationsResponse(result:))
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
    
    
    func handleGetStudentLocationsResponse(result: Result<[StudentLocation], Error>) {
        switch result {
        case .success(let students):
            StudentModel.studentArray.removeAll()
            StudentModel.studentArray = BaseViewController.cleanArray(elements: students)
        case .failure(_):
            Alert.showCouldNotGetStudentLocations(on: self)
        }
    }
    
    
    // Calls facebook authentication SDK. Gives an alert message if succesful explaining that the feature cannot be fully implemented at this time.
    func fbLogin() {
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: [ "public_profile", "email"], from: self) { [weak self] result, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let result = result, !result.isCancelled else {
                print("user cancelled Login.")
                return
            }
            Profile.loadCurrentProfile { (profile, error) in
                guard let vc = self else { return }
                Alert.showFBLoginSuccess(on: vc, user: Profile.current?.name ?? "User")
                vc.fbLoginManager.logOut()
            }
        }
    }
    
    
    // Initialise UI
    func initUI() {
        emailTF.text = ""
        passwordTF.text = ""
        loginButton.isEnabled(false)
        addTapRecognizer()
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
        loginButton.isEnabled(!loggingIn)
        loginViaFacebookButton.isEnabled(!loggingIn)
    }
    
    
    // Registers screentaps so keyboard can be dismissed when user taps outside of textFields.
    func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.viewTapped))
        self.view.addGestureRecognizer(tapRecognizer)
    }
}


//MARK:- Extension for TextField Behaviours

extension LoginVC: UITextFieldDelegate {
    
    // Since return key type is only .go when both fields contain characters this variable can be used to determine the behaviour of the key press. If it is .next then the other field is set to first responser, if it is .go then the geolocation function is called
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .next:
            inactiveTF.becomeFirstResponder()
        case .go:
            setLoggingIn(true)
            NetworkClient.login(username: emailTF.text ?? "", password: passwordTF.text ?? "", completion: handleLoginResponse(result:))
        default:
            inactiveTF.becomeFirstResponder()
        }
        return true
    }
    
    // checks contents of the non-editing textField. If it is empty then text entry does not enable the location button. If it does contain text then the button is enabled.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if inactiveTF.text == "" {
            loginButton.isEnabled(false)
        } else {
            if !text.isEmpty {
                loginButton.isEnabled(true)
            } else {
                loginButton.isEnabled(false)
            }
        }
        return true
    }
    
    // Checks if both textfields are empty, if they are then the return key is set to next for the selected textfield. If the other textfield has text, then it is set to go instead.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
        inactiveTF = setInactiveTF(textField: textField)
        if inactiveTF.text == "" {
            textField.returnKeyType = .next
        } else {
            textField.returnKeyType = .go
        }
    }
    
    // ensures button is disabled when cleartext button is used.
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        loginButton.isEnabled(false)
        return true
    }
    
    // returns the textField not currently in use.
    func setInactiveTF(textField: UITextField) -> UITextField {
        let inactiveTF: UITextField
        if textField == emailTF {
            inactiveTF = passwordTF
        } else {
            inactiveTF = emailTF
        }
        return inactiveTF
    }
}

