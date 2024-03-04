
import UIKit

class CreateEventVC: UIViewController {
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    let globalPicker = GlobalPicker()
    let datePicker = UIDatePicker()
    var photoSelected = false
    var dateSelected = false
    var eventTimeStamp = 0.0
    
    @IBAction func onDateAndTime(_ sender: Any) {

        let dateTimePicker = GlobalDateTimePicker()
        dateTimePicker.uIDatePickerMode = .date
        dateTimePicker.modalPresentationStyle = .overCurrentContext
        dateTimePicker.onDone = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            let dateString = formatter.string(from: date)
            self.dateTime.text = dateString
            self.dateSelected = true
            self.eventTimeStamp = getTimeDouble(date: date)
        }
       
        self.present(dateTimePicker, animated: true)
    }

    
    @IBAction func onPhoto(_ sender: Any) {
        self.view.endEditing(true)
        let sourceType: UIImagePickerController.SourceType = .photoLibrary

        presentImagePickerController(sourceType: sourceType) { (selectedImage) in
            
            if let image = selectedImage {
                self.selectedImage.image = image
                self.photoSelected = true
            }
        }
    }
    @IBAction func onCreateEvent(_ sender: Any) {
      
        self.view.endEditing(true)
        
        if(self.eventName.text!.isEmpty) {
            showAlerOnTop(message: "Please enter event name")
            return
        }
        
        if(self.eventDescription.text!.isEmpty) {
            showAlerOnTop(message: "Please enter event description")
            return
        }
        
        if(self.location.text!.isEmpty) {
            showAlerOnTop(message: "Please enter event location")
            return
        }
        
        if(!dateSelected) {
            showAlerOnTop(message: "Please enter date")
            return
        }
        
        if(!photoSelected) {
            showAlerOnTop(message: "Please add event image")
            return
        }
        
        
        FireStoreManager.shared.saveImage(image: selectedImage.image!) { imageUrl in
             
            let dateTime = self.dateTime.text!.components(separatedBy: " ")
            
            let date = dateTime[0]
            let time = dateTime[1]
            
            FireStoreManager.shared.createEvent(eventName: self.eventName.text!, eventDescription: self.eventDescription.text!, location: self.location.text!, date: date, time: time, imageUrl: imageUrl, eventTime:self.eventTimeStamp) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

 

func getTimeDouble(date:Date)-> Double {
    return Double(date.millisecondsSince1970)
}
