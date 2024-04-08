
import UIKit

class BookMarketPlaceItemVC: AccomodationDetailVC {

    @IBOutlet weak var fullName: UITextField?
    @IBOutlet weak var email: UITextField?
    @IBOutlet weak var phone: UITextField?

    override func viewDidLoad() {
        self.fullName?.text = UserDefaultsManager.shared.getName()
        self.email?.text = UserDefaultsManager.shared.getEmail()
        self.phone?.text = UserDefaultsManager.shared.getMobile()
        
        self.fullName?.isEnabled = false
        self.email?.isEnabled = false
        self.phone?.isEnabled = false
         
        imageSlideShow = (self.view.viewWithTag(13)! as! ImageSlideshow)
        
         (self.view.viewWithTag(10)! as! UILabel).text = selectedAccomodation.name! + "\n$\(selectedAccomodation.rentPrice ?? "")"
         (self.view.viewWithTag(11)! as! UILabel).text = selectedAccomodation.location!
        
      
        self.setupImageSlideShow()
        
    }
    
    
    
    @IBAction override func onApplyNow(_ sender: Any) {
        
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "PaymentScreen" ) as! PaymentScreen
//        self.navigationController?.pushViewController(vc, animated: true)
//        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "ChatVC" ) as! ChatVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
       

    }

}
    
