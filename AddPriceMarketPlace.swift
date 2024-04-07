 
import UIKit

class AddPriceMarketPlace: UIViewController {
    @IBOutlet weak var rentPriceTxt: UITextField!
    @IBOutlet weak var monthly: UIButton!
    @IBOutlet weak var yearly: UIButton!
    
    var priceType = "Monthly"

    var accomodation : AccomodationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.monthly.backgroundColor = UIColor.init(hex: 0x2BC990)
//        self.monthly.titleLabel?.textColor = .white
//        
//        self.yearly.backgroundColor = UIColor.init(hex: 0xD4D3D6)
//        self.yearly.titleLabel?.textColor = .darkGray

    }
    
    @IBAction func onWeekYearlyClick(_ sender: UIButton){
        
        if sender.tag == 0{
            self.monthly.backgroundColor = UIColor.init(hex: 0x2BC990)
            self.monthly.titleLabel?.textColor = .white
            
            self.yearly.backgroundColor = UIColor.init(hex: 0xD4D3D6)
            self.yearly.titleLabel?.textColor = .darkGray
            
            self.priceType = "Monthly"

        }else{
            self.yearly.backgroundColor = UIColor.init(hex: 0x2BC990)
            self.yearly.titleLabel?.textColor = .white

            self.monthly.backgroundColor = UIColor.init(hex: 0xD4D3D6)
            self.monthly.titleLabel?.textColor = .darkGray
            self.priceType = "Yearly"

        }
    }
    
    @IBAction func onNext(_ sender: UIButton) {
        if(rentPriceTxt.text!.isEmpty) {
            showAlerOnTop(message: "Please enter price")
            return
        }
        
        if(rentPriceTxt.text!.first == "0"){
            showAlerOnTop(message: "Please enter price")
            return
        }
        
        // Check if price number contains only digits
         let phoneNumberCharacterSet = CharacterSet(charactersIn: self.rentPriceTxt.text!)
            let digitSet = CharacterSet.decimalDigits
            if !digitSet.isSuperset(of: phoneNumberCharacterSet) {
                showAlerOnTop(message: "Rent Price should contain only digits.")
                return
         }
       
        sender.isEnabled = false
       
        
        FireStoreManager.shared.uploadAndGetDataURLs(accomodation!.photo!) { (downloadURLs, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                sender.isEnabled = true
            } else {
                print("Download URLs: \(downloadURLs)")

                let photoArray = downloadURLs.map { $0.absoluteString }

                var accomodationModel = AccomodationModel(name: self.accomodation!.name!, listingType: self.accomodation!.listingType!, propertyCategory: self.accomodation!.propertyCategory!, location: self.accomodation!.location!, photo: self.accomodation!.photo!, rentPrice: self.rentPriceTxt.text!, bedroom: self.accomodation!.bedroom!, bathroom: self.accomodation!.bathroom!, facility: ["NA"], photoUrl: photoArray)
                
                accomodationModel.addedByEmail = UserDefaultsManager.shared.getEmail()
                accomodationModel.addedByMobile = UserDefaultsManager.shared.getMobile()
                accomodationModel.addedByName = UserDefaultsManager.shared.getName()
                
                FireStoreManager.shared.addMarketPlace(accomodation: accomodationModel) { success in
                    if success {
                        
                        let email = UserDefaultsManager.shared.getEmail()
                        let currentDate = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
                            
                        let emailBody = "Thank you for adding the Market Place Item. Your Market Place Item (\(accomodationModel.name!)) was added successfully on \(currentDate)!"
                                
                        let subject = "Market Place Added Item successfully Student Information Exchange App"
                        
                        ForgetPasswordManager.sendOtherEmail(emailTo: email, body: emailBody,subject: subject) { _ in }
                        
                        
                        showOkAlertAnyWhereWithCallBack(message: "Market Place Item added successfully!!") {
                            DispatchQueue.main.async {
                                SceneDelegate.shared?.loginCheckOrRestart()
                            }
                        }
                    }
                }
            }
        }
    }
    
}
    
 
