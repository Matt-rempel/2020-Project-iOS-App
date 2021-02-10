# 2020-Project-iOS-App
The official iOS App of The 2020 Project. This App is available on the iOS App Store [here](https://apps.apple.com/ca/app/2020-project/id1488946496). 

## Overview 
Written in Swift, this App queries a REST API to display daily devotions. 

## Dependencies 
- [Alamofire](https://github.com/Alamofire/Alamofire)
  - Used to perform HTTP requests.
- [Firebase](https://firebase.google.com)
  - Used for Firebase Analytics.
- [SwiftJSON](https://github.com/SwiftyJSON/SwiftyJSON)
  - Used to translate JSON from the REST API to Swift Objects
- [BulletinBoard](https://github.com/alexisakers/BulletinBoard)
  - Used to display notifications or prompts to the user
- [URLImage](https://github.com/dmytro-anokhin/url-image)
  - Used for the iOS 14 Widget to display images from Unsplash

## Project Structure 
This project uses an MCV architecture. The folder structre of the App is as follows:
- Models
  - Models such as Devotion, Author, User, etc.
- Views
  - Both the Main.storyboard and the LaunchScreen.storyboard
- Controllers 
  - All of the App's ViewControllers
- Data Access
  - Responsible for making REST API calls and returning the fetched data as Swift objects
- Utilities 
  - Miscellaneous files used to help facilitate the other functionality of the App. Such as custom App Icon data or Date formatting. 
- UI Utilities
  - Miscellaneous files used to help facilitate some UI elements of the App. Such as custom buttons or UIColors.
