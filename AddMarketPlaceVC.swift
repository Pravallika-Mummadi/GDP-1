 
import UIKit

var moveFromAddMarketPlace = false

class AddMarketPlaceVC: UIViewController, TagListViewDelegate {
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var tagListView1: TagListView!
    @IBOutlet weak var name: UILabel!

    var listingArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        moveFromAddMarketPlace = true 
        self.navigationItem.title = "Add Listing"

        self.name.text = "Hey, \(UserDefaultsManager.shared.getName()) Fill detail of your real estate"

        tagListView1.delegate = self
        
        tagListView1.tag = 0
        
        tagListView1.addTag("Rent")
        tagListView1.addTag("Sell")

    }
    

    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        if sender.tag == 0 {

            if listingArray.contains(title) {
                if let index = listingArray.firstIndex(of: title) {
                    listingArray.remove(at: index)
                }
            } else {
                listingArray.append(title)
            }

        }
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }

    @IBAction func onNext(_ sender: Any) {
        
        if(nameTxt.text!.isEmpty) {
            showAlerOnTop(message: "Please enter name")
            return
        }
    
        
        if(self.listingArray.count == 0) {
            showAlerOnTop(message: "Please select listing type")
            return
        }
        
        
        let accomodationModel = AccomodationModel(name: self.nameTxt.text ?? "", listingType: self.listingArray, propertyCategory: ["NA"], location: "", photo: [], rentPrice: "", bedroom: "", bathroom: "", facility: [""], photoUrl: [])
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AccomodationLocationVC" ) as! AccomodationLocationVC
                
        vc.accomodation = accomodationModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
