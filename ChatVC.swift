import UIKit
import Foundation
import FirebaseFirestore

var onChatScreen = false

class ChatVC: UIViewController {
   
    @IBOutlet weak var chatContainer: UIView!
    let id = getMobile()
    @IBOutlet weak var textView: TextViewWithPlaceholder!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var addImages: UIButton!
    @IBOutlet weak var sendMessageView: UIView!
    var chatID = ""
    var firstTimeAnimate = false
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    var chatWithName = ""
    var sendToMobile = ""
    var lastChatModel : LastChatModel?
    var messages = [MessageModel]()
    var senderId = getMobile()  
    var senderName = getMobile()
    
    func shortMessages() {
        messages = messages.sorted(by: {
            $0.getDate().compare($1.getDate()) == .orderedAscending
        })
    }

    func resetMessageCount() {
     
        if let userId = UserDefaultsManager.shared.getMobile() { // My-Id
            
            let userId = getFormatedNumber(mobile: userId)
        
            FireStoreManager.shared.tempListnerLastmsg = FireStoreManager.shared.lastMessages.document(userId).collection("chats").document(chatID).addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    
                } else {
                    
                    if let querySnapshot = querySnapshot {
                        
                        let data = try? querySnapshot.data(as: LastChatModel.self)
                        
                        if let data = data {
                          
                            FireStoreManager.shared.resetMessageCount(mobile: userId,chatID:self.chatID)
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    func getMessages() {
       FireStoreManager.shared.getLatestMessages(chatID: chatID) { (documents, error) in
            if let error = error {
                // Handle the error
                print("Error retrieving messages: \(error)")
            } else if let documents = documents {
                // Create an array to store MessageModel instances
                var messages = [MessageModel]()
                
                for document in documents {
                    let data = document.data()
                    
                    // Create a MessageModel instance from Firestore data
                    let message = MessageModel(data: data)
                    
                    // Append the message to the array
                    messages.append(message)
                }
                
                self.messages = messages
                self.shortMessages()
                self.reloadData()
                
            }
        }
    }

    @IBAction func onSend(_ sender: Any) {
        
        self.sendTextMessage(text: self.textView.text!)
    }
    
//
//    @IBAction func onAttachment(_ sender: Any) {
//
//        let actions = ["Gallary", "Camera"]
//
//        self.showActionSheetPopup(actionsTitle: actions, title: "Please Select", message: "") { selectedIndex in
//
//            switch selectedIndex {
//            case 0 :
//                
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = .photoLibrary
//                imagePicker.mediaTypes = ["public.image"]
//                DispatchQueue.main.async {
//                    self.present(imagePicker, animated: true, completion: nil)
//                }
//            
//                break
//            case 1 :
//                
//                let imagePicker = UIImagePickerController()
//                                   imagePicker.delegate = self
//                imagePicker.mediaTypes = ["public.image"]
//                imagePicker.sourceType = .camera
//                DispatchQueue.main.async {
//                                       self.present(imagePicker, animated: true, completion: nil)
//               }
//         
//            default : break
//            }
//        }
//        
//    }
    
    
}

extension ChatVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            picker.dismiss(animated: true, completion: nil)

            if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
                if mediaType == "public.image" {
                    // Handle the selected image
                    if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                        self.sendImageToChat(image: selectedImage)
                    }
                }
            }
        }
    
    
 
    func storePhotoToStorage(image:UIImage,chatId:String,completion: @escaping (String) -> Void) {
        
        FireStoreManager.shared.uploadPhoto(image: image, chatId: chatId) { url in
            
            completion(url)
        }
    }
    
    func sendImageToChat(image: UIImage){
        
      
        self.storePhotoToStorage(image:image, chatId: self.chatID) { photoUrl in
          
            FireStoreManager.shared.saveTextChat(sendToMobile: self.sendToMobile, userEmail: getMobile(), text:"", time: self.getTime(), chatID: self.chatID,messageType: .IMAGE, filePath: photoUrl)
            
        }
    
    }
    
    
         
        
//        let vc = UIStoryboard.confirmPhotoVC
//        vc.currentTask = self.currentTask
//        vc.tempImage = image
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
//
//        vc.onConfirm = {
//            self.currentTask.addSnap(photoUrl)
//            self.showNextTask()
//        }
//
//        vc.onReselect = {
//            print("ReSelect")
//        }
//
//        vc.onTakeMore = {
//            self.currentTask.addSnap(photoUrl)
//        }
    

    
}


