//
//  AccomodationDetailVC.swift
//  StudentInformationExchange
//
//  Created by Macbook-Air on 04/02/24.
//

import UIKit

struct OffersModel: Codable {
    var image: String?
}

class AccomodationDetailVC: UIViewController, TagListViewDelegate {
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    var allOffers:[OffersModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageSlideShow.clipsToBounds = true

        tagListView.delegate = self
        tagListView.addTag("TagListView")
        tagListView.addTag("TEAChart")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("Quark Shell")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("TagListView")
        tagListView.addTag("TEAChart")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("Quark Shell")


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
            if let imageUrlString = billboard.image?.encodedURL(), let url = URL(string: imageUrlString) {
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
