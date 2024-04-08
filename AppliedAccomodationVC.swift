import UIKit

class AppliedAccomodationVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var bookings = [AppliedAccomodation]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.registerCells([EventListCell.self])
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Data
    private func loadData() {
        FireStoreManager.shared.getMyAppliedAccomodation { [weak self] acc in
            self?.bookings = acc
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension AppliedAccomodationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListCell
        let booking = bookings[indexPath.row]

        let title = "Booking \(indexPath.row + 1)"
        let desc = """
            Status: \(booking.status ?? "")
            Move-In Date: \(booking.moveInDate ?? "")
            Property ID: \(booking.propertyId ?? "")
            """

        cell.setData(title: title, desc: desc)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let booking = self.bookings[indexPath.row]
        
        FireStoreManager.shared.getAccomodationDetails(documentId: booking.propertyId!) { [weak self] data in
            guard let self = self else { return }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AccomodationDetailVC" ) as! AccomodationDetailVC
            selectedAccomodation =  data
            vc.moveFromHistory = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
