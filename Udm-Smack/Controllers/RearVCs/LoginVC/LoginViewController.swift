//
//  LoginViewController.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 03/12/2021.
//

import UIKit
import Localize_Swift

class LoginViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signUpHereBtn: UIButton!
    @IBOutlet weak var logInBtn: RoundedButton!
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    // MARK: Actions
     @IBAction func closePressedBtn(_ sender: Any) {
         
         let targetVC = ChatViewController()
         self.revealViewController().setFront(targetVC, animated: true)
     }
     
     @IBAction func createAccountPressedBtn(_ sender: Any) {
         
         let targetVC = CreateAccountViewController()
         self.navigationController?.pushViewController(targetVC, animated: true)
     }

    @IBAction func loginPressed(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = userNameTxt.text, userNameTxt.text != "" else {return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthorService.instance.loginUser(email: email, password: password, completion: {
            (success) in
            if success {
                
                AuthorService.instance.findUserByEmail(completion: {
                    (success) in
                    if success {
                        
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        let targetVC = ChatViewController()
                        self.revealViewController().setFront(targetVC, animated: true)
                    }
                })
            }
        })
    }
    
    @IBAction func openSwitchLanguages(_ sender: Any) {
        
        let targetVC = SwitchLanguages()
        targetVC.modalPresentationStyle = .custom
        self.present(targetVC, animated: true, completion: nil)
    }
    
    //MARK: Helpers
    func setUpView() {
        
        self.hideNavigationBar(animated: true)
        
        spinner.isHidden = true

        let tap = UITapGestureRecognizer(
            target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(switchLanguages),
            name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        switchLanguages()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func switchLanguages() {
        userNameTxt.switchLanguges(localizedPlaceholder: "Username")
        
        passwordTxt.switchLanguges(localizedPlaceholder: "Password")
        
        logInBtn.switchLanguagesForButton(
            titleBtn: "Login", color: .white,
            fontType: .helveticaBold, fontsize: 20)
        
        signUpHereBtn.switchLanguagesForButton(
            titleBtn: "Don't have any account? Sign up here",
            color: .lightBlue, fontType: .system, fontsize: 18)
    }
}


