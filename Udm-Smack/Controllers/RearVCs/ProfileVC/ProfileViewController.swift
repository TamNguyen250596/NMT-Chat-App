//
//  ProfileViewController.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 06/12/2021.
//

import UIKit
import Localize_Swift

class ProfileViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleViewLbl: UILabel!
    @IBOutlet weak var logOutBtn: UIButton!
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    //MARK: Actions
    @objc func updateUserName(notification: Notification) {
        
        userName.text = UserDataService.instance.name
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        UserDataService.instance.logOutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushUpdateUserNameVCPressed(_ sender: Any) {
        
        let targetVC = UpdateUserNameVC()
        targetVC.modalPresentationStyle = .custom
        self.present(targetVC, animated: true, completion: nil)
    }
    
    //MARK: Helpers
    func updateUI() {
        
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = String().returnColor(components: UserDataService.instance.avatarColor)
        
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(self.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateUserName(notification:)),
            name: NOTIF_USER_NAME_UPDATE,
            object: nil)
        
        switchLanguages()
    }
    
    func switchLanguages() {
        
        titleViewLbl.switchLanguagesForLabel(
            titleBtn: "Your Profile", color: .thickBlue,
            fontType: .chalkboardBold, fontsize: 30)
        
        logOutBtn.switchLanguagesForButton(
            titleBtn: "Logout", color: .thickBlue,
            fontType: .chalkboardRegular, fontsize: 20)
    }
    
}