extension ChatVC {
 
    
    func getTime()-> Double {
        return Double(Date().millisecondsSince1970)
    }
    
    func sendTextMessage(text: String) {
        
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !trimmedText.isEmpty else {
                return
            }
      
        FireStoreManager.shared.saveTextChat(sendToMobile: sendToMobile, userEmail: getMobile(), text:text, time: getTime(), chatID: chatID, messageType: .TEXT, filePath: "")
 
            self.textView.text = ""
    }
    
}


 
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        var message = messages[indexPath.row]
        
        if(message.messageType == .TEXT) {
            if message.sender ==  senderId {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatSenderTextMessageBubble") as! CometChatSenderTextMessageBubble
                cell.setData(message: message)
                cell.message.textColor = UIColor.black
              
                return cell
                
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatReceiverTextMessageBubble") as! CometChatReceiverTextMessageBubble
                message.senderName = chatWithName
                cell.setData(message: message)
                cell.message.textColor = UIColor.black
                
                let msgCount = lastChatModel?.messageCount ?? 0
                
                // Scroll to the last unread message if there are unread messages
                if msgCount > 0  && !messages.isEmpty {
                    let lastUnreadIndex = max(0, messages.count - msgCount)
                    let lastUnreadIndexPath = IndexPath(row: lastUnreadIndex, section: 0)
                    if(indexPath == lastUnreadIndexPath) {
                        cell.unReadHeader.isHidden = false
                     
                        if(msgCount == 1) {
                            cell.unReadMessageCount.text =  "1 Unread Message"
                        }else {
                            cell.unReadMessageCount.text =  "\(msgCount) Unread Messages"
                        }
                       
                    }else {
                        cell.unReadHeader.isHidden = true
                    }
                } else {
                    cell.unReadHeader.isHidden = true
                }
                return cell
               
            }
        }
        
         
        if(message.messageType == .IMAGE  ) {
            if message.sender ==  senderId {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatSenderImageMessageBubble") as! CometChatSenderImageMessageBubble
                cell.setData(message: message)
               
                cell.viewButton.onTap {
                     
                       self.title = "Back"
                        let url = message.filePath.encodedURL()
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PreviewVC") as! PreviewVC
                        vc.url = url
                        vc.topTitle =  "Preview"
                        vc.fileType = .IMAGE
                        vc.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    
                  
                }
                        
                return cell
                
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CometChatReceiverImageMessageBubble") as! CometChatReceiverImageMessageBubble
                message.senderName = chatWithName
                cell.setData(message: message)
                
                cell.viewButton.onTap {
                     
                        self.title = "Back"
                        let url = message.filePath.encodedURL()
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PreviewVC") as! PreviewVC
                        vc.url = url
                        vc.topTitle =  "Preview"
                        vc.fileType = .IMAGE
                        vc.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                  
                }
                
                
                return cell
               
            }
        }
        
       
        return UITableViewCell()
    }

    
    func getLastMessagesTintColor(for row: Int) -> UIColor {
        guard let lastChatModel = lastChatModel else {
            return .darkGray
        }

        let lastMessagesCount = lastChatModel.messageCount
        let messagesCount = messages.count

        // Check if the current message is within the last N messages
        if messagesCount - row <= lastMessagesCount {
            return .darkGray
        } else {
            return .red
        }
    }
 
   
}
 


