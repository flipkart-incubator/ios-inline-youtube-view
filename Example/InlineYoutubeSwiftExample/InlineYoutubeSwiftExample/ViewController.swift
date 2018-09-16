//
//  ViewController.swift
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

import UIKit

let videoIds = ["2Vv-BfVoq4g", "D5drYkLiLI8", "K0ibBPhiaG0", "ebXbLfLACGM", "mWRsgZuwf_8"]
let VIDEO_INSET = 5
var videoWidth = 0
var videoHeight = 0
var ytTableView: UITableView!

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ytTableView = UITableView.init(frame: self.view.bounds)
        ytTableView.dataSource = self
        ytTableView.delegate = self
        ytTableView.separatorStyle = .none;
        ytTableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        ytTableView.showsVerticalScrollIndicator = false;
        ytTableView.showsHorizontalScrollIndicator = false;
        ytTableView.bounces = false;
        self.view.addSubview(ytTableView)
        videoWidth = Int(UIScreen.main.bounds.size.width) - 2 * VIDEO_INSET;
        videoHeight = (videoWidth * 9) / 16 ; //Maintain the 16:9 aspect ratio according to youtube standards
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let videoRect = CGRect(x: VIDEO_INSET, y: VIDEO_INSET, width: videoWidth, height: videoHeight)
        if(indexPath.section == 0) {
            let videoCell = YTVideoCell.init(frame: videoRect, videoId: videoIds[indexPath.row], playInline: true)
            return videoCell;
        } else {
            let videoCell = YTVideoCell.init(frame: videoRect, videoId: videoIds[indexPath.row], playInline: false)
            return videoCell;
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(videoHeight + 2 * VIDEO_INSET);
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        /* Create custom view to display section header... */
        let label = UILabel.init(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 50))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        if(section == 0) {
            label.text = "InlineVideos"
        } else {
            label.text = "FullScreenVideos"
        }
        view.addSubview(label)
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoCell: YTVideoCell = tableView.cellForRow(at: indexPath) as! YTVideoCell
        videoCell.playButtonClicked()
    }
    
    
}

