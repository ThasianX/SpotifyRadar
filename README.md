# Spotify Daily **Archived - Screenshots below

Using the spotify API, this app pulls in recent songs from artists in the user's portfolio and gives the user an overview of their top artists, top tracks, and recently listened to tracks.

### Purposes

- Learn the Spotify API
- Learn how to create views programmatically
- Refine understanding of RxSwift
- Learn networking
- Useful for me since I listen to Spotify a lot and would like to tailor the recommendation system to recommend better songs for me

### Unfinished todos
- Bug: Artist images not displaying in stackview - look into scan operator
- Add a UIRefresh control to hide the initial population of cells, which would make the interface seem cleaner
- Save cell view model states to cache to prevent lag
- Fix tableview layout error("UITableView was told to layout its visible cells and other contents without being in the view hierarchy”)- doesn’t have any adverse effects so I’ll leave it for now
- Fix retain cycle with addartistsviewcontroller and addartistsviewmodel
- Add tickmarks to the UISlider and make it snap to nearest mark when user is selecting a value
- Implement: open links directly in the spotify app rather than safari
- For the login process, also directly authenticate with the spotify app
- Rare bug: AppDelegate crashes because the rootviewcontroller isn’t set by the time its didfinishlaunchingoptions method returns. I have a line in AppCoordinator that just needs to be uncommented in the case that this happens
- Add notifications when a new track is released by an artist in user’s portfolio
- Refresh dashboard after one of its subviews is dismissed

### Installing
- I've already committed the pods so all you have to do is open xcworkspace and run the app on an emulator of your choice, preferabbly iPhone X and above

### Screenshots

<img src="./App Images/setup.png" height="500"> <img src="./App Images/sidemenu.png" height="500"> <img src="./App Images/noartists.png" height="500"> <img src="./App Images/addartists.png" height="500"> <img src="./App Images/portfolio.png" height="500"> <img src="./App Images/newreleases.png" height="500"> <img src="./App Images/dashboard.png" height="500">  <img src="./App Images/topartists.png" height="500"> <img src="./App Images/safari.png" height="500"> <img src="./App Images/toptracks.png" height="500"> <img src="./App Images/recentlyplayed.png" height="500"> <img src="./App Images/settings.png" height="500"> 
