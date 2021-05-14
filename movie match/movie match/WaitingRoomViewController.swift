//
//  WaitingRoomViewController.swift
//  movie match
//
//  Created by Ana Carolina Cunha on 5/13/21.
//

import UIKit

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
        let destination = MovieSwipeViewController(nibName: "MovieSwipeViewController", bundle: nil)
        destination.code = code
        self.performSegue(withIdentifier: "movieSegue", sender: nil)
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
