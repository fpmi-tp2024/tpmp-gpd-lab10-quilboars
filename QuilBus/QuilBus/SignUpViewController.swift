//
//  SignUpViewController.swift
//  QuilBus
//
// Created by Michael Romanov on 5/29/24.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var backToSignInButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    
    public var CtxManager: ContextManager!;
    var _userRepository: UserRepository!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 20
        signupButton.layer.borderWidth = 2
        signupButton.layer.borderColor = UIColor.systemGreen.cgColor
        
        let ctx = ContextRetriever.RetrieveContext();
        CtxManager = ContextManager(context: ctx);
        _userRepository = UserRepository(contextManager: CtxManager);
        
        errorField.lineBreakMode = .byWordWrapping
        errorField.numberOfLines = 0
        
        signUpLabel.text = NSLocalizedString("SIGN_UP2", comment: "")
        signupButton.setTitle(NSLocalizedString("SIGN_UP", comment: ""), for: .normal)
        backToSignInButton.setTitle(NSLocalizedString("BACK_TO_SIGN_IN", comment: ""), for: .normal)
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("PASSWORD", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        repeatPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("REPEAT_PASSWORD", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        let login = emailTextField.text!
        let password = passwordTextField.text!
        let repeatPassword = repeatPasswordTextField.text!
        if (login.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
            errorField.text = NSLocalizedString("EMPTY_FIELD", comment: "")
            return
        }
        if password != repeatPassword {
            errorField.text = NSLocalizedString("DIFFERENT_PASSWORDS", comment: "")
            return
        }
        
        let user = _userRepository.GetUsersByLogin(login: login)

        if (user == nil) {
            errorField.text = NSLocalizedString("FATAL_ERROR", comment: "")
            return
        }
        if(!user!.isEmpty){
            errorField.text = NSLocalizedString("USER_EXISTS", comment: "")
            return
        }
    
        let new_user: User? = _userRepository.AddUser(login: login, password: String(password.hash))
        UserContext.CurrentUser = new_user!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "MainMenuStoryboard")
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SignInStoryboard")
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
}
