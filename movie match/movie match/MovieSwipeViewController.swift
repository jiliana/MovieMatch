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
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    var currTitle: String = ""
    var currImage: String = ""
    var currSynopsis: String = ""
    var currIndex: Int = 0
    
    // array of dictionaries
    var movies = [[String:Any]]()
    
    var movieTitleArr = [String]()
    var movieImageArr = [String]()
    var movieSynopsisArr = [String]()
    
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
                
                /*
                self.initializeMovieTitle()
                self.initializeMovieImage()
                self.initializeMovieSynopsis()
                */
                
                //print(dataDictionary)
                
                // set first sliding entry
                self.currTitle = self.movies[0]["title"] as! String
                self.currSynopsis = self.movies[0]["overview"] as! String
                self.currImage = self.movies[0]["poster_path"] as! String
                self.setCardView(title: self.currTitle, image: self.currImage, synopsis: self.currSynopsis)

             }
        }
        task.resume()
        
        
    }
    
    // initialize movie title
    func initializeMovieTitle() {
        var movie = movies[0]
        for item in movies {
            movie = item
            movieTitleArr.append(movie["title"] as! String)
        }
    }
    // initialize movie image
    func initializeMovieImage() {
        var movie = movies[0]
        for item in movies {
            movie = item
            movieImageArr.append(movie["poster_path"] as! String)
        }
    }
    // initialize movie synopsis
    func initializeMovieSynopsis() {
        var movie = movies[0]
        for item in movies {
            movie = item
            movieSynopsisArr.append(movie["overview"] as! String)
        }
        
    }
    
    @objc func swipeGesture(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .right {
            print("swipe right")
            
            let movie = PFObject(className: "Movies")
            movie["title"] = currTitle
            movie["synopsis"] = currImage
            movie["imageUrl"] = currImage
            
            movie.saveInBackground { (success, error) in
                if success {
                    print("saved!")
                    
                } else {
                    print("error!")
                }
            }

        } else if gesture.direction == .left {
            print("swipe left")
            
            let movie = PFObject(className: "Movies")
            movie["title"] = currTitle
            movie["synopsis"] = currImage
            movie["imageUrl"] = currImage
            
            movie.saveInBackground { (success, error) in
                if success {
                    print("saved!")
                    
                } else {
                    print("error!")
                }
            }
        }
        
        self.currIndex+=1;
        
        if currIndex < movies.count {
            self.currTitle = self.movies[self.currIndex]["title"] as! String
            self.currImage = self.movies[self.currIndex]["poster_path"] as! String
            self.currSynopsis = self.movies[self.currIndex]["overview"] as! String
        }
        self.setCardView(title: self.currTitle, image: self.currImage, synopsis: self.currSynopsis)
    }
    
    func setCardView(title: String, image: String, synopsis: String) {
        movieTitleLabel.text = title
        synopsisLabel.text = synopsis
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        let posterPath = image
        let posterUrl = URL(string: baseUrl + posterPath)
        
        movieImage.af_setImage(withURL: posterUrl!)

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
