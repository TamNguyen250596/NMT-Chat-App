//
//  SwitchLanguages.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 06/01/2022.
//

import UIKit
import Localize_Swift

class SwitchLanguages: UIViewController {
    //MARK: Properties
    @IBOutlet weak var languagesTable: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    let dataLanguges = SwitchLanguagesModel().createArrayLanguages()
    var selectedRow = SwitchLanguagesModel().indexOfCurrentLanguage()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    //MARK: Actions
    @IBAction func closeVC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helpers
    private func configureUI() {
        
        languagesTable.delegate = self
        languagesTable.dataSource = self
        languagesTable.sectionHeaderTopPadding = 0
        languagesTable.register(NIB_NAME_CELL_CHAT,
                       forCellReuseIdentifier: CELL_CHAT_REUSABLE_ID)
        
        cancelBtn.switchLanguagesForButton(
            titleBtn: "Cancel", color: .thickBlue,
            fontType: .chalkboardRegular, fontsize: 20)
    }
}

//MARK: Table view data source
extension SwitchLanguages: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataLanguges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CELL_CHAT_REUSABLE_ID, for: indexPath)
            as! ChatCell
        
        let dataAtIndex = dataLanguges[indexPath.row]
        
        cell.updateUIOfLanguages(
            flagIcons: dataAtIndex.flags,
            languages: dataAtIndex.languages)
        
        return cell
    }
}

//MARK: Table view actions
extension SwitchLanguages {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
        for cell in tableView.visibleCells {
            cell.accessoryType = .none}
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        
        let languageDidChoose = SwitchLanguagesModel()
            .availableLanguages[indexPath.row]
        
        Localize.setCurrentLanguage(languageDidChoose)
        selectedRow = indexPath.row
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = indexPath.row == selectedRow ? .checkmark : .none
    }
}

//MARK: Header
extension SwitchLanguages {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let label = UILabel()
        label.switchLanguagesForLabel(
            titleBtn: "Switch Languages", color: .thickBlue,
            fontType: .chalkboardBold, fontsize: 26)
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(
            equalTo: headerView.centerYAnchor, constant: 0).isActive = true
        label.centerXAnchor.constraint(
            equalTo: headerView.centerXAnchor, constant: 0).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100
    }
}
