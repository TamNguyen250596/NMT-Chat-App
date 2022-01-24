//
//  ChatViewController.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 03/12/2021.
//

import UIKit
import Localize_Swift

class ChatViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var userTypeLbl: UILabel!
    var isTyping = false
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        fetchMessages()
        fetchTypingUsers()
        addObserverFromUserLogin()
        showTitleChannelSelected()
    }

    
    //MARK: API
    func fetchMessages() {
        SocketService.instance.getChatMessage(completion: {
            (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthorService.instance.isLoggedin {
                MessageService.instance.message.append(newMessage)
                self.tableView.reloadData()
                if MessageService.instance.message.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.message.count - 1,
                        section: 0)
                    self.tableView.scrollToRow(
                        at: endIndex,
                        at: .bottom,
                        animated: true)
              }
            }
        })
    }
    
    func fetchTypingUsers() {
        SocketService.instance.getTypingUsers({
            (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            var names = ""
            var numberofTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberofTypers += 1
                }
            }
            
            if numberofTypers > 0 && AuthorService.instance.isLoggedin == true {
                var verb = "is"
                if numberofTypers > 1 {
                    verb = "are"
                }
                self.userTypeLbl.text =
                "\(names) "
                + "\(verb) ".localized(using: Strings_LabelStrings)
                + "typing a message".localized(using: Strings_LabelStrings)
                
            } else {
                self.userTypeLbl.text = ""
            }
        })
    }
    
    func onLoginGetMessage() {
        MessageService.instance.findAllChannel(completion: {
            (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        })
    }

    func getMessage() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessageForChannel(channelID: channelId, completion: { (success) in
            if success {
                self.tableView.reloadData()
            }
        })
    }
    
    //MARK: Actions
    @IBAction func sendMessagePress(_ sender: Any) {
        if AuthorService.instance.isLoggedin {
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let message = messageTxtField.text else {return}
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: {
                (success) in
                if success {
                    self.messageTxtField.text = ""
                    self.messageTxtField.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", with: [UserDataService.instance.name])
                }
            })
        }
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        
        if messageTxtField.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", with: [UserDataService.instance.name])
        } else {
            if isTyping == false {
                sendBtn.isHidden = false
                SocketService.instance.socket.emit("startType", with: [UserDataService.instance.name, channelId])
            }
            isTyping = true
        }
    }
    
    
    //MARK: Helpers
    func updateUI() {
        hideNavigationBar(animated: true)
        
        menuBtn.imageView?.contentMode = .scaleAspectFit
        if self.revealViewController() != nil {
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControl.Event.touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.stopEditing))
        view.addGestureRecognizer(tap)
        view.bindToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(NIB_NAME_CELL_CHAT,
        forCellReuseIdentifier: CELL_CHAT_REUSABLE_ID)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        sendBtn.isHidden = true
        userTypeLbl.text = ""
        messageTxtField.switchLanguges(
        localizedPlaceholder: "Enter message here")
    }
    
    @objc func stopEditing() {
        view.endEditing(true)
    }
}


//MARK: Table view data source
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_CHAT_REUSABLE_ID, for: indexPath) as! ChatCell
        let message = MessageService.instance.message[indexPath.row]
        cell.updateCell(userAvatar: message.userAvatar, userAvatarColor: message.userAvatarColor, userName: message.userName, postedDate: message.timeStamp, message: message.message)
        return cell
    }
}

//MARK: Observed notification from loginVC and createAccountVC
extension ChatViewController {
    func addObserverFromUserLogin() {
        
        //Create a new account and login
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        //Login the existing account
        if AuthorService.instance.isLoggedin {
            AuthorService.instance.findUserByEmail(completion: {
                (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }
    
    @objc func userDidChange(_ notif: Notification) {
        if AuthorService.instance.isLoggedin {
            onLoginGetMessage()
        } else {
            channelNameLbl.switchLanguagesForLabel(
                titleBtn: "Please Log In", color: .white,
                fontType: .helveticaBold, fontsize: 20)
            tableView.reloadData()
        }
    }
}

//MARK: Observed notification from channelVC
extension ChatViewController {
    
    func showTitleChannelSelected() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessage()
    }
}

