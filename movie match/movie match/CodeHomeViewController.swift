//
//  CodeHomeViewController.swift
//  movie match
//
//  Created by Ana Carolina Cunha on 5/13/21.
//

import UIKit
import Parse

class CodeHomeViewController: UIViewController {
    
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var maxUsersField: UITextField!
    @IBOutlet weak var invalidCodeLabel: UILabel!
    @IBOutlet weak var invalidNumberLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    
    
    //keeps track of the code so we can use it in following segue
    var code: String = ""
    //keeps track of total user to use in following segue
    var totalUsers: String = ""
    //keeps track of the users that have entered
    var currentUsers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hides invalid warnings
        invalidCodeLabel.isHidden = true
        invalidNumberLabel.isHidden = true

        //round button edges
        enterButton.layer.cornerRadius = 5
        generateButton.layer.cornerRadius = 5
        
        
    }
    

    @IBAction func onEnterCode(_ sender: Any) {
        let codeInput = codeField.text!
        
        // Finds PFObject "room" with "code" = codeInput
        // If exists, then enter waiting room
        let query = PFQuery(className: "Room")
        query.whereKey("code", equalTo: codeInput)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                //updates code variable
                self.code = codeInput
                //creates room object based on object found by query
                if let room = try? query.getFirstObject() {
                    // updates currentUsers and total users
                    //CURRENT USERS DOES NOT WORK!
                    self.currentUsers = room["currentUsers"] as! Int + 1
                    room.setValue(self.currentUsers, forKey: "currentUsers")
                    self.totalUsers = room["maxUsers"] as! String
                }
                // The find succeeded.
                print("Successfully retrieved \(objects.count) code.")
                // Do something with the found objects
                if (objects.count == 0) {
                    print("No room with specified code.")
                    //reveal invalid code warning
                    self.invalidCodeLabel.isHidden = false
                    
                }
                else {
                    self.invalidCodeLabel.isHidden = true
                    self.performSegue(withIdentifier: "enterWaitingRoomSegue", sender: nil)
                }
            }
        }
    
    }
    
    @IBAction func onGenerateCode(_ sender: Any) {
        let room = PFObject(className: "Room")
        
        // code is based on the first 8 characters of a UUID (universally unique identifier)
        // ex: 3D6F8556-EEB4-4200-B47E-49BCC17FC819
        let uuid = UUID().uuidString
        room["code"] = String(uuid.split(separator: "-")[0])
        room["maxUsers"] = maxUsersField.text!
        room["currentUsers"] = 1
        // Saves PFObject "room" with unique "code" key
        room.saveInBackground { (success, error) in
            if (success && self.maxUsersField.text != "" && self.maxUsersField.text != "0") {
                self.invalidNumberLabel.isHidden = true
                print("room object is saved. code is \(String(describing: room["code"]))")
    
                //updates code and total users
                self.code = room["code"] as! String
                self.totalUsers = self.maxUsersField.text!
                self.currentUsers = room["currentUsers"] as! Int
                self.performSegue(withIdentifier: "enterWaitingRoomSegue", sender: nil)
            } else {
                self.invalidNumberLabel.isHidden = false
                print("Error: \(error?.localizedDescription)")
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! WaitingRoomViewController
        destination.currentUsers = currentUsers
        destination.code = code
        destination.maxUsers = totalUsers
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
