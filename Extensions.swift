import UIKit




func showLoading() {
    ProgressHUD.show()
}

func hideLoading() {
    ProgressHUD.dismiss()
}




extension UIViewController {
    func presentImagePickerController(sourceType: UIImagePickerController.SourceType, completion: @escaping (UIImage?) -> Void) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.completion = completion
        present(imagePickerController, animated: true, completion: nil)
    }
}


extension UIImagePickerController {
    private struct AssociatedKeys {
        static var completion = "completion"
    }
    
    var completion: ((UIImage?) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.completion) as? ((UIImage?) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.completion, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        let image = info[.originalImage] as? UIImage
        picker.completion?(image)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        picker.completion?(nil)
    }
}



extension String {
    
    
    func emailIsCorrect() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\d{10}$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}

extension String {
    func encodedURL() -> String {
        
        return self.replacingOccurrences(of: " ", with: "%20")
        //return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

func showAlerOnTop(message:String){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
      // completion?(true)
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
}

func showOkAlertAnyWhereWithCallBack(message:String,completion:@escaping () -> Void){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
       completion()
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
  
}

func showConfirmationAlert(message: String, yesHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: yesHandler)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        UIApplication.topViewController()!.present(alertController, animated: true, completion: nil)
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}





extension UITableView {
    
    func registerCells(_ cells : [UITableViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: cell))
        }
    }
}

 
extension UICollectionView {
    
    func registerCells(_ cells : [UICollectionViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: cell))
        }
    }
}

 


extension String {
    // Encode string to base64
    func base64Encoded() -> String {
        let data = self.data(using: .utf8)
        return data?.base64EncodedString() ?? ""
    }

    // Decode base64 string
    func base64Decoded() -> String {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8) ?? ""
        }
        return ""
    }
}

extension Date {
    func chatTime(withFormat format: String = "MMM d HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Double {
    func getFirebaseDateTime(withFormat format: String = "MMM d HH:mm a") -> String {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000).chatTime(withFormat: format)
    }
}


extension Double {
    func convertMilliToDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }
}
extension Int {
    
    func convertMilliToDate(milliseconds: Int64) -> Date {
        return Date(timeIntervalSince1970: (TimeInterval(milliseconds) / 1000))
    }
    func convertDateFromStringToListing() -> (String,String) {
        let date = convertMilliToDate(milliseconds: Int64(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let timeString = timeFormatter.string(from: date)
        
        return  (dateString,timeString)
    }
    
}

extension Date {
    func dateBySubtractingMonths(_ months: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -months
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func dateByAddingMonths(_ months: Int) -> Date {
            var dateComponents = DateComponents()
            dateComponents.month = months
            return Calendar.current.date(byAdding: dateComponents, to: self)!
     }
}



extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

 

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}


extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension UIViewController {
    
    func showActionSheetPopup(actionsTitle:[String], title:String?,message:String,completion:@escaping (Int) -> Void){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 300, width: 300, height: 500)
        alert.view.tintColor = .appColor
        for (index,actionsTitle) in actionsTitle.enumerated(){
            
            alert.addAction(UIAlertAction(title: actionsTitle, style: UIAlertAction.Style.default, handler: {(UIAlertAction)in
                
                completion(index)
                
            }))}
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
