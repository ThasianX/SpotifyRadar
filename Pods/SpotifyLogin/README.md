![SpotifyLogin - Swift 4 Framework for authenticating with the Spotify API ](https://user-images.githubusercontent.com/889949/28974990-b2eb0328-7938-11e7-9d19-1ff86d77324b.png)

[![Build Status](https://travis-ci.org/spotify/SpotifyLogin.svg?branch=master)](https://travis-ci.org/spotify/SpotifyLogin)
[![Version](http://img.shields.io/cocoapods/v/SpotifyLogin.svg)](http://cocoapods.org/?q=SpotifyLogin)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# SpotifyLogin
SpotifyLogin is a Swift 4 Framework for authenticating with the Spotify API.

Usage of this framework is bound under the [Developer Terms of Use](https://developer.spotify.com/developer-terms-of-use/).

## Usage

### Disclaimer
SpotifyLogin is appropriate for prototyping and non-commercial use only.

**If your app is meant for commercial production usage, SpotifyLogin can NOT be used.**

### Compatibility
SpotifyLogin requires Xcode 9.0+. It is compatible with iOS 9 or later. 

### Pre-requisites
You will need to register your app in the [Developer Portal](https://developer.spotify.com/my-applications/#!/applications).

Make sure to use a unique redirect url and to supply the bundle ID from your app.

After registering, you will receive a client ID and a client secret. 

### Set up SpotifyLogin

Set up SpotifyLogin using any of the methods detailed below (Cocoapods / Carthage / manually).

### Set up info.plist

In Xcode, go to your app's target and select the **Info** tab. At the bottom, of the screen you will find **URL Types**, expand the list and create a new one.

![Set up info.plist](https://user-images.githubusercontent.com/889949/28974992-b30ea08a-7938-11e7-9de5-b00656a42256.png)

Add the app's identifer as the **Identifier** and the redirect url scheme in **URL schemes**.

Additionally, you will need to add "spotify-action" to the LSApplicationQueriesSchemes key:
![LSApplicationQueriesSchemes](https://user-images.githubusercontent.com/889949/29968001-f020c4d4-8f19-11e7-8925-433d3b30f842.png)

### Set up your AppDelegate

Add the following to your app delegate:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    SpotifyLogin.shared.configure(clientID: <#T##String#>, clientSecret: <#T##String#>, redirectURL: <#T##URL#>)
    return true
}

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    let handled = SpotifyLogin.shared.applicationOpenURL(url) { (error) in }
    return handled
}
```

### Check if a user is logged in.

You can retrieve an access token and check if a user is logged in by:

```swift
SpotifyLogin.shared.getAccessToken { (accessToken, error) in
    if error != nil {
        // User is not logged in, show log in flow.
    }
}
```

This also automatically takes care of renewing expired tokens. 

### Log in / Log out

To add the default log in button:
```swift
let button = SpotifyLoginButton(viewController: self, scopes: [.streaming, .userLibraryRead])
self.view.addSubview(button)
```

The scopes define the set of permissions your app will be able to use. For more information about available scopes, see [Scopes Documentation](https://developer.spotify.com/web-api/using-scopes/)

To log out:

```swift
SpotifyLogin.shared.logout()
```

### Update UI after successful log in.

The log in flow is completed in applicationOpenURL. To respond to a successful log in, you can add your own code in the completion handler or respond to the SpotifyLoginSuccessful notification: 

```swift
NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessful), name: .SpotifyLoginSuccessful, object: nil)
```

### Additional features

Access the current user's username:
```swift
let username = SpotifyLogin.shared.username
```

To trigger the log in flow from a custom action:
```swift
SpotifyLoginPresenter.login(from: self, scopes: [.streaming, .userLibraryRead])
```

## Setting up

### Setting up with [CocoaPods](http://cocoapods.org/?q=SpotifyLogin)
```ruby
source 'https://github.com/CocoaPods/Specs.git'
pod 'SpotifyLogin', '~> 0.1'
```

### Setting up with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SpotifyLogin into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "spotify/SpotifyLogin"
```

## Code of conduct
This project adheres to the [Open Code of Conduct][code-of-conduct]. By contributing, you are expected to honor this code.

[code-of-conduct]: https://github.com/spotify/code-of-conduct/blob/master/code-of-conduct.md

## Additional information

[Spotify Developer Portal](https://developer.spotify.com/technologies/spotify-ios-sdk/) | [API Reference](https://spotify.github.io/ios-sdk/)
