import UIKit

 
class AppliedMarketPlaceHistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var bookings = [AppliedAccomodation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCells([EventListCell.self])
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }

    func loadData() {
        FireStoreManager.shared.getMyAppliedItem { acc in
            self.bookings = acc
            self.tableView.reloadData()
        }
    }
}

extension AppliedMarketPlaceHistoryVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListCell
        let booking = bookings[indexPath.row]

      
        let title = "Booking \(indexPath.row + 1)"
        let desc = """
            Purchase Date: \(booking.moveInDate ?? "")\n
            Item ID: \(booking.propertyId ?? "")\n
            """

        cell.setData(title: title, desc: desc)

        return cell
    }

  

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let booking = self.bookings[indexPath.row]
        
        FireStoreManager.shared.getAccomodationDetailsMarketPlace(documentId: booking.propertyId!) { data in
             
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "MarketPlaceItemDetailsVC" ) as! MarketPlaceItemDetailsVC
             selectedAccomodation =  data
             vc.moveFromHistory = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
       
    }
}
