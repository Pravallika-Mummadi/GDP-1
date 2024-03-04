

import UIKit

class EditEventVC: UIViewController {
   
   var event:Events!
    
   @IBOutlet weak var eventName: UITextField!
   @IBOutlet weak var eventDescription: UITextView!
   @IBOutlet weak var location: UITextField!
   @IBOutlet weak var dateTime: UILabel!
   @IBOutlet weak var eventImage: UIImageView!
   var eventTimeStamp = 0.0
   var dateSelected = false
 
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var  deleteButton: UIButton!
    
    override func viewDidLoad() {
        self.deleteButton.isHidden = (event.createdByEmail != UserDefaultsManager.shared.getEmail())
        self.updateButton.isHidden = (event.createdByEmail != UserDefaultsManager.shared.getEmail())
        self.dateButton.isUserInteractionEnabled = (event.createdByEmail == UserDefaultsManager.shared.getEmail())
   }
    
    override func viewWillAppear(_ animated: Bool) {
         
        self.eventName.text = event.eventName
        self.eventDescription.text = event.eventDescription
        self.location.text = event.location
        self.dateTime.text = event.eventTime?.getFirebaseDateTime()
        
        let eventImageUrl = event.imageUrl
        
       
            if let imageURL = URL(string:  eventImageUrl),  eventImageUrl.count > 5 {
                let session = URLSession.shared
                let task = session.dataTask(with: imageURL) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.eventImage.image = image
                        }
                    }
                }
                task.resume()
            }

    }
   
   
    @IBAction func onDateAndTime(_ sender: Any) {

        let dateTimePicker = GlobalDateTimePicker()
        dateTimePicker.uIDatePickerMode = .dateAndTime
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

   
   @IBAction func onSave(_ sender: Any) {
     
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
     
       FireStoreManager.shared.updateEvent(event: self.event) { error in
                
               self.dismiss(animated: true)
       }
       
   }
     
   
   @IBAction func onDeleteEvent(_ sender: Any) {
       
       showConfirmationAlert(message: "Are you sure you want to delete?", yesHandler: { [weak self] _ in
           FireStoreManager.shared.deleteEvents(doucumentId: self!.event.documentId) { _ in
               self?.navigationController?.popViewController(animated: true)
           }
       })
   }
}


func getDateTime(date:Date)->String{
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM YYYY hh:mm a"
    let dateString = dateFormatter.string(from: date)
    return dateString
}
