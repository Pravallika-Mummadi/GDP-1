
import UIKit

var chatListVC : ChatListVC?

class ChatListVC: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
   var allContacts: [User] = []
   var filteredContacts: [User] = []
   var lastMessages: [LastChatModel] = [] {
            didSet {
                lastMessages.sort(by: { $0.lastMessageDate > $1.lastMessageDate })
                tableView.reloadData()
            }
   }
   var selectedIndex = 0
   override func viewDidLoad() {
       super.viewDidLoad()
       chatListVC = self
       print(UserDefaultsManager.shared.getMobile())
       FireStoreManager.shared.checkLastMessages()
       self.lastMessages = FireStoreManager.shared.lastMessagesData
       self.tableView.registerCells([ChatListCell.self])
       self.tableView.delegate = self
       self.tableView.dataSource = self
       self.tableView.showsVerticalScrollIndicator = false
       self.searchTextField.delegate = self
       
       FireStoreManager.shared.getAllUsers { users in
           
           if(users.count > 0) {
               self.allContacts = users.sorted(by: { $0.name! < $1.name! })
               self.filteredContacts = self.allContacts
               self.tableView.reloadData()
           }
        
       }
       
       navigationController?.setNavigationBarHidden(true, animated: true)
   }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        selectedIndex = self.segment.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    // Add this function in your ChatListVC class
    func getContactName(for mobileNumber: String) -> String {
        let formattedMobileNumber = formatPhoneNumber(mobileNumber)
        
        if let contact = allContacts.first(where: { formatPhoneNumber($0.mobile!).contains(formattedMobileNumber) }) {
            return "\(contact.name!)"
        } else {
            return "Unknown Contact"
        }
    }
   
}



extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if(self.selectedIndex == 0) {
           return self.lastMessages.count
       }else {
           return filteredContacts.count
       }
   }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell = self.tableView.dequeueReusableCell(withIdentifier:"ChatListCell", for: indexPath) as! ChatListCell
     
       if(self.selectedIndex == 0) { // recent chat
           
           let lastMessage = self.lastMessages[indexPath.row]
           var senderOrSendToMobile = getFormatedNumber(mobile: lastMessage.sender ?? "")
           
           let myMobile = getMyFormatedMobile()
           
           if(myMobile == senderOrSendToMobile) { // means if sender is self then using send to to show other user number
               senderOrSendToMobile = getFormatedNumber(mobile: lastMessage.sendTo ?? "")
               
           }else {
               senderOrSendToMobile = getFormatedNumber(mobile: lastMessage.sender ?? "")
           }
           
           cell.contactName.text = getContactName(for: senderOrSendToMobile)
           cell.contactNumber.text = senderOrSendToMobile
           cell.boldLabel.text = cell.contactName.text?.first?.description
           cell.bgView.backgroundColor = getRandomColor()
           cell.lastMessage.text = lastMessage.lastMessageText
           cell.messageCount.text = lastMessage.messageCount.description
                if(lastMessage.messageCount.description == "0") {
                   cell.messageView.isHidden = true
              }else {
                   cell.messageView.isHidden = false
           }
           
           cell.lastMessage.text = lastMessage.lastMessageType?.rawValue
     
       }else {
           
           let contact = filteredContacts[indexPath.row]
           cell.contactName.text = "\(contact.name!)"
           cell.contactNumber.text = contact.mobile
           cell.boldLabel.text = contact.name?.first?.description
           cell.bgView.backgroundColor = getRandomColor()
           cell.messageView.isHidden = true
           cell.lastMessage.text = ""
           
       }
    
       return cell
       
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        
        if (self.selectedIndex == 0) {
            let lastMessage = self.lastMessages[indexPath.row]
            var senderOrSendToMobile = getFormatedNumber(mobile: lastMessage.sender ?? "")
            
            let myMobile = getMyFormatedMobile()
            
            if(myMobile == senderOrSendToMobile) { // means if sender is self then using send to to show other user number
                senderOrSendToMobile = getFormatedNumber(mobile: lastMessage.sendTo ?? "")
                
            }else {
                senderOrSendToMobile = getFormatedNumber(mobile: lastMessage.sender ?? "")
            }
           
            var firstName = getContactName(for: senderOrSendToMobile)
            
            if(firstName == "Unknown Contact") {
                firstName = senderOrSendToMobile
            }
            
          
            let mobileNumber = senderOrSendToMobile
            let formattedNumber = formatPhoneNumber(mobileNumber)
            print(formattedNumber)
            
           
                    let chatId = getChatID(email1: getMobile(), email2: formattedNumber)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                    vc.chatID = chatId
                    vc.chatWithName = firstName
                    vc.sendToMobile = formattedNumber
                    vc.lastChatModel = lastMessage
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    FireStoreManager.shared.resetMessageCount(mobile: getFormatedNumber(mobile:getMobile()),chatID:chatId)
                    
            
        }else {
            
            let contact = filteredContacts[indexPath.row]
            let mobileNumber = contact.mobile!
            let formattedNumber = formatPhoneNumber(mobileNumber)
            print(formattedNumber)
            
            if mobileNumber.contains(getMyFormatedMobile())  {
             
                return
            }
            
            
            
            let chatId = getChatID(email1: getMobile(), email2: formattedNumber)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.chatID = chatId
            vc.chatWithName = contact.name!
            vc.sendToMobile = formattedNumber
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            FireStoreManager.shared.resetMessageCount(mobile: getFormatedNumber(mobile:getMobile()),chatID:chatId)
            
        }
        
    }


}



extension ChatListVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
          performSearch(searchText: currentText.lowercased())
          return true
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
   
   func performSearch(searchText: String) {
       if searchText.isEmpty {
           self.filteredContacts = allContacts
       } else {
           filteredContacts = allContacts.filter { contact in
               let contactText = "\(contact.name!) \(contact.mobile!)".lowercased()
               return contactText.contains(searchText)
           }
       }
       tableView.reloadData()
   }
}

func getRandomColor() -> UIColor {
     //Generate between 0 to 1
     let red:CGFloat = CGFloat(drand48())
     let green:CGFloat = CGFloat(drand48())
     let blue:CGFloat = CGFloat(drand48())

    return UIColor(red:red, green: green, blue: blue, alpha: 0.2)
}
