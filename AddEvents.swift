
import UIKit

class AddAssistance: UIViewController {
  
    @IBOutlet weak var eventitle: UITextField!
    @IBOutlet weak var details: UITextView!
  
    
    let campusCertificationDocumentAssistanceServices: [String] = [
        "Transcript preparation",
        "Diploma and degree certificate processing",
        "Letter of enrollment",
        "Academic recommendation letter writing",
        "Certification application assistance",
        "Verification document preparation",
        "Internship completion certificates",
        "Research project documentation",
    ]
    
   
    @IBAction func onServices(_ sender: Any) {
        
        let picker = GlobalPicker()
        picker.stringArray = campusCertificationDocumentAssistanceServices
               picker.onDone = { selectedIndex in
                   self.eventitle.text = self.campusCertificationDocumentAssistanceServices[selectedIndex]
               }
        picker.modalPresentationStyle = .overCurrentContext
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func onAdd(_ sender: Any) {
       
       if self.eventitle.text!.isEmpty{
            showAlerOnTop(message: "Please add Title")
            return
       }
       
       if self.details.text!.isEmpty{
            showAlerOnTop(message: "Please add Details")
            return
       }
       
       FireStoreManager.shared.createAssistance(name: eventitle.text!, desc: details.text!) {
          // showAlerOnTop(message: "Added Successfully")
           self.navigationController?.popViewController(animated: true)
       }
    
     }
       
   }


