
//
//  AccomodationDetailVC.swift
//  StudentInformationExchange
//
//  Created by Macbook-Pro on 14/12/23.
//

import UIKit

struct OffersModel: Codable {
    var photoUrl: String?
}

var selectedAccomodation : Accomodation!


class AccomodationDetailVC: UIViewController, TagListViewDelegate {
    @IBOutlet weak var tagListView: TagListView?
    var allOffers:[OffersModel] = []
    
     var accomodationTitle: UILabel!
     var accomodationLocation: UILabel!
     var accomodationPrice: UILabel!
     var imageSlideShow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accomodationTitle = (self.view.viewWithTag(10)! as! UILabel)
        accomodationLocation = (self.view.viewWithTag(11)! as! UILabel)
        accomodationPrice = (self.view.viewWithTag(12)! as! UILabel)
        imageSlideShow = (self.view.viewWithTag(13)! as! ImageSlideshow)
        
        
        
        self.imageSlideShow.clipsToBounds = true
 
        self.setImagesInModel()
        
        
        self.accomodationTitle.text = selectedAccomodation.title
        self.accomodationLocation.text = selectedAccomodation.location
        self.accomodationPrice.text =  "$\(selectedAccomodation.price)"
        
        
        if let tagListView  = self.tagListView {
            
            tagListView.delegate = self
     
            
            for item in selectedAccomodation.facility {
                tagListView.addTag(item)
            }
          
            tagListView.isUserInteractionEnabled = false
        }
       
        self.setupImageSlideShow()
    }
    

    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }

    func setupImageSlideShow() {
        
        let sdWebImageSource = self.allOffers.compactMap { billboard -> SDWebImageSource? in
            if let imageUrlString = billboard.photoUrl?.encodedURL(), let url = URL(string: imageUrlString) {
                return SDWebImageSource(url: url)
            }
            return nil
        }
        
        imageSlideShow.slideshowInterval = 3.0
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
        imageSlideShow.pageIndicator = pageControl
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.delegate = self
        imageSlideShow.setImageInputs(sdWebImageSource)
        
    }
    
    @IBAction func onApplyNow(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "BookAccomodationVC" ) as! BookAccomodationVC
                
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AccomodationDetailVC: ImageSlideshowDelegate {
        
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
    }
 }


extension AccomodationDetailVC {
    
    
 
    
    
 

    func setImagesInModel() {
       
        
        let imageUrls = [
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F1.jpg?alt=media&token=707d198d-1449-4d45-931a-e045491b18e2",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F10.jpg?alt=media&token=1a34cc7d-d3eb-4c2d-9d32-3b372364c8a3",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F11.jpg?alt=media&token=e9b640fb-d34f-4294-aedb-ae01e3826221",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F9.jpg?alt=media&token=ddb68111-75df-4711-a144-4897b42c6e3c",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F2.jpg?alt=media&token=26e0089d-2a9b-4485-803e-5874ef980eea",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F3.jpg?alt=media&token=554dc59d-8236-44b9-a87a-77553be51982",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F4.jpg?alt=media&token=fa4dc835-274f-453b-a4b1-c5754c43c2bf",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F5.jpg?alt=media&token=99226017-87b5-4f12-a782-1fb5dc911eb3",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F6.jpg?alt=media&token=88ecbb34-6111-468e-830a-1d27eb0476d6",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F7.jpg?alt=media&token=d412734d-c5d4-4377-b409-ee0515a61c5c",
            "https://firebasestorage.googleapis.com/v0/b/studentinformationexchan-4fd3f.appspot.com/o/tempImages%2F8.jpg?alt=media&token=d403574a-982c-4f2f-934b-f97f80b0466c"
        ]
        
        let shuffledImageUrls = imageUrls.shuffled()

          // Take the first 3 elements
        let randomImageUrls = Array(shuffledImageUrls.prefix(4))


        // Create OffersModel instances with the provided image URLs
        for imageUrl in randomImageUrls {
            let offer = OffersModel(photoUrl: imageUrl)
            allOffers.append(offer)
        }
    }
    
    
    
}
