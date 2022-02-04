//
//  UpdateUserNameVC.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 25/12/2021.
//

import UIKit
import Localize_Swift

class UpdateUserNameVC: UIViewController {
    //MARK: Properties
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleViewLbl: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    //MARK: Actions
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeUserNamePressed(_ sender: Any) {
        
        guard let newName = textField.text,
        textField.text != "" else {return}
        
        AuthorService.instance.updateUser(
            name: newName,
            completion: { (success) in
                
                if success {
                    
                    AuthorService.instance.findUserByEmail(
                        completion: { (success) in
                            
                            if success {
                                
                                self.spinner.isHidden = false
                                self.spinner.startAnimating()
                                NotificationCenter.default.post(
                                    name: NOTIF_USER_NAME_UPDATE,
                                    object: nil)
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                }
            })
    }
    
    //MARK: Helper funcs
    func updateView() {
        
        spinner.isHidden = true
        spinner.stopAnimating()
        
        titleViewLbl.switchLanguagesForLabel(
            titleBtn: "Update User Name", color: .thickBlue,
            fontType: .chalkboardBold, fontsize: 30)
        
        changeBtn.switchLanguagesForButton(
            titleBtn: "Change", color: .thickBlue,
            fontType: .chalkboardRegular, fontsize: 20)
        
        textField.switchLanguages(localizedPlaceholder: "Please enter your new user name")

    }
}
