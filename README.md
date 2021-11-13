# Spotify Radar

Spotify Radar is an iOS application that allows users to pull in new song releases from their favorite artists and provides users with important metrics like their top tracks, top artists, and recently played tracks, queryable by time range.

**Architecture**: MVVM + Coordinator + RxSwift

## Getting Started

### Prerequisites

```
Pods have already been committed so no need to run 'pod install'
```

### Installing

Create a [spotify application](https://developer.spotify.com/dashboard/applications) and save your clientId and clientSecret to `SpotifyDaily_iOS/Services/Configuration.swift`. Of course, when you make a PR, don't include `Configuration.swift` in it.

```
Open xcworkspace and run
```

## Built With

* [Cocoapods](https://github.com/CocoaPods/CocoaPods) - Dependency Management
* [Swinject](https://github.com/Swinject/Swinject) - Dependency Injection
* [SideMenu](https://github.com/jonkykong/SideMenu) - Menu navigation
* [RxSwift](https://github.com/ReactiveX/RxSwift) - Swift version of [Rx](https://github.com/Reactive-Extensions/Rx.NET)

## Contributing
- If you find a bug, or would like to suggest a new feature or enhancement, it'd be nice if you could [search the issue tracker first](https://github.com/ThasianX/SpotifyDaily/issues); while we don't mind duplicates, keeping issues unique helps us save time and consolidates effort. If you can't find your issue, feel free to [file a new one](https://github.com/ThasianX/SpotifyDaily/issues/new/choose).
- Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute–it has information on the process for handling contributions, and tips on how the code is structured to make your work easier, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Screenshots

<img src="./App Images/setup.png" height="500"> <img src="./App Images/sidemenu.png" height="500"> <img src="./App Images/noartists.png" height="500"> <img src="./App Images/addartists.png" height="500"> <img src="./App Images/portfolio.png" height="500"> <img src="./App Images/newreleases.png" height="500"> <img src="./App Images/dashboard.png" height="500">  <img src="./App Images/topartists.png" height="500"> <img src="./App Images/safari.png" height="500"> <img src="./App Images/toptracks.png" height="500"> <img src="./App Images/recentlyplayed.png" height="500"> <img src="./App Images/settings.png" height="500"> 

