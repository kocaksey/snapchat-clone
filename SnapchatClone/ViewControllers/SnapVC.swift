//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Seyhun Koçak on 27.02.2024.
//

import UIKit

class SnapVC: UIViewController {

    @IBOutlet weak var timaLabel: UILabel!
    var selectedSnap: Snap?
    var selectedTime: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timaLabel.text = "Time \(selectedTime)"

        // Do any additional setup after loading the view.
    }
    


}
