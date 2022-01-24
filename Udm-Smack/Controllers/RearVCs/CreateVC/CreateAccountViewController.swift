//
//  CreateAccountViewController.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 03/12/2021.
//

import UIKit
import Localize_Swift

class CreateAccountViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleViewLbl: UILabel!
    @IBOutlet weak var chooseAvatarBtn: UIButton!
    @IBOutlet weak var pickColorsBtn: UIButton!
    @IBOutlet weak var createAccountBtn: RoundedButton!
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor = UIColor.white
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        switchLanguages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDataService.instance.avatarName != "" {
            
            userImage.image = UIImage(
                named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            
            if avatarName.contains("light") && bgColor == UIColor.white {
                userImage.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    //MARK: Actions
    @IBAction func createAccountPressed(_ sender: Any) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let name = usernameTxt.text, usernameTxt.text != "" else {return}
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthorService.instance.registerUser(email: email, password: password)
        { success in
            if success {
                
                AuthorService.instance.loginUser(email: email, password: password, completion: { success in
                    if success {
                        
                        AuthorService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: {
                            success in
                            if success{
                                
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                                let targetVC = ChatViewController()
                                self.revealViewController().setFront(targetVC, animated: true)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func pickupAvartaPressed(_ sender: Any) {
        
        let targertVC = AvatarPickUPVC()
        self.navigationController?.pushViewController(targertVC, animated: true)
    }
    
    @IBAction func pickupBGUserPressed(_ sender: Any) {
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .custom
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func closePressedBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
        
    //MARK: Helpers
    func setUpView() {
        self.hideNavigationBar(animated: true)
        activityIndicator.isHidden = true
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

//MARK: Switch Languages
extension CreateAccountViewController {
    func switchLanguages() {
        
        titleViewLbl.switchLanguagesForLabel(
            titleBtn: "Create an account", color: .thickBlue,
            fontType: .chalkboardBold, fontsize: 30)
        
        chooseAvatarBtn.switchLanguagesForButton(
            titleBtn: "Choose avatar", color: .lightBlue,
            fontType: .system, fontsize: 18)
        
        pickColorsBtn.switchLanguagesForButton(
            titleBtn: "Generate background color", color: .lightBlue,
            fontType: .system, fontsize: 18)
        
        createAccountBtn.switchLanguagesForButton(
            titleBtn: "Create Account", color: .white,
            fontType: .helveticaBold, fontsize: 20)
        
        usernameTxt.switchLanguges(localizedPlaceholder: "Username")
        
        emailTxt.switchLanguges(localizedPlaceholder: "Email")
        
        passwordTxt.switchLanguges(localizedPlaceholder: "Password")
        

    }
}

//MARK: Color Picker
extension CreateAccountViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        
        let color = viewController.selectedColor
        var rGet = CGFloat()
        var gGet = CGFloat()
        var bGet = CGFloat()
        var aGet = CGFloat()
        
        bgColor = color
        bgColor.getRed(&rGet, green: &gGet, blue: &bGet, alpha: &aGet)
        avatarColor = "[\(rGet), \(gGet), \(bGet), \(aGet)]"
        
        UIView.animate(withDuration: 0.2, animations: {
            self.userImage.backgroundColor = self.bgColor
        })
    }
}
