//
//  AccomodationVC.swift
//  StudentInformationExchange
//
//  Created by Macbook-Pro on 13/12/23.
//

import UIKit
 

enum aItemTitle: String {
    case accommodation = "Accommodation"
    case rides = "Rides"
    case market = "Market Place"
    case events = "Events"
    case university = "University Process Assistance"
    case profile = "Profile"
}

struct Accomodation {
    var image: UIImage
    var title: String
    var location: String
    var rating: Int
    var facility: [String]
    var price : Int
}

 

class AccomodationVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var searchTextField: UITextField!
    
    var filteredAccomodations: [Accomodation] = []

    
    var allAccomodations: [Accomodation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Accomodation"

        searchTextField.delegate = self
        
        
        allAccomodations = getAccomodations()
        
        self.filteredAccomodations = allAccomodations
        
        
        let layout = CollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout

        collectionView.dataSource = self
        collectionView.delegate = self

        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                 flowLayout.scrollDirection = .vertical
                 flowLayout.minimumLineSpacing = 0
                 flowLayout.minimumInteritemSpacing = 0
                 
                 // Calculate item size based on the collection view size
                 let collectionViewWidth = collectionView.frame.width
                 let collectionViewHeight = collectionView.frame.height
                 flowLayout.itemSize = CGSize(width: collectionViewWidth / 2, height: collectionViewHeight / 2)
             }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        // Set the button as the right navigation bar button item
        navigationItem.rightBarButtonItem = addButton
    }

    // Action method for the plus button tap
    @objc func addButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AddAccomodationVC" ) as! AddAccomodationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension AccomodationVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string.isEmpty) {
            filterAccomodations(with: "")
        }else {
            let currentText = (textField.text ?? "") + string
            filterAccomodations(with: currentText)
        }
          
           return true
     }
    // Function to filter accomodations based on search text
        func filterAccomodations(with searchText: String) {
            if searchText.isEmpty {
                // If search text is empty, show all accomodations
                filteredAccomodations = allAccomodations
            } else {
                // Filter accomodations based on title containing the search text
                filteredAccomodations = allAccomodations.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            }

            // Reload the collection view to reflect the changes
            collectionView.reloadData()
        }
}

extension AccomodationVC: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredAccomodations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell

        let item = filteredAccomodations[indexPath.item]
        cell.imageview.image = item.image
        cell.imageview.layer.cornerRadius = 10.0
        cell.imageview.clipsToBounds = true
        cell.textLable.text = item.title
        cell.location.text = item.location
        cell.rating.text = item.rating.description
        

//        let isFavourite = UserDefaultsManager.shared.getFavorites(title: item.title)
//        if(isFavourite ) {
//            cell.heart.setImage(UIImage(systemName:"heart.circle.fill"), for: .normal)
//            cell.heart.tintColor = UIColor.init(hex: 0x2BC990)
//        }else {
//            cell.heart.setImage(UIImage(systemName:"heart.circle"), for: .normal)
//            cell.heart.tintColor = .darkGray
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AccomodationDetailVC" ) as! AccomodationDetailVC
         selectedAccomodation = self.filteredAccomodations[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let spacingBetweenCells: CGFloat = 10
         let collectionViewWidth = collectionView.frame.width
         let cellWidth = (collectionViewWidth - spacingBetweenCells) / 2
         return CGSize(width: cellWidth, height: 215)
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 5
     }
}

func getAccomodations() -> [Accomodation] {
    
    let item1 = Accomodation(image: UIImage(named: "1")!, title: "Sunset View Villa", location: "Downtown Kansas City", rating: 5, facility: ["Gym", "Parking Lot", "Wi-Fi"], price: 220)
    
    let item2 = Accomodation(image: UIImage(named: "2")!, title: "Modern Oasis Residence", location: "Country Club Plaza", rating: 3, facility: ["Swimming Pool", "Tennis Court", "24-Hour Security"], price: 230)
    
    let item3 = Accomodation(image: UIImage(named: "3")!, title: "Serene Retreat House", location: "Westport", rating: 4, facility: ["Playground", "Spa", "Laundry Services"], price: 240)
    
    let item4 = Accomodation(image: UIImage(named: "4")!, title: "Urban Bloom Apartment", location: "Crossroads Arts District", rating: 5, facility: ["Pet-Friendly", "Conference Room", "Concierge Service"], price: 300)
    
    let item5 = Accomodation(image: UIImage(named: "5")!, title: "Cityscape Loft", location: "Union Hill", rating: 3, facility: ["Bike Storage", "Business Center", "Rooftop Terrace"], price: 350)
    
    let item6 = Accomodation(image: UIImage(named: "6")!, title: "Skyline Bliss House", location: "River Market", rating: 4, facility: ["Gym", "Parking Lot", "Wi-Fi"], price: 400)
    
    let item7 = Accomodation(image: UIImage(named: "7")!, title: "Royal Retreat Mansion", location: "Crown Center", rating: 4, facility: ["Swimming Pool", "Tennis Court", "24-Hour Security"], price: 180)
    
    let item8 = Accomodation(image: UIImage(named: "8")!, title: "Liberty Crossing Apartment", location: "The Crossroads at Liberty", rating: 2, facility: ["Playground", "Spa", "Laundry Services"], price: 230)
    
    let item9 = Accomodation(image: UIImage(named: "9")!, title: "Legends View House", location: "Legends Outlets Kansas City", rating: 4, facility: ["Pet-Friendly", "Conference Room", "Concierge Service"], price: 340)
    
    let item10 = Accomodation(image: UIImage(named: "10")!, title: "North Star Residence", location: "North Kansas City", rating: 1, facility: ["Bike Storage", "Business Center", "Rooftop Terrace"], price: 450)
    
    return [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10]
}



