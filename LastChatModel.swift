import Foundation

struct LastChatModel: Codable {
    var lastMessageID: String?
    var lastMessageText: String
    var senderName: String?
    var sendTo: String?
    var documentId: String?
    var sender: String?
    var lastMessageDate: Double
    var messageCount: Int
    var lastMessageType: MessageType?
    var filePath:String?
    
    init(data: [String: Any]) {
        self.lastMessageID = data["lastMessageID"] as? String
        self.lastMessageText = data["lastMessageText"] as? String ?? ""
        self.senderName = data["senderName"] as? String
        self.sendTo = data["sendTo"] as? String
        self.documentId = data["documentId"] as? String
        self.filePath = data["filePath"] as? String
        self.sender = data["sender"] as? String
        self.lastMessageDate = data["lastMessageDate"] as? Double ?? 0.0
        self.messageCount = data["messageCount"] as? Int ?? 0
        
        if let messageTypeString = data["lastMessageType"] as? String,
           let messageType = MessageType(rawValue: messageTypeString) {
            self.lastMessageType = messageType
        } else {
            // Default to an appropriate value if the enum case is not found
            self.lastMessageType = .TEXT
        }
    }
    
    
    func getDataString()->String {
        let date = Date(timeIntervalSince1970: lastMessageDate)
        var lastMessageDatetring: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
        return lastMessageDatetring
    }
}
