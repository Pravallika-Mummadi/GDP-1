//
//  AddEnvironmentVC.swift
//  StudentInformationExchange
//
//  Created by Macbook-Pro on 16/12/23.
//

import UIKit

class AddEnvironmentVC: UIViewController, TagListViewDelegate {
    @IBOutlet weak var tagListView2: TagListView!
    
    var accomodation : AccomodationModel?
    var listingArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Listing"
        
        tagListView2.delegate = self
    
        tagListView2.addTag("Parking Lot")
        tagListView2.addTag("Pet Allowed")
        tagListView2.addTag("Garden")
        tagListView2.addTag("Gym")
        tagListView2.addTag("Home theatre")
        tagListView2.addTag("Kid's Friendly")
        
    }
    
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        
        if listingArray.contains(title) {
            if let index = listingArray.firstIndex(of: title) {
                listingArray.remove(at: index)
            }
        } else {
            listingArray.append(title)
        }

    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
    
    @IBAction func onNext(_ sender: Any) {
        
        if(self.listingArray.count == 0) {
            showAlerOnTop(message: "Please select facility")
            return
        }
        
        
        FireStoreManager.shared.uploadAndGetDataURLs(accomodation?.photo ?? []) { (downloadURLs, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Download URLs: \(downloadURLs)")

                let photoArray = downloadURLs.map { $0.absoluteString }

                let accomodationModel = AccomodationModel(name: self.accomodation?.name, listingType: self.accomodation?.listingType, propertyCategory: self.accomodation?.propertyCategory, location: self.accomodation?.location ?? "", photo: self.accomodation?.photo, rentPrice: self.accomodation?.rentPrice ?? "", bedroom: self.accomodation?.bedroom ?? "", bathroom: self.accomodation?.bathroom ?? "", facility: self.listingArray, photoUrl: photoArray)

                FireStoreManager.shared.addAccomodation(accomodation: accomodationModel) { success in
                    if success {
                        showOkAlertAnyWhereWithCallBack(message: "Accomodation added successfully!!") {
                            DispatchQueue.main.async {
                                SceneDelegate.shared?.loginCheckOrRestart()
                            }
                        }
                    }
                }
            }
        }
        

    }
}
