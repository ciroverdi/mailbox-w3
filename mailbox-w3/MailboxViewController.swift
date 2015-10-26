//
//  MailboxViewController.swift
//  mailbox-w3
//
//  Created by cverdi on 10/19/15.
//  Copyright © 2015 walmart. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var feedScrollView: UIScrollView!

    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var messageView: UIImageView!

    @IBOutlet weak var dragLeft: UIView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    
    @IBOutlet weak var dragRight: UIView!
    
    @IBOutlet var listEdge: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet weak var listView: UIImageView!
    
    @IBOutlet weak var rescheduleView: UIImageView!
    
    var initialMessage: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteIcon.hidden = true
        archiveIcon.hidden = true
        laterIcon.hidden = true
        listIcon.hidden = true

        feedScrollView.delegate = self
        feedScrollView.contentSize = feedView.image!.size
        
        panGesture = UIPanGestureRecognizer(target: self, action: "onPan:")
        view.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func changeMessageBackgroundColor() {
        dragLeft.hidden = true
        dragRight.hidden = true

        let position = messageView.frame.origin.x

        if (position > 0 && position <= 240) {
            print("background is green")
            dragRight.hidden = false
            dragRight.backgroundColor = UIColorFromRGB(0x006400)
            archiveIcon.hidden = false
            deleteIcon.hidden = true
            archiveIcon.frame.origin.x = position - 40
            
        } else if (position > 240) {
            print("background is red")
            dragRight.hidden = false
            dragRight.backgroundColor = UIColorFromRGB(0x8B0000)
            archiveIcon.hidden = true
            deleteIcon.hidden = false
            deleteIcon.frame.origin.x = position - 40
            
        } else {
            print("background is yellow")
            dragLeft.hidden = false
            dragLeft.backgroundColor = UIColorFromRGB(0xFFD700)
            laterIcon.hidden = false
            if (position <= -240) {
                print("is list")
                listIcon.hidden = false
                listIcon.frame.origin.x = position + 40
                laterIcon.hidden = true
            } else {
                print("is later")
                laterIcon.hidden = false
                laterIcon.frame.origin.x = position + 40
                listIcon.hidden = true
            }
            print("position: \(position)")
            print("list: \(listIcon.frame.origin.x)")
            print("later: \(laterIcon.frame.origin.x)")
            
        }
    }

    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(view)
        let translation = sender.translationInView(view)

        if panGesture.state == UIGestureRecognizerState.Began {
            print("Gesture point began at: \(point)")

            initialMessage = messageView.frame.origin
            changeMessageBackgroundColor()

        } else if panGesture.state == UIGestureRecognizerState.Changed {
            print("Gesture point changed at: \(point)")
            messageView.frame.origin.x = CGFloat(initialMessage.x + translation.x)
            changeMessageBackgroundColor()
        
        } else if panGesture.state == UIGestureRecognizerState.Ended {
            print("Gesture point ended at: \(point)")
            changeMessageBackgroundColor()
            
        }
    }
}
