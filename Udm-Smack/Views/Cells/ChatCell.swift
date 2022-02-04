//
//  ChatCell.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 17/12/2021.
//

import UIKit

class ChatCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postedDateLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    //MARK: View cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: Helpers
    func updateCell(userAvatar: String, userAvatarColor: String, userName: String, postedDate:String, message:String) {
        
        self.userAvatar.image = UIImage(named: userAvatar)
        self.userAvatar.backgroundColor = String().returnColor(components: userAvatarColor)
        self.userNameLbl.text = userName
        self.messageLbl.text = message
        
        let end = postedDate.index(postedDate.endIndex, offsetBy: -5)
        let editedDate = postedDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: editedDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MM d, h:mm a"
        
        if let finalDate = chatDate {
            
            let finalDate = newFormatter.string(from: finalDate)
            postedDateLbl.text = finalDate
        }
    }
    
    func updateUIOfLanguages(flagIcons: UIImage?, languages: String) {
        
        self.userAvatar.image = flagIcons
        self.userNameLbl.text = languages
        self.postedDateLbl.isHidden = true
        self.messageLbl.isHidden = true
        
    }
}
