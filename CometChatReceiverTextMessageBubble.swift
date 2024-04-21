
import UIKit
class CometChatReceiverTextMessageBubble: UITableViewCell {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
     
    @IBOutlet weak var unReadMessageCount: UILabel!
    @IBOutlet weak var unReadHeader: UIView!
    @IBOutlet weak var name: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageView.maskedCorners(corners: [.bottomRight , .topLeft , .topRight], radius: 12)
        self.messageView.backgroundColor = .white
        self.message.textColor = .black
    }
    
   
    func setData(message:MessageModel) {
      
        
            self.message.text = message.text
       
        self.name.text = message.senderName
        self.timeStamp.text = message.dateSent.getFirebaseDateTime()
        self.message.textAlignment = .left
        
    }
   
}
 
