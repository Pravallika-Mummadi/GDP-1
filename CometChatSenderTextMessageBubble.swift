import UIKit
import FirebaseFirestore

class CometChatSenderTextMessageBubble: UITableViewCell {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   
    func setData(message:MessageModel) {
     
         self.message.text = message.text
    
        self.timeStamp.text = message.dateSent.getFirebaseDateTime()
        
    }
    
}
    
    
 

