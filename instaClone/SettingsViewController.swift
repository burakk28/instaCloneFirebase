//
//  SettingsViewController.swift
//  instaClone
//
//  Created by Burak Kara on 7.12.2022.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
            
        
        //do catch ile dene yapılıyor direkt yaparsak olmuyor .
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
            
            //Oturum hala açık mı kontrolü yapılabilir
        }catch {
            print("Error")
            //
        }
        
       
    }
    
}
