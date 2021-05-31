Original App Design Project
===

# Movie Matcher

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)
3. [Progress GIFs](#GIFs)

## Overview
### Description
Choosing which movie to watch with friends can be difficult. With a few swipes, Movie Matcher can help any group of movie-watchers find their perfect movie match! Users in the same group vote yes or no to a list of movies, and the app will return the first movie everyone votes yes to. The app will also show a ranked list of all movies and vote counts.

### App Evaluation
- **Category:** Social and Media
- **Mobile:** This app is developed for mobile phones.
- **Story:** A group of friends would individually choose their favorite movies from the provided list of movies. The app would then suggest a movie for the whole group to watch that would fit into everyone's individual desires.
- **Market:** Any individual could use this app, based within their friend groups.
- **Habit:** Could be used as often as the user wants based on their social life.
- **Scope:** First, we connect a small group of users who want to decide on a movie to watch.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
- [x] List of movies
- [x] User can swipe movies right or left based on their preference
- [x] Generate code and code login (kahoot style)
- [x] Swiping has animations
- [x] Rankings of the group's favorite movies

**Optional Nice-to-have Stories**
- [x] App Icon and Launch Page
- [ ] Specified move is based on streaming services
- [ ] Saving user information/preference

### 2. Screen Archetypes

* Code Screen - User can generate code or input a code
* Movie swipe screen - A list of movies will appear one by one on the user's screen and they will swipe either right or left (yes or no) for that movie
* Result screen - Shows which movie was picked the most
* (Optional) Settings screen - Group can pick available streaming services
* (Optional) Profile Screen - Shows movies the user has previously liked and unliked

### 3. Navigation

**Tab Navigation** (Tab to Screen)

Optional:
* Settings
* Profile

**Flow Navigation** (Screen to Screen)
* Code Generator
    * Code appears
* Enter Code
    * Movie Swipe Screen
* Movie Swipe Screen
    * Result Screen when movie is picked between everyone
* (When done) Result Screen
    * Code Generator

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/zytqt41.png" width=600>

### [BONUS] Digital Wireframes & Mockups
<img src="https://i.imgur.com/vKA9O3M.png" width= 100> <img src="https://i.imgur.com/ulqaE3u.png" width= 100> <img src="https://i.imgur.com/3JuhQVR.png" width= 100> <img src="https://i.imgur.com/FLiGtMK.png" width= 100> <img src="https://i.imgur.com/xk7rzRQ.png" width= 100>

### [BONUS] Interactive Prototype
![](https://i.imgur.com/lrgebJ9.gif)

## Schema 
[This section will be completed in Unit 9]
### Models
#### Movie Ranking

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the group's movie |
   | code          | Pointer to Code | unique code for the group | 
   | movieTitle    | String   | name of movie |
   | movieImage    | File     | image of movie |
   | noVotes       | Number   | number of 'no' votes to a movie |
   | yesVotes      | Number   | number of 'yes' votes to a movie |

   
### Networking
#### List of network requests by screen
  - Code Screen
      - (Create) Create a new code
      - (Read) Use an existing code

```
let room = PFObject(className: "Room")

// code is based on the first 8 characters of a UUID (universally unique identifier)
let uuid = UUID().uuidString
room["code"] = String(uuid.split(separator: "-")[0])
room["maxUsers"] = maxUsersField.text!
room["currentUsers"] = 1

// Saves PFObject "room" with unique "code" key
// if input number is positive, else show error
if (Int(self.maxUsersField.text!) ?? -1 > 0) {
    room.saveInBackground { (success, error) in
        if (success) {
            // Hidden: Error message
            // Updates code and total users
            self.code = room["code"] as! String
            self.totalUsers = self.maxUsersField.text!
            self.currentUsers = room["currentUsers"] as! Int
            self.performSegue(withIdentifier: "enterWaitingRoomSegue", sender: nil)
        } else {
            print("Error: \(error?.localizedDescription ?? "cannot save room object")")
        }
    }
}
else {
    self.invalidNumberLabel.isHidden = false
}
```

```
let query = PFQuery(className: "Room")
query.whereKey("code", equalTo: codeInput)
query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
    if let error = error {
        // Log details of the failure
        print(error.localizedDescription)
    } else if let objects = objects {
        // Gets room with same code
        if let room = try? query.getFirstObject() {
            // updates currentUsers and total users
            self.currentUsers = room["currentUsers"] as! Int
            room.setValue(self.currentUsers, forKey: "currentUsers")
            self.totalUsers = room["maxUsers"] as! String
            let maxUsersInt = Int(self.totalUsers)
            print(self.currentUsers)
            print(maxUsersInt!)
            
            // increments currentUsers if room is not full
            if (self.currentUsers < maxUsersInt!) {
                print("increment")
                room.incrementKey("currentUsers")
                self.currentUsers = room["currentUsers"] as! Int
            }
            // else, sets error
            else {
                self.totalUsers = "fullRoom"
            }
            room.saveInBackground { (success, error) in
                if (success) {
                    print("currentUsers has been saved")
                }
                else {
                    print("Error: \(error?.localizedDescription ?? "currentUsers cannot be saved")")
                }
            }
        }
        // The find succeeded
        // Hidden: Increments number of users in room
        // Hidden: Enter waiting room
    }
}
```
  - Waiting Room Screen
      - (READ/Get) Number of users in room
```
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
  ```
  - Movie Choosing Screen
    - (Create) An object for each movie 
    - (Create) Create a 'yes/no' vote for each movie
```
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
```
  - Ranking Screen
      - (Read/GET) Query all movie ranking results of group

    ```
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
    ```
   
**[OPTIONAL: Existing API Endpoints]**

**Now Playing API from The Movie Database**
- Base URL - https://developers.themoviedb.org/3/movies/get-now-playing

| HTTP Verb    | Endpoint      | Description |
   | ------------- | -------- | ------------|
   | GET      | /movie/now_playing  | Get a list of movies in theatre |
   
## GIFs
### Sprint 1
**Milestones: App Layout & Group Code Set Up**

Code Generation + Navigation

<img src="https://i.imgur.com/Xh4Ak6w.gif" width= 300>

Page Layout

<img src="https://i.imgur.com/rP1UsEK.png" width=600>

### Sprint 2
**Milestones: Swiping**

Movie List + Swiping Feature

![](http://g.recordit.co/X5lTrz1w64.gif)

<img src="https://i.imgur.com/rilmi6y.gif" width= 300>

### Sprint 3
**Milestones: Rankings & Congratulations Page**

With 2 users:

<img src="https://i.imgur.com/PbeKRk5.gif" width= 300> <img src="https://i.imgur.com/yR6G43j.gif" width= 300>
