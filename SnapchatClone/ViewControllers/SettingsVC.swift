//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Seyhun Koçak on 27.02.2024.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func settingsClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSigninVC", sender: nil)
        } catch {
            
        }
        
        
        
    }


}
