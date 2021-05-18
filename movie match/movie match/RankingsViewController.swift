//
//  RankingsViewController.swift
//  movie match
//
//  Created by Ana Carolina Cunha on 5/14/21.
//

import UIKit

class RankingsViewController: UIViewController, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backMovieButton: UIButton!
    var currIndex: Int = 0
    static var hiddenButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        //tableView.dataSource = self

        if (RankingsViewController.hiddenButton == true){
            backMovieButton.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
 */
    

    @IBAction func onBackButton(_ sender: Any) {
        self.performSegue(withIdentifier: "movieSwipeSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let MovieSwipeViewController = segue.destination as! MovieSwipeViewController
        MovieSwipeViewController.currIndex = self.currIndex
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
