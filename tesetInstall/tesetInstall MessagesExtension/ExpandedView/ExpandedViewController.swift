//
//  ExpandedViewController.swift
//  tesetInstall MessagesExtension
//
//  Created by Serhii Molodets on 25.09.2023.
//

import UIKit
protocol ExpandedViewControllerDelegate {
    func sendButtonDidTap(with url: URL)
}

class ExpandedViewController: UIViewController {
    
    var delegate: ExpandedViewControllerDelegate?
    
    var videoPlayerView: VideoPlayerView?
    var url: URL?


    override func viewDidLoad() {
        super.viewDidLoad()
        VideoService.instance.delegate = self
        VideoService.instance.launchVideoRecorder(in: self, completion: nil)
    }
    
    @IBAction func sendBUttonDidTap(_ sender: Any) {
        delegate?.sendButtonDidTap(with: url!)
    }
    
}

extension ExpandedViewController : VideoServiceDelegate {
    
    func videoDidFinishSaving(error: Error?, url: URL?) {
        let success: Bool = error == nil && url != nil
        
        if success {
            playMovie(with: url!)
            self.url = url
        }
    }
        
}


extension ExpandedViewController {
     
    private func playMovie(with url: URL) {
        let playerRect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width / 2)
        videoPlayerView = VideoPlayerView(withFrame: playerRect, videoURLString: url.path)
        view.addSubview(videoPlayerView!)
    }
   
}
