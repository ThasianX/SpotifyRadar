# Contributing

First off, thank you for considering contributing to SpotifyDaily!

SpotifyDaily is an open source project and we love to receive contributions from our community — you! There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting bug reports and feature requests or writing code which can be incorporated into Spotify Daily itself.

First of all, if you plan on doing any work, *please check the issue tracker*. Not only does this make it easier to track progress, it also prevents people doing duplicate work, as well as allows for the community to weigh in on the implementation of a feature *before* it's already all coded up. 

## Contribution workflow

SpotifyDaily follows the standard fork/commit/pull request process for integrating changes. If you have something that you're interested in working on (*after checking the issue tracker*):

1. Fork and clone the repository
2. Open `SpotifyDaily.xcworkspace` in Xcode. Make sure you are using XCode 11; SpotifyDaily may build with another version but this is not guaranteed.
3. Commit your changes, test them, push to your repository, and submit a pull request against ThasianX/SpotifyDaily's `develop` branch.

Some tips for your pull request:

* If you found `develop` has been updated before your change was merged, you can rebase in the new changes before opening a pull request:

```console
$ git rebase upstream/develop
```
* Please submit separate pull requests for different features; i.e. try not to shove multiple, unrelated changes into one pull request.
* Please make sure the pull request only contains changes that you've made intentionally; if you didn't mean to touch a file, you should probably not include it in your commit. Here are some files that may have changes in them:
  - `project.pbxproj`: This file may change if you sign the project with a different developer account. Changes due to adding or removing files are OK, generally.
  
### Don't know where to start?
Unsure where to begin contributing to SpotifyDaily? You can start by looking through the [beginner](https://github.com/ThasianX/SpotifyDaily/labels/good%20first%20issue) and [help-wanted](https://github.com/ThasianX/SpotifyDaily/labels/help%20wanted) issues.

### Technical tips

* Programmatic views are preferrable but you may use XIBs for UI.
* Add comments when necessary.
* There's no fixed guidelines for code style, unfortunately, so please use your best judgement in making the code look consistent.
* If you want to implement a new feature, it may be helpful to look at [Spotify's Web API](https://developer.spotify.com/documentation/web-api/reference/) or [Spotify's iOS API](https://spotify.github.io/ios-sdk/html/)

### Current structure

* Every screen in the app should have a `Coordinator`, `Viewmodel`, and `ViewController`, pertaining to the MVVM and Coordinator architecture present in the app.
* `SessionService` encapsulates the state of the app and is where networking responses should be parsed into their respective models, wrapped in an `Observable`.
* Window related logic should be in any `Coordinator`.
  - Call `start(coordinator: _)` to transition to another screen
  - `Coordinator` subclasses should inject the viewmodel into their respective viewcontrollers.
  - Use `UIViewController.presentOnTop(_ viewController:, animated:)` to present a viewcontroller modally
  - Use `ViewControllerUtils.setRootViewController(window:, viewController:, withAnimation:)`  to present a viewcontroller in the navigation controller

If you believe the code can be improved, please raise an issue.

