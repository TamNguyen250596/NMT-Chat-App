//
//  CreateChannelVC.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 10/12/2021.
//

import UIKit
import Localize_Swift

class CreateChannelVC: UIViewController {
    //MARK: Properties: 
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var channelDescriptionTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleViewLbl: UILabel!
    @IBOutlet weak var createChannelBtn: RoundedButton!
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    //MARK: Actions
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let channelName = userNameTxt.text, userNameTxt.text != "" else {return}
        guard let channelDescription = channelDescriptionTxt.text, channelDescriptionTxt.text != "" else {return}
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription, completion: {
            (sucess) in
            if sucess {
                
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helpers
    func updateView() {
        
        spinner.isHidden = true
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(self.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)

        switchLanguages()
    }
    
    func switchLanguages() {
        
        titleViewLbl.switchLanguagesForLabel(
            titleBtn: "Create A Channel", color: .thickBlue,
            fontType: .chalkboardBold, fontsize: 30)
        
        createChannelBtn.switchLanguagesForButton(
            titleBtn: "Create Channel", color: .white,
            fontType: .chalkboardBold, fontsize: 20)
        
        userNameTxt.switchLanguges(localizedPlaceholder: "Channel name")
        
        channelDescriptionTxt.switchLanguges(localizedPlaceholder: "Descriptiion")
    }
}
