import UIKit

extension UIColor {
    static var appColor: UIColor {
        return UIColor.systemIndigo
    }
    
    static var greenColor: UIColor {
        return UIColor(hex: 0x63C694)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
 
