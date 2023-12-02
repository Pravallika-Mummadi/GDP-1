

import UIKit

class InitialVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LoginVC" ) as! LoginVC
                
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
