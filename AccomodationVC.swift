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

struct aImageTitleItem {
    var image: UIImage
    var title: String
}

class AccomodationVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var aimageTitleArray: [aImageTitleItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Accomodation"

        let item1 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "Bungalow House")
        let item2 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "Bridgeland Modern House")
        let item3 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "mili sper House")
        let item4 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "Flower Heaven Apartment")
        let item5 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "Bungalow House")
        let item6 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "Heaven Modern House")
        let item7 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "mili sper House")
        let item8 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "Flower Heaven Apartment")
        let item9 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "Holder House")
        let item10 = aImageTitleItem(image: UIImage(named: "Accomodation")!, title: "Bungalow House")

        aimageTitleArray = [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10]
        
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


extension AccomodationVC: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aimageTitleArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell

        let item = aimageTitleArray[indexPath.item]
        cell.imageview.image = item.image
        cell.imageview.layer.cornerRadius = 10.0
        cell.imageview.clipsToBounds = true
        cell.textLable.text = item.title

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
