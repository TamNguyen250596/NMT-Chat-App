//
//  ChannelCellViewController.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 08/12/2021.
//

import UIKit

class ChannelCellViewController: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var channelNameLbl: UILabel!
    

    //MARK: View cycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    //MARK: Helpers
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configuredCell(channel : Channel) {
        let title = channel.channelTitle ?? ""
        channelNameLbl.text = title
        channelNameLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessageService.instance.unreadChannels {
            if id == channel.id {
                channelNameLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
        
    }
    
}
