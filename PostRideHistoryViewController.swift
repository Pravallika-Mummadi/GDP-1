import UIKit

class PostRideHistoryViewController: UIViewController {

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
        FireStoreManager.shared.getPostBookingHistory { bookings in
            self.bookings = bookings
            self.tableView.reloadData()
        }
    }
}

extension PostRideHistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListCell
        let booking = bookings[indexPath.row]

        let desc = """
            Pickup: \(booking.pickupLocation)
            Pickup Time: \(booking.pickupTime)
            
            Drop: \(booking.dropLocation)
            Drop Time: \(booking.dropTime)
            
            Passengers: \(booking.passangers ?? 0)
            """
        
        
        cell.setData(title: "Ride \(indexPath.row + 1)", desc:desc)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
    }
}
