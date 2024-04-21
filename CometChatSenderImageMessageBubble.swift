 
import UIKit
import SDWebImage
import AVFoundation
 
 
class CometChatSenderImageMessageBubble: UITableViewCell {
    
   
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var viewButton: UIButton!
    private static var thumbnailCache: [URL: UIImage] = [:]
   
    override func awakeFromNib() {
        
        self.imageContainer.maskedCorners(corners: [.bottomLeft , .topLeft , .topRight , .bottomRight], radius: 12)
        self.imageContainer.dropShadow()
        
        imageContainer.layer.cornerRadius = 12
        imageContainer.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            imageContainer.layer.borderColor = UIColor.systemFill.cgColor
        } else {
            imageContainer.layer.borderColor = UIColor.lightText.cgColor
        }
        imageContainer.clipsToBounds = true
    }
    
    func setData(message:MessageModel) {
        
        self.timeStamp.text = message.dateSent.getFirebaseDateTime()
        
        self.imageMessage.contentMode = .scaleAspectFill
        
        self.viewButton.setImage(UIImage(named: "trans"), for: .normal)
      
        if let url = URL(string: message.filePath.encodedURL() ) {
            
            if(message.messageType == .VIDEO) {
                self.viewButton.setImage(UIImage(named: "playButton"), for: .normal)
                if let cachedThumbnail = CometChatSenderImageMessageBubble.thumbnailCache[url] {
                                    // Use cached thumbnail if available
                                    self.imageMessage.image = cachedThumbnail
                                } else {
                                    generateThumbnail(for: url) { image in
                                        DispatchQueue.main.async {
                                            self.imageMessage.image = image
                                        }

                                        // Cache the generated thumbnail
                                        CometChatSenderImageMessageBubble.thumbnailCache[url] = image
                                    }
                }
            }else {
              
                self.imageMessage.sd_setImage(with: url, placeholderImage:nil,options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                    
                })
            }
        }
    
    }
    
}
func generateThumbnail(for videoURL: URL, completion: @escaping (UIImage?) -> Void) {
    DispatchQueue.global().async {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        // Set the time for the first frame (here, 0 represents the first second)
        let time = CMTime(value: 0, timescale: 1)

        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnailImage = UIImage(cgImage: thumbnailCGImage)

            // Dispatch UI update on the main thread
            DispatchQueue.main.async {
                completion(thumbnailImage)
            }
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            
            // Dispatch UI update on the main thread with nil image
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}
