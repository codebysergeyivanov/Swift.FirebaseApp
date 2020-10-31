//
//  ViewController.swift
//  FirebaseApp
//
//  Created by Сергей Иванов on 29.10.2020.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
        self.password.delegate = self
        
        ref = Database.database().reference()
        errorLabel.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return false
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameNSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let kbFrame = kbFrameNSValue.cgRectValue
        let kbH = kbFrame.height
        
        let sv = self.view as! UIScrollView
        sv.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbH)
        sv.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbH, right: 0)
        
    }
    
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        username.text = ""
        password.text = ""
        handle = Auth.auth().addStateDidChangeListener { [unowned self] (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "goToMain", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
      }
    
    func errorHandler() {
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseOut, animations: {
            self.errorLabel.alpha = 1
        }, completion: { [unowned self] _ in
            self.errorLabel.alpha = 0
        })
    }
    
    @IBAction func singIn() {
        guard let email = username.text, let password = password.text, email != "", password != "" else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.errorHandler()
                print(error!.localizedDescription)
                return }
            print("Logined: \(user.email!)")
        }
    }
    
    @IBAction func registration() {
        guard let email = username.text, let password = password.text, email != "", password != "" else { return }
        Auth.auth().createUser(withEmail: email, password: password) {  [unowned self] authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.errorHandler()
                print(error!.localizedDescription)
                return }
            self.ref.child("users").child(user.uid).setValue(["email": email])
            print("Created: \(user.email!)")
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
