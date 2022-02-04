//
//  ChannelViewController.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 03/12/2021.
//

import UIKit
import Localize_Swift

class ChannelViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listChannelLbl: UILabel!
    var checkedLogin = false
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        fetchChannels()
        fetchMessages()
        addObserverFromUserLogin()
        addObserverFromCreateANewChannel()
        addObserverFromChangeUserName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        updateUserInfo()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self,
        name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    //MARK: API
    func fetchChannels() {
        
        SocketService.instance.getChannel(completion: {
            (success) in
            
            if success {
                
                self.tableView.reloadData()
            }
        })
    }
    
    func fetchMessages() {
        
        SocketService.instance.getChatMessage(completion: {
            (newMessage) in
            
            if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthorService.instance.isLoggedin {
                
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                self.tableView.reloadData()
            }
        })
    }
    
    //MARK: Actions
    @IBAction func loginPressedBtn(_ sender: Any) {
        
        if AuthorService.instance.isLoggedin {
            
            let targetVC = ProfileViewController()
            targetVC.modalPresentationStyle = .custom
            self.present(targetVC, animated: true, completion: nil)
            
        } else {
            
            let targetVC = UINavigationController(rootViewController: LoginViewController())
            self.revealViewController().pushFrontViewController(
                targetVC, animated: true)
        }
    }

    @IBAction func addChannelPressed(_ sender: Any) {
        
        if AuthorService.instance.isLoggedin{
            
            let targetVC = CreateChannelVC()
            targetVC.modalPresentationStyle = .custom
            self.present(targetVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Helpers
    func updateUserInfo() {
        
        if AuthorService.instance.isLoggedin {
            
            let title = NSMutableAttributedString().bold(UserDataService.instance.name)
            loginBtn.setAttributedTitle(title, for: .normal)
            loginBtn.titleLabel?.font = UIFont.init(name: "Helvetica", size: 20)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            userImage.backgroundColor = String().returnColor(components: UserDataService.instance.avatarColor)
            checkedLogin = true
            
        } else {
            
            loginBtn.switchLanguagesForButton(titleBtn: "Login", color: .white, fontType: .helvetica, fontsize: 20)
            userImage.image = UIImage(named: "smackProfileIcon")
            userImage.backgroundColor = UIColor.lightGray
            tableView.reloadData()
        }
    }
    
    func updateUI() {
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        AuthorService.instance.isLoggedin = checkedLogin
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(NIB_NAME_CELL_CHANNEL,
        forCellReuseIdentifier: CELL_CHANNEL_REUSABLE_ID)
        
        listChannelLbl.switchLanguagesForLabel(
            titleBtn: "List of channels", color: .white,
            fontType: .system, fontsize: 20)
    }
}

//MARK: Table view data source
extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_CHANNEL_REUSABLE_ID, for:  indexPath) as? ChannelCellViewController {
            
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configuredCell(channel: channel)
            return cell
            
        } else {
            
            return UITableViewCell()
        }
    }
}

//MARK: TAble view delegate
extension ChannelViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        if MessageService.instance.unreadChannels.count > 0 {
            
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter({$0 != channel.id})
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }
}

//MARK: Observed notification from loginVC and createAccountVC
extension ChannelViewController {
    
    func addObserverFromUserLogin() {
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.userDataDidChange),
            name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    @objc func userDataDidChange() {
        
        updateUserInfo()
    }
}

//MARK: Observed notification from createChannelVC
extension ChannelViewController {
    
    func addObserverFromCreateANewChannel() {
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.channelIsLoaded(_:)),
            name: NOTIF_CHANNELS_LOADED, object: nil)
    }
    
    @objc func channelIsLoaded(_ notif: Notification) {
        
        tableView.reloadData()
    }
}

//MARK: Observed notification from updateUserVC
extension ChannelViewController {
    
    func addObserverFromChangeUserName() {
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.userDataDidChange),
            name: NOTIF_USER_NAME_UPDATE, object: nil)
    }
}
