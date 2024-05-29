//
//  ViewController.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    
    public var CtxManager: ContextManager!;
    var _userRepository: UserRepository!;
    var _localityRepository: LocalityRepository!;
    var _roureRepository: RouteRepository!;
    var _ridesRepository: RideRepository!;
    var _bookedTicketRepository: BookedTicketRepository!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signinButton.layer.cornerRadius = 20
        signinButton.layer.borderWidth = 2
        signinButton.layer.borderColor = UIColor.systemGreen.cgColor
        // Do any additional setup after loading the view.
        
        //TODO: remove db initialization to erlier executed function if it appears
        let ctx = ContextRetriever.RetrieveContext();
        CtxManager = ContextManager(context: ctx);
        _userRepository = UserRepository(contextManager: CtxManager);
        _localityRepository = LocalityRepository(contextManager: CtxManager);
        _roureRepository = RouteRepository(contextManager: CtxManager);
        _ridesRepository = RideRepository(contextManager: CtxManager);
        _bookedTicketRepository = BookedTicketRepository(contextManager: CtxManager);
        
        let dataSeeder = DataSeeder(ctxManager: CtxManager);
        
        //ATTENTION: uncomment to add test data to db if needed
        //But do it only once on each device
        //dataSeeder.SeedUsers()
        //dataSeeder.SeedLocalities();
        //dataSeeder.SeedRoutes();
        //dataSeeder.SeedRides();
        //dataSeeder.SeedBookedTickets();
        
        errorField.lineBreakMode = .byWordWrapping
        errorField.numberOfLines = 0
        
        let signInText = NSLocalizedString("SIGN_IN", comment: "")
        signInLabel.text = signInText
        signinButton.setTitle(signInText, for: .normal)
        createAccountButton.setTitle(NSLocalizedString("CREATE_ACCOUNT", comment: ""), for: .normal)
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("PASSWORD", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        UpdateLanguageSegmentedControl()
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        let login = emailTextField.text!
        let password = passwordTextField.text!
        if (login.isEmpty || password.isEmpty) {
            errorField.text = NSLocalizedString("EMPTY_FIELD", comment: "")
            return
        }
        
        let user = _userRepository.GetUsersByLogin(login: login)

        if (user == nil) {
            errorField.text = NSLocalizedString("FATAL_ERROR", comment: "")
            return
        }
        
        if(user!.isEmpty){
            errorField.text = NSLocalizedString("USER_DONT_EXIST", comment: "")
            return
        }
        
        let isValidPassword = PasswordComparer.Compare(coming: password, stored: user?.first?.password);
        
        if(!isValidPassword){
            errorField.text = NSLocalizedString("WRONG_PASSWORD", comment: "")
            return
        }
        
        UserContext.CurrentUser = user!.first;
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "MainMenuStoryboard")
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    
    @IBAction func signUpButoonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SignUpStoryboard")
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    
    @IBAction func LanguageChanged(_ sender: Any) {
        switch languageSegmentedControl.selectedSegmentIndex{
        case 0:
            setLanguage(languageCode: "en")
            break
        case 1:
            setLanguage(languageCode: "be-BY")
            break
        case 2:
            setLanguage(languageCode: "ru")
            break
        default:
            break
        }
        
        errorField.text = NSLocalizedString("LANGUAGE_WARNING", comment: "")
    }
    
    func setLanguage(languageCode:String) {
        var appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        appleLanguages.remove(at: 0)
        appleLanguages.insert(languageCode, at: 0)
        UserDefaults.standard.set(appleLanguages, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize() //needs restrat
        
        Bundle.main.path(forResource: languageCode, ofType: "lproj")
    }
    
    func getLanguage() -> String {
        let appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        let prefferedLanguage = appleLanguages[0]
        if prefferedLanguage.contains("-") {
            let array = prefferedLanguage.components(separatedBy: "-")
            return array[0]
        }
        return prefferedLanguage
    }
    
    func UpdateLanguageSegmentedControl(){
        let currentLanguage = getLanguage()
        
        switch currentLanguage{
        case "en":
            languageSegmentedControl.selectedSegmentIndex = 0
            break
        case "be":
            languageSegmentedControl.selectedSegmentIndex = 1
            break
        case "ru":
            languageSegmentedControl.selectedSegmentIndex = 2
            break
        default:
            break
        }
    }
}

