//
//  ViewController.swift
//  FirebaseApp
//
//  Created by Сергей Иванов on 29.10.2020.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
