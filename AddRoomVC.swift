//
//  AddRoomVC.swift
//  StudentInformationExchange
//
//  Created by Macbook-Pro on 16/12/23.
//

import UIKit

class AddRoomVC: UIViewController {
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var bathstepper: UIStepper!
    @IBOutlet weak var bedroomValue: UILabel!
    @IBOutlet weak var bathroomValue: UILabel!
    @IBOutlet weak var rentPriceTxt: UITextField!
    @IBOutlet weak var monthly: UIButton!
    @IBOutlet weak var yearly: UIButton!
    
    var priceType = "Monthly"

    var accomodation : AccomodationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        stepper.stepValue = 1
        stepper.value = 0
        bedroomValue.text = "\(Int(stepper.value))"
        
        bathstepper.minimumValue = 0
        bathstepper.maximumValue = 50
        bathstepper.stepValue = 1
        bathstepper.value = 0
        bathroomValue.text = "\(Int(bathstepper.value))"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.monthly.backgroundColor = UIColor.init(hex: 0x2BC990)
        self.monthly.titleLabel?.textColor = .white
        
        self.yearly.backgroundColor = UIColor.init(hex: 0xD4D3D6)
        self.yearly.titleLabel?.textColor = .darkGray

    }
    
    @IBAction func bedroomStepper(_ sender: Any) {
        bedroomValue.text = "\(Int(stepper.value))"
    }

    @IBAction func bathroomStepper(_ sender: Any) {
        bathroomValue.text = "\(Int(bathstepper.value))"
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
    
    @IBAction func onNext(_ sender: Any) {
        if(rentPriceTxt.text!.isEmpty) {
            showAlerOnTop(message: "Please enter price")
            return
        }
        
        if(bedroomValue.text == "0") {
            showAlerOnTop(message: "Please select bedroom")
            return
        }
        
        if(bathroomValue.text == "0") {
            showAlerOnTop(message: "Please select bathroom")
            return
        }
        
        let accomodationModel = AccomodationModel(name: accomodation?.name, listingType: accomodation?.listingType, propertyCategory: accomodation?.propertyCategory, location: accomodation?.location ?? "", photo: accomodation?.photo, rentPrice: "\(self.rentPriceTxt.text ?? "") / \(self.priceType)", bedroom: self.bedroomValue.text ?? "", bathroom: self.bathroomValue.text ?? "", facility: [""], photoUrl: [])

        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AddEnvironmentVC" ) as! AddEnvironmentVC
                
        vc.accomodation = accomodationModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
