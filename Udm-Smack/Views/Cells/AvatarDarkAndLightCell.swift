//
//  AvatarDarkAndLightCell.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 01/12/2021.
//

import UIKit

class AvatarDarkAndLightCell: UICollectionViewCell {
    //MARK: Properties
    @IBOutlet weak var avatarIcon: UIImageView!
    
    //MARK: View cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }
    
    //MARK: Helpers
    func updateView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func updateAvatarIcon(image: UIImage) {
        avatarIcon.image = image
    }
}
