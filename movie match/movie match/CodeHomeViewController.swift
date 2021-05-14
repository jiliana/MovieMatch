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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
                // The find succeeded.
                print("Successfully retrieved \(objects.count) code.")
                // Do something with the found objects
                if (objects.count == 0) {
                    print("No room with specified code.")
                }
                else {
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
        
        // Saves PFObject "room" with unique "code" key
        room.saveInBackground { (success, error) in
            if (success) {
                print("room object is saved. code is \(String(describing: room["code"]))")
                self.performSegue(withIdentifier: "enterWaitingRoomSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
        

        
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
