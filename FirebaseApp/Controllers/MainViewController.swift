//
//  ViewController.swift
//  FirebaseApp
//
//  Created by Сергей Иванов on 29.10.2020.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var tasks = Array<Task>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(userID).child("tasks").observe(.value, with: { [unowned self] (snapshot) in
            var _tasks = Array<Task>()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self.tasks = _tasks
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemTeal
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let taksUUID = tasks[indexPath.row].uuid
            let taskRef = ref.child("users").child(userID).child("tasks").child(taksUUID)
            taskRef.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath)
       let isCompleted = !tasks[indexPath.row].completed
       cell?.accessoryType = isCompleted ? .checkmark : .none
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let taksUUID = tasks[indexPath.row].uuid
        let taskRef = ref.child("users").child(userID).child("tasks").child(taksUUID)
        taskRef.updateChildValues(["completed": isCompleted])
    }
    
    @IBAction func onAdd(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let alert = UIAlertController(title: "New task", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] _ in
            guard let text = alert.textFields?.first?.text else { return }
            if text != "" {
                let ref = self.ref.child("users").child(userID).child("tasks").childByAutoId()
                let key = ref.key!
                let task = Task(uid: userID, uuid: key, title: text)
                ref.setValue(task.toDictionary())
                
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
