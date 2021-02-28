////
////  OcclusionDelegate.swift
////  OnTheMap
////
////  Created by Jeremy MacLeod on 27/02/2021.
////
//
//import Foundation
//import UIKit
//import ObjectiveC
//
//// Associated keys allows us to store variables inside an extension.
//struct AssociatedKeys {
//    
//    static var activeTextField: UInt8 = 0
//    static var keyboardHeight: UInt8 = 1
//}
//
//// extension UIViewController: UITextFieldDelegate {
//    
//    
//    // This is the code that turns the keyboard methods into our variable in the associated keys struct.
//    private(set) var keyboardHeight: CGFloat? {
//        get {
//            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.keyboardHeight) as? CGFloat? else {
//                return 0.0
//            }
//            return value
//        }
//        set(newValue) {
//            objc_setAssociatedObject(self, &AssociatedKeys.keyboardHeight, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//        
//    }
//    
//    // This is the code that turns the texFieldDelegate methods into our variable in the associated keys struct.
//    
//    private(set) var activeTextField: UITextField? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.activeTextField) as? UITextField
//        }
//        set(newValue) {
//            objc_setAssociatedObject(self, &AssociatedKeys.activeTextField, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    
//    func disableUnoccludedTextField() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//    
//    func enableUnoccludedTextField() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//    
//    @objc func keyboardWillShow(notification: Notification) {
//        checkForOcclusion()
//    }
//    
//    @objc func keyboardWillHide(notification: Notification) {
//        if self.view.frame.origin.y != 0.0 {
//            self.view.frame.origin.y = 0.0
//        }
//        self.keyboardHeight = 0.0
//    }
//    
//    @objc func keyboardWillChangeFrame(notification: Notification) {
//        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//        self.keyboardHeight = keyboardFrame.height
//    }
//    
//    func checkForOcclusion() {
//        let bottomOfTextField = self.view.convert(CGPoint(x: 0, y: self.activeTextField!.frame.height), from: activeTextField!).y
//        let topOfKeyboard = self.view.frame.height - self.keyboardHeight!
//        
//        if bottomOfTextField > topOfKeyboard {
//            var offset = bottomOfTextField - topOfKeyboard
//            if self.view.frame.origin.y < 0 {
//                offset += 20.0
//            }
//            self.view.frame.origin.y = -1 * offset
//        } else {
//            self.view.frame.origin.y = 0
//        }
//    }
//    
//    public func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.activeTextField = textField
//        checkForOcclusion()
//    }
//    
//    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        self.activeTextField = nil
//    }
//    
//    public func textFieldShouldReturn( _ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return false
//    }
//    
//    
//}
