//
//  WaitingRoomViewController.swift
//  movie match
//
//  Created by Ana Carolina Cunha on 5/13/21.
//

import UIKit
import Parse

class WaitingRoomViewController: UIViewController {

    @IBOutlet weak var codeisLabel: UILabel!
    @IBOutlet weak var peopleEnteredLabel: UILabel!
    @IBOutlet weak var swippingButton: UIButton!
    
    var maxUsers: String = ""
    var code: String = ""
    var currentUsers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        codeisLabel.text = "Code is \(code)"
        peopleEnteredLabel.text = "\(currentUsers) out of \(maxUsers) entered"
        swippingButton.layer.cornerRadius = 5
    }
    
    
    @IBAction func onBackButton(_ sender: Any) {
        self.performSegue(withIdentifier: "codeHomeSegue", sender: nil)
    }
    
    @IBAction func onSwipeButton(_ sender: Any) {
        if (String(currentUsers) == maxUsers) {
            self.performSegue(withIdentifier: "movieSegue", sender: nil)
        }
        else {
            print ("not all users in room")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "movieSegue" else {return}
        let destination = segue.destination as! MovieSwipeViewController
        destination.code = code
        destination.numUsers = currentUsers
    }
    
    func reload(){
        peopleEnteredLabel.text = "\(currentUsers) out of \(maxUsers) entered"
    }
    
    
    @IBAction func onRefreshButoon(_ sender: Any) {
        let query = PFQuery(className: "Room")
        query.whereKey("code", equalTo: code)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                //creates room object based on object found by query
                if let room = try? query.getFirstObject() {
                    // updates currentUsers and total users
                    let currUsers = room["currentUsers"] as! Int
                    self.currentUsers = currUsers
                   // self.peopleEnteredLabel.text = "\(self.currentUsers) out of \(self.maxUsers) entered"
                    self.reload();
                }
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
