 
import UIKit

class ForgotUpdatePasswordVC: UIViewController {
    @IBOutlet weak var temporaryPassword: UITextField!
    @IBOutlet weak var newpassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var tempPasswordSentOnEmail = ""
    var emailSentOn = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailSentOn = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAlerOnTop(message: "Please check your email box for Temporary password")
    }
    
    @IBAction func onSetNewPassword(_ sender: Any) {
        if validate(){
            if(self.temporaryPassword.text! != self.tempPasswordSentOnEmail) {
                showAlerOnTop(message: "Please enter correct Temporary password")
                return
            }
            
            else {
                let documentid = UserDefaults.standard.string(forKey: "documentId") ?? ""
                let userdata = ["password": (self.newpassword.text ?? "").base64Encoded()]
                FireStoreManager.shared.updatePassword(documentid: documentid, userData: userdata) { success in
                    if success {
                        showAlerOnTop(message: "Password Updated Successfully.")
                        
                        let body = "<h1>Your password has been changed</h1>";
        
                        let email = UserDefaultsManager.shared.getEmail()
                        
                        ForgetPasswordManager.sendPasswordChangedEmail(emailTo: email, body: body) { value in}
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func validate() ->Bool {
        
        if(self.temporaryPassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter Temporary Password.")
            return false
        }
        
        
        // Check if the temporary password has expired (more than 2 minutes)
        let currentTime = Date()
        let expirationTime = self.emailSentOn.addingTimeInterval(2 * 60) // 2 minutes
        if currentTime > expirationTime {
            showOkAlertAnyWhereWithCallBack(message: "Temporary password has expired. Please request a new one.") {
                self.navigationController?.popViewController(animated: true)
            }
            return false
        }

        
        
        if(self.newpassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter new password.")
            return false
        }
        if(self.confirmPassword.text!.isEmpty) {
             showAlerOnTop(message: "Please enter confirm password.")
            return false
        }
        
           if(self.newpassword.text! != self.confirmPassword.text!) {
             showAlerOnTop(message: "Password doesn't match")
            return false
        }
    
        return true
    }
    
    
    @IBAction func onShowHidePassword(_ sender: UIButton) {
        
        if(sender.tag == 1) {
            let buttonImageName = temporaryPassword.isSecureTextEntry ? "eye" : "eye.slash"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            self.temporaryPassword.isSecureTextEntry.toggle()
        }
       
        if(sender.tag == 2) {
            let buttonImageName = newpassword.isSecureTextEntry ? "eye" : "eye.slash"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            self.newpassword.isSecureTextEntry.toggle()
        }
        
        if(sender.tag == 3) {
            let buttonImageName = confirmPassword.isSecureTextEntry ? "eye" : "eye.slash"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            self.confirmPassword.isSecureTextEntry.toggle()
        }
       
    }
    
    
}
