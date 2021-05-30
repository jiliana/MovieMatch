//
//  RankingsViewController.swift
//  movie match
//
//  Created by Ana Carolina Cunha on 5/14/21.
//

import UIKit
import Parse
import AlamofireImage

class RankingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backMovieButton: UIButton!
    
    var currIndex: Int = 0
    var numUsers: Int = 0
    var code: String = ""
    static var hiddenButton = false
    var movieObjects = [PFObject]()
    var rankedMovies = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        if (RankingsViewController.hiddenButton == true){
            backMovieButton.isHidden = true
        }
        movieObjects.removeAll()
        findMovies()
    }
    
    func findMovies(){
        let query = PFQuery(className: "Movies")
        query.whereKey("room", equalTo: code)
        query.findObjectsInBackground { [self] (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                print("Successfuly retrieved: \(objects.count) movies")
                
                for movie in objects{
                    let yes = movie["yesVotes"] as! Int
                    let no = movie["noVotes"] as! Int
                    movie["score"] = (yes - no)
                    movie.saveInBackground()
                    self.movieObjects.append(movie)
                }
                
                if(objects.count < 3){
                    print("Not enough objects")
                }
            }
            
            movieObjects.sort(by: { movie1, movie2 in
                let int1 = movie1["score"] as! Int
                let int2 = movie2["score"] as! Int
                return int1 > int2
            })
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingsTableViewCell", for: indexPath) as! RankingsTableViewCell
        
        let movie = movieObjects[indexPath.item]
        let title = movie["title"] as! String
        let rank = indexPath.item + 1
        cell.titleLabel.text = "#\(rank) " + title
        cell.synopsisLabel.text = movie["synopsis"] as? String
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        let posterPath = movie["imageUrl"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        let yesVotes = movie["yesVotes"]
        cell.yesLabel.text = "\(yesVotes ?? 0)"
        let noVotes = movie["noVotes"]
        cell.noLabel.text = "\(noVotes ?? 0)"
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    /*
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return movies.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
         
         let movie = movies[indexPath.item]
         
         
         let baseURL = "https://image.tmdb.org/t/p/w185"
         let posterPath = movie["poster_path"] as! String
         let posterURL = URL(string: baseURL+posterPath)
         
         cell.posterView.af_setImage(withURL: posterURL!)
         
         return cell
         
     }
     */

    @IBAction func onBackButton(_ sender: Any) {
        self.performSegue(withIdentifier: "movieSwipeSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let MovieSwipeViewController = segue.destination as! MovieSwipeViewController
        MovieSwipeViewController.currIndex = self.currIndex
        MovieSwipeViewController.code = code
        MovieSwipeViewController.numUsers = numUsers
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
