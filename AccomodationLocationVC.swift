//
//  AccomodationLocationVC.swift
//  StudentInformationExchange
//
//  Created by Macbook-Pro on 16/12/23.
//

import UIKit
import MapKit

class AccomodationLocationVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var locationTxt: UILabel!

    var accomodation : AccomodationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func onLocation(_ sender: Any) {
        let mapKit = MapKitSearchViewController(delegate: self)
        mapKit.modalPresentationStyle = .fullScreen
        present(mapKit, animated: true, completion: nil)
    }
    
    @IBAction func onNext(_ sender: Any) {
        
        if(locationTxt.text == "Select Location") {
            showAlerOnTop(message: "Please select location")
            return
        }
        
        let accomodationModel = AccomodationModel(name: accomodation?.name, listingType: accomodation?.listingType, propertyCategory: accomodation?.propertyCategory, location: self.locationTxt.text ?? "", photo: [], rentPrice: "", bedroom: "", bathroom: "", facility: [""], photoUrl: [])

        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AddPhotosVC" ) as! AddPhotosVC
                
        vc.accomodation = accomodationModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension AccomodationLocationVC: MapKitSearchDelegate {
    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, mapItem: MKMapItem) {
    }
    
    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, searchReturnedOneItem mapItem: MKMapItem) {
    }

    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedListItem mapItem: MKMapItem) {
    }

    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedGeocodeItem mapItem: MKMapItem) {
    }

    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedAnnotationFromMap mapItem: MKMapItem) {
        print(mapItem.placemark.address)
        
        mapKitSearchViewController.dismiss(animated: true)
        self.setAddress(mapItem: mapItem)
    }
    
    
    func setAddress(mapItem: MKMapItem) {
        
            self.locationTxt.text = mapItem.placemark.mkPlacemark!.description.removeCoordinates()
        
    }
    
}
