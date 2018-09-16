# ios-inline-youtube-view 

[![Version](https://img.shields.io/cocoapods/v/InlineYoutubeView.svg?style=flat)](http://cocoapods.org/pods/InlineYoutubeView)
[![Build Status](https://travis-ci.org/flipkart-incubator/ios-inline-youtube-view.svg?branch=master)](https://travis-ci.org/flipkart-incubator/ios-inline-youtube-view) 
[![License](https://img.shields.io/cocoapods/l/InlineYoutubeView.svg?style=flat)](http://cocoapods.org/pods/InlineYoutubeView)
[![Platform](https://img.shields.io/cocoapods/p/InlineYoutubeView.svg?style=flat)](http://cocoapods.org/pods/InlineYoutubeView)

YouTube component for Android, iOS and React. This is a suite of utility libraries around using YouTube inside your [Android](https://github.com/flipkart-incubator/inline-youtube-view/), [iOS](https://github.com/flipkart-incubator/ios-inline-youtube-view/) or React Native app.

## youtube-ios

This pod is a modification of the youtube-ios-helper provided by youtube. Modifications include
* Migration to WkWebView from the older UIWebView. WKWebView is run in a separate process to your app so that it can draw on native Safari JavaScript optimizations. This means WKWebView loads web pages faster and more efficiently than UIWebView, and also doesn't have as much memory overhead for you. Quoting the Apple documentation - "Starting in iOS 8.0 and OS X 10.10, use WKWebView to add web content to your app. Do not use UIWebView or WebView."
* Adding support for custom html urls. Earlier we could only use the html in the resource bundle
* Adding parameter for deciding whether to play the videos inline or fullscreen.
* Adding error callback for when network is offline after iframeAPI has been loaded.

## Demo App

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Demo Gifs

![YouTube iOS](https://github.com/flipkart-incubator/ios-inline-youtube-view/blob/master/Screenshots/InlineYoutube.gif)

## Installation

inlineYouTubeView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InlineYoutubeView'
```

## Usage

**Import the header file**

ObjectiveC
```objective-c
#import <InlineYoutubeView/InlineYoutubeView.h>
```

Swift
```swift
import InlineYoutubeView
```
<br />

**Create an object of the InlineYoutubeView.**

ObjectiveC
```objective-c
@property (nonatomic, strong) InlineYoutubeView *youtubeView;
```

Swift
```swift
var youtubeView: InlineYoutubeView
```
<br />

**Initialise the Inline youtube view.**

ObjectiveC
```objective-c
//The url where the HTML is hosted. You can have any custom HTML url as well. So you can modify the iframe provided, upload the modified HTML file and use the url here
NSString *const HTML_URL = @"https://cdn.rawgit.com/flipkart-incubator/inline-youtube-view/60bae1a1/youtube-android/youtube_iframe_player.html";

//Incase you need your youtube view to open inline
self.youtubeView = [[InlineYoutubeView alloc] initWithHtmlUrl:HTML_URL andVideoPlayerMode:kYTPlayerModeInline];

//Incase you need your youtube view to open in fullscreen
self.youtubeView = [[InlineYoutubeView alloc] initWithHtmlUrl:HTML_URL andVideoPlayerMode:kYTPlayerModeFullScreen];
```

Swift
```swift
//The url where the HTML is hosted. You can have any custom HTML url as well. So you can modify the iframe provided, upload the modified HTML file and use the url here
let HTML_URL = "https://cdn.rawgit.com/flipkart-incubator/inline-youtube-view/60bae1a1/youtube-android/youtube_iframe_player.html"

//Incase you need your youtube view to open inline
youtubeView = InlineYoutubeView(htmlUrl: HTML_URL, andVideoPlayerMode: .inline)

//Incase you need your youtube view to open in fullscreen
youtubeView = InlineYoutubeView(htmlUrl: HTML_URL, andVideoPlayerMode: .fullScreen)
```
<br />

**Set the delegate of the youtube view to self. This will ensure that you start receiving all the InlineYoutubeView callbacks.**

ObjectiveC
```objective-c
self.youtubeView.delegate = self;
```

Swift
```swift
 youtubeView.delegate = self
```

<br />

**Load the iframe. If it is not loaded right now, the InlineYoutubeView will give a playerViewDidBecomeReady callback when it loads up. If it is loaded we will simply call the method right now to start up the video.**

ObjectiveC
```objective-c
//Wait for youtube player to to get ready or proceed if it is ready.
if([self.youtubeView loadYTIframe]) {
[self playerViewDidBecomeReady:self.youtubeView];
}
```

Swift
```swift
//Wait for youtube player to to get ready or proceed if it is ready.
if (ytPlayerView.loadYTIframe()) {
  playerViewDidBecomeReady(ytPlayerView)
}
 ```
 
 <br />

**Implement the playerViewDidBecomeReady method of the InlineYoutubeViewDelegate. This method should be called when your player becomes ready.**

ObjectiveC
```objective-c
- (void)playerViewDidBecomeReady:(nonnull InlineYoutubeView *)playerView {
//Load the youtube video with the videoId of the video
[playerView loadVideoById:_videoId startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
[playerView playVideo];
}
```

Swift
```swift
//Wait for youtube player to to get ready or proceed if it is ready.
func playerViewDidBecomeReady(_ playerView: InlineYoutubeView) {
    //Load the youtube video with the videoId of the video
    playerView.loadVideo(byId: videoId, startSeconds: 0, suggestedQuality: YTPlaybackQuality.auto)
    playerView.playVideo()
}
 ```
 
<br /> 

**You can implement other methods of the InlineYoutubeViewDelegate depending on your requirements. Check out the InlineYoutubeView.h file for more documentation on the same.**

```objective-c
- (void)playerView:(nonnull InlineYoutubeView *)playerView didChangeToState:(YTPlayerState)state;

- (void)playerView:(nonnull InlineYoutubeView *)playerView didChangeToQuality:(YTPlaybackQuality)quality;

- (void)playerView:(nonnull InlineYoutubeView *)playerView receivedError:(YTPlayerError)error ;

- (void)playerView:(nonnull InlineYoutubeView *)playerView didPlayTime:(float)playTime ;

- (void)playerView:(nonnull InlineYoutubeView *)playerView duration:(NSTimeInterval)duration ;

- (nonnull UIColor *)playerViewPreferredWebViewBackgroundColor:(nonnull InlineYoutubeView *)playerView;

- (nullable UIView *)playerViewPreferredInitialLoadingView:(nonnull InlineYoutubeView *)playerView;

- (void)playerViewDidEnterFullScreen:(nonnull InlineYoutubeView *)playerView;

- (void)playerViewDidExitFullScreen:(nonnull InlineYoutubeView *)playerView;
```
<br />

## YouTube Android Player

We have open-sourced the inline-youtube-player for [Android](https://github.com/flipkart-incubator/inline-youtube-view) also.

## Contributing

The easiest way to contribute is by [forking the repo](https://help.github.com/articles/fork-a-repo/), making your changes and [creating a pull request](https://help.github.com/articles/creating-a-pull-request/).

## Author

shubhankaryash, shubhankar.yash@flipkart.com

## License

InlineYoutubeView is available under the Apache 2.0 license. The pod files are a modification of the work done by Google and has their license. However the Example project belongs to the Flipkart license.  See the LICENSE file for more info.
