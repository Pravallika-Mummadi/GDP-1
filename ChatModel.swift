import Foundation
struct MessageModel {
    var sender: String
    var dateSent: Double
    var chatId: String
    var text: String
    var senderName: String
    var messageType: MessageType
    var filePath: String
    
    // Add an initializer to create a MessageModel from Firestore data
    init(data: [String: Any]) {
        self.sender = data["sender"] as? String ?? ""
        self.dateSent = data["dateSent"] as? Double ?? 0.0
        self.chatId = data["chatId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.filePath = data["filePath"] as? String ?? ""
        self.senderName = data["senderName"] as? String ?? ""
        // Use MessageType enum for messageType
        
            if let messageTypeString = data["messageType"] as? String,
               let messageType = MessageType(rawValue: messageTypeString) {
                self.messageType = messageType
            } else {
                // Default to an appropriate value if the enum case is not found
                self.messageType = .TEXT
            }
        
    }
    
    func getDate() -> Date {
        Date(timeIntervalSince1970: dateSent)
    }
    
    func getDataString() -> String {
        let date = Date(timeIntervalSince1970: dateSent)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

