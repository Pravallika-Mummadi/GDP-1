
import UIKit

class BackButton: UIButton {
   
 
   override func awakeFromNib() {
       self.addTarget(self, action: #selector(goBack), for: .touchUpInside)
   }

   @objc func goBack(sender: UIButton) {
       
       if let viewController = findViewController() {
                   if let navController = viewController.navigationController {
                       // If the current view controller is in a navigation controller, pop it
                       navController.popViewController(animated: true)
                   } else {
                       // If the current view controller is not in a navigation controller, dismiss it
                       viewController.dismiss(animated: true, completion: nil)
                   }
         }
   }
    
    private func findViewController() -> UIViewController? {
           var responder: UIResponder? = self
           while let nextResponder = responder?.next {
               if let viewController = nextResponder as? UIViewController {
                   return viewController
               }
               responder = nextResponder
           }
           return nil
       }
    

}

