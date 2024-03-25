import UIKit

struct Booking: Codable {
    var pickupLocation: String
    var pickupTime: String
    var dropLocation: String
    var dropTime: String
    var documentId :String?
}

class RiderHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var bookings = [Booking]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCells([EventListCell.self])
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }

    func loadData() {
        FireStoreManager.shared.getBookingHistory { bookings in
            self.bookings = bookings
            self.tableView.reloadData()
        }
    }
}

extension RiderHistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
//tableview function is added
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListCell
        let booking = bookings[indexPath.row]

        // Customize the cell with booking details
        cell.setData(title: "Booking \(indexPath.row + 1)", desc: "Pickup:\n \(booking.pickupLocation)\n\nDrop:\n \(booking.dropLocation)")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection if needed
    }
}
