//
//  AddPhotosVC.swift
//  StudentInformationExchange
//
//  Created by Macbook-Pro on 16/12/23.
//

import UIKit

class AddPhotosVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var images: [UIImage] = []

    var accomodation : AccomodationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        let layout = CollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        self.nextBtn.isHidden = true
    }

    @objc func addButtonTapped() {
        // Open an image picker to allow the user to select images
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onNext(_ sender: Any) {
        
        if(images.count == 0) {
            showAlerOnTop(message: "Please select photo")
            return
        }
        
        
        let accomodationModel = AccomodationModel(name: accomodation!.name, listingType: accomodation!.listingType, propertyCategory: accomodation!.propertyCategory, location: accomodation!.location!, photo: self.images, rentPrice: "", bedroom: "", bathroom: "", facility: [""], photoUrl: [])

        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AddRoomVC" ) as! AddRoomVC
                
        vc.accomodation = accomodationModel
        self.navigationController?.pushViewController(vc, animated: true)
    }


    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! ImageCollectionViewCell
        cell.imageview.image = images[indexPath.item]
        cell.imageview.layer.cornerRadius = 20.0
        cell.imageview.clipsToBounds = true
        cell.deleteBtn.tag = indexPath.item
        cell.deleteBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let spacingBetweenCells: CGFloat = 10
         let collectionViewWidth = collectionView.frame.width
         let cellWidth = (collectionViewWidth - spacingBetweenCells) / 2
         return CGSize(width: cellWidth, height: 170)
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 5
     }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        images.remove(at: sender.tag)
        self.nextBtn.isHidden = images.count > 0 ? false : true
        collectionView.reloadData()
    }
}



extension AddPhotosVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            images.append(editedImage)
            self.nextBtn.isHidden = images.count > 0 ? false : true
            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
