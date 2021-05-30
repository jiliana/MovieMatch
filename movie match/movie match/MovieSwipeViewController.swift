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
    @IBOutlet weak var thumbImage: UIImageView!
    
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var synopsisLabel: UITextView!
    
    
    var currTitle: String = ""
    var currImage: String = ""
    var currSynopsis: String = ""
    var currIndex: Int = 0
    
    //var numYesVotes: Int = 0
    var numUsers: Int = 0
    
    // array of dictionaries
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //card view design
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 3, height: 3)
        cardView.layer.shadowRadius = 10
        
        //label customization
        codeLabel.text = "Code: \(code)"
        
        //button design
        rankingsButton.layer.cornerRadius = 5
        
        cardView.isUserInteractionEnabled = true
        
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
    
    @IBAction func swipeCardAnimation(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let scale = min(150/abs(xFromCenter),1)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/view.frame.width/1.5).scaledBy(x: scale, y: scale)
        
        if xFromCenter > 0 {
            thumbImage.image = UIImage(systemName: "hand.thumbsup.fill")
            thumbImage.tintColor = UIColor.green
        }
        else {
            thumbImage.image = UIImage(systemName: "hand.thumbsdown.fill")
            thumbImage.tintColor = UIColor.red
        }
        
        thumbImage.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            self.cardView.alpha = 0
            if (xFromCenter > 0) {
                swipedCard(dir: 1)
            }
            else {
                swipedCard(dir: -1)
            }
        }
        
        
    }

    func swipedCard(dir: Int) {
        
        if (dir > 0){
            print("swipe right")
            
            // finds movie object with "title" = title + code
            let movieQuery = PFQuery(className: "Movies")
            movieQuery.whereKey("titlecode", equalTo: currTitle + code)
            
            movieQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let objects = objects {
                    // if movie object exists, yesVotes += 1
                    if let movie = try? movieQuery.getFirstObject() {
                        movie.incrementKey("yesVotes")
                        
                        let yesVotesNum = movie["yesVotes"] as! Int
                        movie["yesVotesCode"] = String(yesVotesNum) + self.code
                        
                        movie.saveInBackground { (success, error) in
                            if (success) {
                                print("added yes vote to movie")
                            }
                            else {
                                print("Error: \(error?.localizedDescription ?? "could not vote yes")")
                            }
                        }
                        //self.numYesVotes = movie["yesVotes"] as! Int
                    }
                    
                    // if movie object does not exist, make a new movie object
                    if (objects.count == 0) {
                        let movie = PFObject(className: "Movies")
                        movie["title"] = self.currTitle
                        movie["titlecode"] = self.currTitle + self.code
                        movie["synopsis"] = self.currSynopsis
                        movie["imageUrl"] = self.currImage
                        movie["yesVotes"] = 1
                        movie["noVotes"] = 0
                        movie["room"] = self.code
                        movie["score"] = 1
                        
                        let yesVotesNum = movie["yesVotes"] as! Int
                        movie["yesVotesCode"] = String(yesVotesNum) + self.code
                        //self.numYesVotes = movie["yesVotes"] as! Int
                        
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
                
                self.afterSwipe()
                
            }
            
        } else {
            print("swipe left")
            
            // finds movie object with "title" = title + code
            let movieQuery = PFQuery(className: "Movies")
            movieQuery.whereKey("titlecode", equalTo: currTitle + code)
            
            movieQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let objects = objects {
                    // if movie object exists, noVotes += 1
                    if let movie = try? movieQuery.getFirstObject() {
                        movie.incrementKey("noVotes")
                        
                        let yesVotesNum = movie["yesVotes"] as! Int
                        movie["yesVotesCode"] = String(yesVotesNum) + self.code
                        
                        movie.saveInBackground { (success, error) in
                            if (success) {
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
                        movie["title"] = self.currTitle
                        movie["titlecode"] = self.currTitle + self.code
                        movie["synopsis"] = self.currSynopsis
                        movie["imageUrl"] = self.currImage
                        movie["yesVotes"] = 0
                        movie["noVotes"] = 1
                        movie["room"] = self.code
                        movie["score"] = -1
                        
                        let yesVotesNum = movie["yesVotes"] as! Int
                        movie["yesVotesCode"] = String(yesVotesNum) + self.code
                        
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
                self.afterSwipe()
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
        RankingsViewController.code = code
        RankingsViewController.numUsers = self.numUsers
    }
    
    func afterSwipe() {
        
        let movieQuery = PFQuery(className: "Movies")
        movieQuery.whereKey("yesVotesCode", equalTo: String(self.numUsers) + code)
        
        movieQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
                // if yes votes = number users
                if let movie = try? movieQuery.getFirstObject() {
                    print("equal yes and users")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "congratulationsViewController") as! CongratulationsViewController
                    vc.firstMovieTitle = movie["title"] as! String
                    vc.firstSynopsis = movie["synopsis"] as! String
                    vc.firstImage = movie["imageUrl"] as! String
                    self.present(vc, animated: true, completion: nil)
                }
                // yes votes not hit
                if (objects.count == 0) {
                    print("not enough yes")
                    print(self.numUsers)
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
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.cardView.center = self.view.center
                        self.thumbImage.alpha = 0
                        self.cardView.transform = CGAffineTransform.identity
                    })
                    self.cardView.alpha = 1
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
}
}
