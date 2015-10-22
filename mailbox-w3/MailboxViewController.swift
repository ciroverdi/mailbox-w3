//
//  MailboxViewController.swift
//  mailbox-w3
//
//  Created by cverdi on 10/19/15.
//  Copyright © 2015 walmart. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedScrollView.delegate = self
        feedScrollView.contentSize = feedView.image!.size
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: "onPan:")
        messageView.addGestureRecognizer(panRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(messageView)
        var translation = sender.translationInView(messageView)
        var velocity = sender.velocityInView(messageView)
        
        if panRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
        } else if panRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
        } else if panRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
        }
        
    }
    
}
