//
//  MovieSwipeViewController.swift
//  movie match
//
//  Created by Ana Carolina Cunha on 5/13/21.
//

import UIKit
import AlamofireImage
import Parse

class MovieSwipeViewController: UIViewController {

    @IBOutlet weak var codeLabel: UILabel!
    var code: String = ""
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var rankingsButton: UIButton!
    
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var synopsisLabel: UITextView!
    
    
    var currTitle: String = ""
    var currImage: String = ""
    var currSynopsis: String = ""
    var currIndex: Int = 0
    
    // array of dictionaries
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.text = "Code: \(code)"
        rankingsButton.layer.cornerRadius = 5
        
        cardView.isUserInteractionEnabled = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(gesture:)))
        swipeRight.direction = .right
        cardView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(gesture:)))
        swipeRight.direction = .left
        cardView.addGestureRecognizer(swipeLeft)
        
        // network request
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                // set first sliding entry
                self.currTitle = self.movies[self.currIndex]["title"] as! String
                self.currSynopsis = self.movies[self.currIndex]["overview"] as! String
                self.currImage = self.movies[self.currIndex]["poster_path"] as! String
                self.setCardView(title: self.currTitle, image: self.currImage, synopsis: self.currSynopsis)

             }
        }
        task.resume()
        
        
    }
    
    
    @objc func swipeGesture(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .right {
            print("swipe right")
            
            let movieQuery = PFQuery(className: "Movies").whereKey("title", equalTo: currTitle)

            var maybeMovie: PFObject?
            do {
                try maybeMovie = movieQuery.getFirstObject()
            } catch let error{
                print(error)
            }
            
            if (maybeMovie != nil){
                let movie = maybeMovie! as PFObject
                
                movie.incrementKey("yesVotes")
                
                movie.saveInBackground()
                
            } else {
                let movie = PFObject(className: "Movies")
                movie["title"] = currTitle
                movie["synopsis"] = currSynopsis
                movie["imageUrl"] = currImage
                movie["yesVotes"] = 1
                movie["noVotes"] = 0
                
                movie.saveInBackground { (success, error) in
                    if success {
                        print("saved!")
                        
                    } else {
                        print("error!")
                    }
                }
            }
            
        } else if gesture.direction == .left {
            print("swipe left")
    
            // finds movie object with "title" = title + code
            let movieQuery = PFQuery(className: "Movies")
            movieQuery.whereKey("title", equalTo: currTitle + code)
            
            movieQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let objects = objects {
                    // if movie object exists, noVotes += 1
                    if let movie = try? movieQuery.getFirstObject() {
                        movie.incrementKey("noVotes")
                        movie.saveInBackground { (success, error) in
                            if (success && movie["title"] as! String == self.currTitle + self.code) {
                                print("added no vote to movie")
                            }
                            else {
                                print("Error: \(error?.localizedDescription ?? "could not vote no")")
                            }
                        }
                    }
                    
                    // if movie object does not exist, make a new movie object
                    if (objects.count == 0) {
                        let movie = PFObject(className: "Movies")
                        movie["title"] = self.currTitle + self.code
                        movie["synopsis"] = self.currSynopsis
                        movie["imageUrl"] = self.currImage
                        movie["yesVotes"] = 0
                        movie["noVotes"] = 1
                        movie["room"] = self.code
                        
                        movie.saveInBackground { (success, error) in
                            if (success) {
                                print("movie object saved")
                            }
                            else {
                                print("Error: \(error?.localizedDescription ?? "could not save movie object")")
                            }
                        }
                    }       
                }
                
                self.currIndex+=1;
                
                if self.currIndex < self.movies.count {
                    self.currTitle = self.movies[self.currIndex]["title"] as! String
                    self.currImage = self.movies[self.currIndex]["poster_path"] as! String
                    self.currSynopsis = self.movies[self.currIndex]["overview"] as! String
                    self.setCardView(title: self.currTitle, image: self.currImage, synopsis: self.currSynopsis)
                } else {
                    // segue to rankings page with no back button
                    RankingsViewController.hiddenButton = true
                    self.performSegue(withIdentifier: "toRankingsSegue", sender: nil)
                }
            }
        }
    }
    
    func setCardView(title: String, image: String, synopsis: String) {
        movieTitleLabel.text = title
        synopsisLabel.text = synopsis
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        let posterPath = image
        let posterUrl = URL(string: baseUrl + posterPath)
        
        movieImage.af_setImage(withURL: posterUrl!)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let RankingsViewController = segue.destination as! RankingsViewController
        RankingsViewController.currIndex = self.currIndex
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
