//
//  CongratulationsViewController.swift
//  movie match
//
//  Created by Ana Carolina Cunha on 5/14/21.
//

import UIKit
import AlamofireImage

class CongratulationsViewController: UIViewController {

    @IBOutlet weak var homeButton: UIButton!

    @IBOutlet weak var firstMovieTitleLabel: UILabel!
    @IBOutlet weak var firstMovieImage: UIImageView!
    @IBOutlet weak var firstSynopsisLabel: UITextView!
    
    var firstMovieTitle: String = ""
    var firstSynopsis: String = ""
    var firstImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeButton.layer.cornerRadius = 5
        firstMovieTitleLabel.text = firstMovieTitle
        firstSynopsisLabel.text = firstSynopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        let posterPath = firstImage
        let posterUrl = URL(string: baseUrl + posterPath)
        
        firstMovieImage.af_setImage(withURL: posterUrl!)
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
