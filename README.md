Original App Design Project - README Template
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
Helps find a movie to watch in a group setting. Everyone within the same group will say yes or no to a list of movies and the app will return the first movie everyone said yes to.

### App Evaluation
- **Category:** Social and Media
- **Mobile:** This app would be primarily developed for mobile.
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
- [ ] Rankings of the group's favorite movies

**Optional Nice-to-have Stories**
- [ ] Specified moveis based on streaming services
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
      - (Create/Read) Create a new code or use an existing code
  - Movie Choosing Screen
      - (Create) Create a 'yes/no' vote for each movie
  - Ranking Screen
      - (Read/GET) Query all movie ranking results of group

    ```
    let query = PFQuery(className:"MovieRanking")
    query.whereKey("code", equalTo: currentUser)
    query.order(byDescending: "yesVotes")
    query.findObjectsInBackground { (movieRankings: [PFObject]?, error: Error?) in
       if let error = error { 
          print(error.localizedDescription)
       } else if let movieRankings = movieRankings {
          print("Successfully retrieved \(movieRankings.count) movieRankings.")
      // TODO: Do something with movie rankings...
       }
    }
    ```
   
**[OPTIONAL: Existing API Endpoints]**

**Now Playing API from The Movie Database**
- Base URL - https://developers.themoviedb.org/3/movies/get-now-playing

| HTTP Verb	| Endpoint      | Description |
   | ------------- | -------- | ------------|
   | GET      | /movie/now_playing  | Get a list of movies in theatre |
   
## GIFs
### Sprint 1
**Milestones: App Layout & Group Code Set Up**

Code Generation + Navigation
![](https://i.imgur.com/Xh4Ak6w.gif)

Page Layout
<img src="https://i.imgur.com/rP1UsEK.png" width=600>
