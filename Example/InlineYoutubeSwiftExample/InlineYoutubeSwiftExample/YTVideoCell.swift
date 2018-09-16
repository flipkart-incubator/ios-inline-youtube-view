//
//  YTVideoCell.swift
//  InlineYoutubeSwiftExample
//
//  Created by Keerthana Reddy Ragi on 16/09/18.
//  Copyright 2018 Flipkart Internet Pvt. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import InlineYoutubeView
//The url where the HTML is hosted
let HTML_URL = "https://cdn.rawgit.com/flipkart-incubator/inline-youtube-view/60bae1a1/youtube-android/youtube_iframe_player.html"
let PLAY_ICON = "playIcon"

//Dimension of the play icon used over the thumbnail
let PLAY_ICON_DIMENSION = 48

class YTVideoCell: UITableViewCell, InlineYoutubeViewDelegate {
    var youtubeView: InlineYoutubeView! = nil
    var thumbnailView: UIImageView! = nil
    var playIconView: UIImageView! = nil
    var loaderView: UIActivityIndicatorView! = nil
    var videoId: String = ""
    var playInline: Bool = false
    
    init(frame: CGRect, videoId: String?, playInline: Bool) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "")
        selectionStyle = UITableViewCellSelectionStyle.none
        
        //Assigning the video properties
        self.videoId = videoId!
        self.playInline = playInline
        
        setupThumbnail(withFrame: frame)
    }
    
    func setupThumbnail(withFrame frame: CGRect) {
        thumbnailView = UIImageView(frame: frame)
        thumbnailView.contentMode = .scaleToFill
        superImposePlayIconOnThumbnail()
        asynchronouslyDownloadThumbnailImage()
    }
    
    func superImposePlayIconOnThumbnail() {
        //Setup the playIconView and place it on top of the thumbnail image
        let playIconImage = UIImage(named: PLAY_ICON)
        playIconView = UIImageView(image: playIconImage)
        playIconView.frame = CGRect(x: Int(thumbnailView.bounds.size.width) / 2 - PLAY_ICON_DIMENSION / 2, y: Int(thumbnailView.bounds.size.height) / 2 - PLAY_ICON_DIMENSION / 2, width: PLAY_ICON_DIMENSION, height: PLAY_ICON_DIMENSION)
        thumbnailView.addSubview(playIconView)
        addSubview(thumbnailView)
    }
    
    func asynchronouslyDownloadThumbnailImage() {
        let urlString = "https://img.youtube.com/vi/\(videoId)/hqdefault.jpg"
        let thumbnailUrl = URL(string: urlString)
        DispatchQueue.global().async(execute: {
            var image: UIImage? = nil
            if let anUrl = thumbnailUrl {
                let aData = try! Data(contentsOf: anUrl)
                image = UIImage(data: aData)
            }
            DispatchQueue.main.sync{
                if image != nil {
                    self.thumbnailView.image = image
                }
            }
            
        })
    }
    
    func playButtonClicked() {
        playIconView.removeFromSuperview()
        
        addLoaderOverThumbnail()
        setupYoutubeView()
        
        //Wait for youtube player to to get ready or proceed if it is ready
        if youtubeView.loadYTIframe() {
            playerViewDidBecomeReady(youtubeView)
        }
    }
    
    func addLoaderOverThumbnail() {
        loaderView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loaderView.frame = CGRect(x: Int(thumbnailView.bounds.size.width) / 2 - PLAY_ICON_DIMENSION / 2, y: Int(thumbnailView.bounds.size.height) / 2 - PLAY_ICON_DIMENSION / 2, width: PLAY_ICON_DIMENSION, height: PLAY_ICON_DIMENSION)
        loaderView.startAnimating()
        thumbnailView.addSubview(loaderView)
    }
    
    func setupYoutubeView() {
        if playInline {
            youtubeView = InlineYoutubeView(htmlUrl: HTML_URL, andVideoPlayerMode: .inline)
        } else {
            youtubeView = InlineYoutubeView(htmlUrl: HTML_URL, andVideoPlayerMode: .fullScreen)
        }
        
        youtubeView.frame = thumbnailView.frame
        youtubeView.delegate = self
    }
    
    /*
     InlineYoutubeView callbacks
     */
    func playerViewDidBecomeReady(_ playerView: InlineYoutubeView) {
        removeLoaderFromThumbnail()
        loadVideo(playerView)
    }
    
    func removeLoaderFromThumbnail() {
        loaderView.stopAnimating()
        loaderView.removeFromSuperview()
    }
    
    func loadVideo(_ playerView: InlineYoutubeView) {
        addSubview(playerView)
        playerView.loadVideo(byId: videoId, startSeconds: 0, suggestedQuality: .auto)
        playerView.playVideo()
    }
    
    func playerView(_ playerView: InlineYoutubeView, didChangeTo state: YTPlayerState) {
        switch state {
        case .unknown:
            print("Unknown state")
        case .unstarted:
            print("Video Unstarted")
        case .queued:
            print("Video Queued")
        case .buffering:
            print("Video buffering")
        case .playing:
            print("Video started playing")
        case .paused:
            print("Video paused")
        case .ended:
            print("Video ended")
        }
    }
    
    func playerView(_ playerView: InlineYoutubeView, didChangeTo quality: YTPlaybackQuality) {
        print("Quality changed")
    }
    
    func playerView(_ playerView: InlineYoutubeView, receivedError error: YTPlayerError) {
        print("Received error")
    }
    
    func playerView(_ playerView: InlineYoutubeView, didPlayTime playTime: Float) {
        
        //Getting the duration through a completion block
        playerView.getDuration({ duration, error in
            print("currentTime \(playTime)")
            print("totalDuration \(duration)")
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
