//
//  ViewController.swift
//  FirebaseApp
//
//  Created by Сергей Иванов on 29.10.2020.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemTeal
        cell.textLabel?.text = "cell \(indexPath.row)"
        return cell
    }
    
    @IBAction func onAdd(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let alert = UIAlertController(title: "New task", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] _ in
            guard let text = alert.textFields?.first?.text else { return }
            if text != "" {
                let task = Task(uid: userID, title: text)
                self.ref.child("users").child(task.uid).child("tasks").childByAutoId().setValue(task.toDictionary())
                
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField() {
            textField in
            textField.placeholder = "Title"
        }
        present(alert, animated: true)
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
     do {
       try firebaseAuth.signOut()
       dismiss(animated: true, completion: nil)
     } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError.localizedDescription)
     }
    }
}
