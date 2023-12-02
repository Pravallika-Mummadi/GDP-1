

import UIKit

enum ItemTitle: String {
    case accommodation = "Accommodation"
    case rides = "Rides"
    case market = "Market Place"
    case events = "Events"
    case university = "University Process Assistance"
    case profile = "Profile"
}

struct ImageTitleItem {
    var image: UIImage
    var title: ItemTitle
}

class HomeVC: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    var imageTitleArray: [ImageTitleItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.name.text = "Hey, \(UserDefaultsManager.shared.getName())"

        let item1 = ImageTitleItem(image: UIImage(named: "Accomodation")!, title: .accommodation)
        let item2 = ImageTitleItem(image: UIImage(named: "rides")!, title: .rides)
        let item3 = ImageTitleItem(image: UIImage(named: "market")!, title: .market)
        let item4 = ImageTitleItem(image: UIImage(named: "event")!, title: .events)
        let item5 = ImageTitleItem(image: UIImage(named: "university")!, title: .university)
        let item6 = ImageTitleItem(image: UIImage(named: "profile")!, title: .profile)

        imageTitleArray = [item1, item2, item3, item4, item5, item6]
        
        let layout = CollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout

        collectionView.dataSource = self
        collectionView.delegate = self

    }

}


extension HomeVC: UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageTitleArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell

        let item = imageTitleArray[indexPath.item]
        cell.imageview.image = item.image
        cell.textLable.text = item.title.rawValue

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = imageTitleArray[indexPath.item]

        switch item.title {
        case .profile:
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "ProfileVC" ) as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)

        case .accommodation:
            print("")
        case .rides:
            print("")

        case .market:
            print("")

        case .events:
            print("")

        case .university:
            print("")

        }

    }
}
