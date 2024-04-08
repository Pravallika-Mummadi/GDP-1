
import UIKit
import MapKit

class RideVC: UIViewController {
   @IBOutlet weak var pickupLocation: UIButton!
   @IBOutlet weak var pickupTime: UIButton!
   @IBOutlet weak var dropLocation: UIButton!
   @IBOutlet weak var dropTime: UIButton!
   var dateFormatter = DateFormatter()
   let dateTimePicker = GlobalDateTimePicker()
   var pickupTimeStamp = Double()
   var selected = "Pick"
   
   override func viewDidLoad() {
       dateFormatter = DateFormatter.POSIX()
       dateFormatter.dateFormat = "dd-MMMM-yyyy h:mm a"
       dateTimePicker.uIDatePickerMode = .dateAndTime
       self.title = "Book Ride"
       let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
       navigationItem.rightBarButtonItem = addButton
   }
   
    @objc func plusButtonTapped() {
            
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "PostRideVC" ) as! PostRideVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
   @IBAction func onPickupLocation(_ sender: Any) {
       
       self.selected = "Pick"
       let mapKit = MapKitSearchViewController(delegate: self)
       mapKit.modalPresentationStyle = .fullScreen
       present(mapKit, animated: true, completion: nil)
       
   }
   
   @IBAction func onDropLocation(_ sender: Any) {
       self.selected = "Drop"
       let mapKit = MapKitSearchViewController(delegate: self)
       mapKit.modalPresentationStyle = .fullScreen
       present(mapKit, animated: true, completion: nil)
   }
   
   @IBAction func onPickupTime(_ sender: Any) {
       
       self.dateTimePicker.onDone = { date in
           self.pickupTime.setTitle(self.dateFormatter.string(from: date), for: .normal)
           
           let timestamp = date.timeIntervalSince1970
       
           self.pickupTimeStamp =  timestamp
       }
       
       self.dateTimePicker.modalPresentationStyle = .overCurrentContext
       self.present(self.dateTimePicker, animated: true, completion: nil)
   }
   
   @IBAction func onDropTime(_ sender: Any) {
       self.dateTimePicker.onDone = { date in
           self.dropTime.setTitle( self.dateFormatter.string(from: date), for: .normal)
        }
       self.dateTimePicker.modalPresentationStyle = .overCurrentContext
       self.present(self.dateTimePicker, animated: true, completion: nil)
   }
   
   @IBAction func onBooking(_ sender: UIButton) {
       

       guard let pickupTimeString = self.pickupTime.currentTitle,
             let dropTimeString = self.dropTime.currentTitle,
             let pickupTime = dateFormatter.date(from: pickupTimeString)else {
            showAlerOnTop(message: "Invalid pickup time")
             return
       }
       
 
       
       if self.pickupLocation.currentTitle! == "Select Pickup Location" {
           showAlerOnTop(message: "Please Select Pickup Location")
           return
       }

       if self.pickupTime.currentTitle! == "Select Pickup Time" {
           showAlerOnTop(message: "Please Select Pickup Time")
           return
       }

       if self.dropLocation.currentTitle! == "Select Drop Location" {
           showAlerOnTop(message: "Please Select Drop Location")
           return
       }

 
       pickedLocation = self.pickupLocation.currentTitle!
       
       sender.isEnabled = false
       
       FireStoreManager.shared.saveBooking(
              pickupLocation: self.pickupLocation.currentTitle!,
              pickupTime: self.pickupTime.currentTitle!,
              dropLocation: self.dropLocation.currentTitle!,
              dropTime: self.dropTime.currentTitle!
          ) { success in
              if success {
                  showOkAlertAnyWhereWithCallBack(message: "Booking successful") {
                      self.navigationController?.popViewController(animated: true)
                  }
              } else {
                  showOkAlertAnyWhereWithCallBack(message: "Error saving booking") {
                      self.navigationController?.popViewController(animated: true)
                  }
              }
        }
   }
}





extension RideVC: MapKitSearchDelegate {
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
       
       if(selected == "Pick") {
           self.pickupLocation.setTitle(mapItem.placemark.mkPlacemark!.description.removeCoordinates(), for: .normal)
       }else {
           self.dropLocation.setTitle(mapItem.placemark.mkPlacemark!.description.removeCoordinates(), for: .normal)
       }
   }
}

var pickedLocation = ""

extension DateFormatter {
   static func POSIX() -> DateFormatter {
       let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
       return dateFormatter
   }
}
 
