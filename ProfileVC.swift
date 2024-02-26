//
//  ProfileVC.swift
//  StudentInformationExchange
//
//  Created by Macbook-Pro on 29/11/23.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        UserDefaultsManager.shared.clearUserDefaults()
        UserDefaults.standard.removeObject(forKey: "documentId")
        SceneDelegate.shared!.loginCheckOrRestart()
    }
    
    @IBAction func onUpdatePassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "UpdatePasswordVC" ) as! UpdatePasswordVC
                
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
