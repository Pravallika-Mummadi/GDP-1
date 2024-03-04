
import UIKit


struct Events: Codable {
   
   var eventName,eventDescription,imageUrl,location,documentId,createdByEmail,createdByName:String
   var eventTime : Double?
}

 
            
//struct Events : Codable {
//   var eventTitle: String
//   var details: String
//   var documentId:String?
//   var createdByEmail:String?
//   var createdByName:String?
//}


class EventsListVC: UIViewController {

   var myDataOnly = false
   @IBOutlet weak var addButton: ButtonWithShadow!
   @IBOutlet weak var tableView: UITableView!
   var documentId = ""
   var events = [Events]()
   var hideShowButon = false
   override func viewDidLoad() {
       self.addButton.isHidden = hideShowButon
       self.tableView.registerCells([EventListCell.self])
       self.tableView.delegate = self
       self.tableView.dataSource = self
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
       self.events.removeAll()
       self.tableView.isHidden = true
       FireStoreManager.shared.getAllEvents(myDataOnly: myDataOnly) { events in
           self.events.removeAll()
           self.events = events
           self.tableView.reloadData()
           self.tableView.isHidden = (self.events.isEmpty)
       }
   }
   
   @IBAction func onAdd(_ sender: Any) {
       
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventVC
       vc.modalPresentationStyle = .fullScreen
       self.navigationController?.pushViewController(vc, animated: true)
   }
   
}

extension EventsListVC: UITableViewDelegate, UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return events.count
   }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditEventVC") as! EditEventVC
        vc.modalPresentationStyle = .fullScreen
        vc.event = self.events[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "EventListCell") as! EventListCell
       let date =/* events[indexPath.row].eventName */  "\n" +  (events[indexPath.row].eventTime?.getFirebaseDateTime())!
       cell.setData(title: events[indexPath.row].eventName + date, desc: events[indexPath.row].eventDescription)
       return cell
   }
    
}
