Original App Design Project - README Template
===

# Movie Matcher

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

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
* List of movies
* User can swipe movies right or left based on their preference
* Generate code and code login (kahoot style)

**Optional Nice-to-have Stories**
* Specified moveis based on streaming services
* Saving user information/preference

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
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype
![](https://i.imgur.com/lrgebJ9.gif)

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
