import UIKit



struct Assistance: Codable {
   var service,details,documentId,createdByEmail,createdByName:String
}

class ProcessAssistanceVC: UIViewController {

   var myDataOnly = false
    
   @IBOutlet weak var addButton: ButtonWithShadow!
   @IBOutlet weak var tableView: UITableView!
   var documentId = ""
   var assistances = [Assistance]()
   var hideShowButon = false
   override func viewDidLoad() {
       self.addButton.isHidden = hideShowButon
       self.tableView.registerCells([EventListCell.self])
       self.tableView.delegate = self
       self.tableView.dataSource = self
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
       self.assistances.removeAll()
       self.tableView.isHidden = true
       FireStoreManager.shared.getAllAssistance(myDataOnly: myDataOnly) { assistances in
           self.assistances.removeAll()
           self.assistances = assistances
           self.tableView.reloadData()
           self.tableView.isHidden = (self.assistances.isEmpty)
       }
   }
   
   @IBAction func onAdd(_ sender: Any) {
       
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAssistance") as! AddAssistance
       vc.modalPresentationStyle = .fullScreen
       self.navigationController?.pushViewController(vc, animated: true)
   }
   
}

extension ProcessAssistanceVC: UITableViewDelegate, UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return assistances.count
   }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditEventVC") as! EditEventVC
//        vc.modalPresentationStyle = .fullScreen
//        vc.event = self.assistances[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//        
    }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "EventListCell") as! EventListCell
      
       cell.setData(title: assistances[indexPath.row].service , desc: assistances[indexPath.row].details)
       return cell
   }
    
}
