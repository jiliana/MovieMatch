//
//  MovieSwipeViewController.swift
//  movie match
//
//  Created by Ana Carolina Cunha on 5/13/21.
//

import UIKit

class MovieSwipeViewController: UIViewController {

    @IBOutlet weak var codeLabel: UILabel!
    var code: String = ""
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var rankingsButton: UIButton!
    
    // array of dictionaries
    var movies = [[String:Any]]()
    
    var movieTitleArr = [String]()
    var movieImageArr = [String]()
    var movieSynopsisArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.text = "Code: \(code)"
        rankingsButton.layer.cornerRadius = 5
        
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
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
