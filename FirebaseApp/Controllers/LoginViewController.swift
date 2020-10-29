//
//  ViewController.swift
//  FirebaseApp
//
//  Created by Сергей Иванов on 29.10.2020.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
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
            print("Created: \(user.email!)")
        }
    }
}

