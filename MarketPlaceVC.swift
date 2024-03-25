 
import UIKit
import SDWebImage

class MarketPlaceVC: UIViewController {
    
    var myAccomodationOnly = false
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var searchTextField: UITextField!
    
    var filteredAccomodations: [AccomodationModel] = []

    
    var allAccomodations: [AccomodationModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Market Place"

        searchTextField.delegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.setAccomodations()
    }

    // Action method for the plus button tap
    @objc func addButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AddMarketPlaceVC" ) as! AddMarketPlaceVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setAccomodations() {
        
        if(myAccomodationOnly) {
            
            FireStoreManager.shared.getMyPostingMarketPlace { accomodation in
                self.allAccomodations = accomodation
                self.filteredAccomodations = accomodation
                self.collectionView.reloadData()
            }
            
        }else {
            
            FireStoreManager.shared.getAllAccomodationMarketPlace { accomodation in
                self.allAccomodations = accomodation
                self.filteredAccomodations = accomodation
                self.collectionView.reloadData()
            }
            
        }
       
    }
}


extension MarketPlaceVC : UITextFieldDelegate {
    
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
                filteredAccomodations = allAccomodations.filter { ($0.name! + $0.location!).lowercased().contains(searchText.lowercased()) }
            }

            // Reload the collection view to reflect the changes
            collectionView.reloadData()
            
            if filteredAccomodations.isEmpty {
                    showAlerOnTop(message: "No results found for '\(searchText)'")
            }
        }
}

extension MarketPlaceVC: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredAccomodations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell

        let item = filteredAccomodations[indexPath.item]
        cell.imageview.layer.cornerRadius = 10.0
        cell.imageview.clipsToBounds = true
        cell.textLable.text = item.name!
        cell.location.text = item.location!
        cell.rating.text = item.rating!.description
        cell.heart.isHidden = true
        
        let url = item.photoUrl!.first!.encodedURL().toURL()
        cell.imageview.sd_setImage(with: url, placeholderImage:nil,options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            
        })
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "MarketPlaceItemDetailsVC" ) as! MarketPlaceItemDetailsVC
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
