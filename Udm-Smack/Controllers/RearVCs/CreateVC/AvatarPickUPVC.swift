//
//  AvatarPickUPVC.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 01/12/2021.
//

import UIKit
import Localize_Swift

class AvatarPickUPVC: UIViewController {
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var avatarType = AvatarType.dark
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        switchLanguages()
    }
    
    //MARK: Actions
    @IBAction func segmentControlChanged(_ sender: Any) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            avatarType = .dark
        } else {
            avatarType = .light
        }
        collectionView.reloadData()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helpers
    func configureUI() {
        
        self.hideNavigationBar(animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NIB_NAME_CELL_AVARTA_ICON,
                       forCellWithReuseIdentifier: CELL_AVARTA_ICON)

    }
    
    func switchLanguages() {
        
        segmentControl.setTitle("Dark".localized(using: Strings_ButtonTitle),
                                forSegmentAt: 0)
        segmentControl.setTitle("Light".localized(using: Strings_ButtonTitle),
                                forSegmentAt: 1)
    }
}

//MARK: Collection data source
extension AvatarPickUPVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return AvatarPickerModel(avatarType: avatarType).getDarkOrLightIconArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_AVARTA_ICON, for: indexPath) as! AvatarDarkAndLightCell
        
        let icon = AvatarPickerModel(avatarType: avatarType).getDarkOrLightIconArray()[indexPath.row]
        
            cell.updateAvatarIcon(image: icon)
         
        return cell
    }
}

//MARK: Collection actions
extension AvatarPickUPVC {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if avatarType == .dark {
            UserDataService.instance.setAvatarName(
                avatarName: "dark\(indexPath.item)")
        } else {
            UserDataService.instance.setAvatarName(
                avatarName: "light\(indexPath.item)")
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: Collection flow layout
extension AvatarPickUPVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numOfColumns : CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numOfColumns = 4
        }
        
        let spaceBetweenCells : CGFloat = 10
        let padding : CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numOfColumns - 1) * spaceBetweenCells) / numOfColumns
        
        return CGSize(width: cellDimension, height: cellDimension)
    }
}
