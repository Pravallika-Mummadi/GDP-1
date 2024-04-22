import UIKit

class GlobalDateTimePicker: UIViewController {
    var onDone: ((Date) -> Void)?
    var onCancel: (() -> Void)?
    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    var uIDatePickerMode: UIDatePicker.Mode = .dateAndTime
    var doneButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versionss.
        }
        datePicker.datePickerMode = uIDatePickerMode
        datePicker.minimumDate = Date() // Set minimum date to today
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) // Set maximum date to 1 month from today
            
        
        view.backgroundColor = .clear
        
        // Create and set up the done button
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        doneButton.tintColor = .black
        let attributedDoneTitle = NSAttributedString(
            string: "Done",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: UIColor.appColor // You can set your desired color here
            ]
        )
        let doneCustomButton = UIButton()
        doneCustomButton.setAttributedTitle(attributedDoneTitle, for: .normal)
        doneCustomButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.customView = doneCustomButton
        
        // Create and set up the cancel button
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        cancelButton.tintColor = .black
        
        // Set up the toolbar items
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        view.addSubview(datePicker)
        view.addSubview(toolBar)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeAreaBottom = view.safeAreaInsets.bottom - 44
        
        datePicker.frame = CGRect(x: 0, y: view.frame.height - 280 - safeAreaBottom, width: view.frame.width, height: 280)
        toolBar.frame = CGRect(x: 0, y: view.frame.height - 280 - 44 - safeAreaBottom, width: view.frame.width, height: 44)
       // toolBar.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        toolBar.backgroundColor = .clear
        datePicker.backgroundColor = .white
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        

    }
    
    @objc func doneTapped() {
        onDone?(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelTapped() {
        onCancel?()
        dismiss(animated: true, completion: nil)
    }
}
 