extension ChatVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        onChatScreen = true
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width - 10)
        self.setTableView()
        self.setNameAndTitle()
        self.resetMessageCount()
        self.getMessages()
        self.title = chatWithName
        showBanner = false
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = UIColor.systemPink
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = .systemPink
       
        if let navigationBar = self.navigationController?.navigationBar {
                let textAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.systemPink
                ]
                navigationBar.titleTextAttributes = textAttributes
            }

        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onChatScreen = false
        FireStoreManager.shared.tempListnerLastmsg?.remove()
        FireStoreManager.shared.tempListnerLastmsg = nil
        showBanner = true
        NotificationCenter.default.removeObserver(self)
    }

    
    func setNameAndTitle() {
        self.navigationController?.title = "Chat"
    }
    
    func setTableView() {
        self.registerCells()

        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.title = chatWithName
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
   
    
    func registerCells() {
        self.tableView.register(UINib(nibName: "CometChatSenderTextMessageBubble", bundle: nil), forCellReuseIdentifier: "CometChatSenderTextMessageBubble")
        self.tableView.register(UINib(nibName: "CometChatReceiverTextMessageBubble", bundle: nil), forCellReuseIdentifier: "CometChatReceiverTextMessageBubble")
        
        self.tableView.register(UINib(nibName: "CometChatSenderImageMessageBubble", bundle: nil), forCellReuseIdentifier: "CometChatSenderImageMessageBubble")
        self.tableView.register(UINib(nibName: "CometChatReceiverImageMessageBubble", bundle: nil), forCellReuseIdentifier: "CometChatReceiverImageMessageBubble")
        
        self.tableView.register(UINib(nibName: "ChatReceiverLocation", bundle: nil), forCellReuseIdentifier: "ChatReceiverLocation")
        
        self.tableView.register(UINib(nibName: "ChatSenderLocation", bundle: nil), forCellReuseIdentifier: "ChatSenderLocation")
        self.tableView.register(UINib(nibName: "ContactSender", bundle: nil), forCellReuseIdentifier: "ContactSender")
        self.tableView.register(UINib(nibName: "ContactReceiver", bundle: nil), forCellReuseIdentifier: "ContactReceiver")
        self.tableView.register(UINib(nibName: "FileSender", bundle: nil), forCellReuseIdentifier: "FileSender")
        self.tableView.register(UINib(nibName: "FileReceiver", bundle: nil), forCellReuseIdentifier: "FileReceiver")

    }
    
    func reloadData() {
        self.tableView.reloadData()

        // Scroll to the last unread message if there are unread messages
        if lastChatModel?.messageCount ?? 0 > 0 && !messages.isEmpty {
            let lastUnreadIndex = max(0, messages.count - (lastChatModel?.messageCount ?? 0))
            let lastUnreadIndexPath = IndexPath(row: lastUnreadIndex, section: 0)
            self.tableView.scrollToRow(at: lastUnreadIndexPath, at: .middle, animated: firstTimeAnimate)
            self.firstTimeAnimate = true
        } else if !messages.isEmpty {
            // If there are no unread messages, scroll to the absolute last message
            let lastRowIndex = IndexPath(row: messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: lastRowIndex, at: .bottom, animated: firstTimeAnimate)
            self.firstTimeAnimate = true
        }
    }
    
    //Add this function below
    func updateTableContentInset() {
        let numRows = self.tableView.numberOfRows(inSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
 
    }
}


func getChatID(email1: String, email2: String) -> String {
    let comparisonResult = email1.compare(email2)
    if comparisonResult == .orderedAscending {
        return email1 + email2
    } else {
        return email2 + email1
    }
}

func getMobile()->String {
    let mobileNo = UserDefaultsManager.shared.getMobile()!
    print(mobileNo)
    return mobileNo
}

func getStatusByValue(status:Int)->String {
    
    if(status == 0) {
        return "Pending"
    }
    
    if(status == 1) {
        return "Accepted By Donor"
    }
    
    if(status == 2) {
        return "Accepted By Paitent"
    }
    
    if(status == 3) {
        return "Blood Donneted"
    }
    
    if(status == -1) {
        return "Cancelled By Donor"
    }
    
    if(status == -2) {
        return "Cancelled By Paitent"
    }
    
    return "Pending"
}


func getMyFormatedMobile()->String {
    let mobileNo = getFormatedNumber(mobile: UserDefaultsManager.shared.getMobile() ?? "0000")
    return mobileNo
}



 
 

extension ChatVC {

    @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                // Adjust the bottom constraint based on the keyboard height
                viewBottomConstraint.constant = keyboardSize.height - 20
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }

        @objc func keyboardWillHide(_ notification: Notification) {
            // Reset the bottom constraint when the keyboard hides
            viewBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    
   
    
}
 
