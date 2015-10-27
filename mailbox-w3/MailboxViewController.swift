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
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    
    @IBOutlet weak var dragRight: UIView!
    
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    
    var initialMessage: CGPoint!
    var currentPoint: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteIcon.hidden = true
        archiveIcon.hidden = true
        laterIcon.hidden = true
        listIcon.hidden = true
        
        listView.alpha = 0
        rescheduleView.alpha = 0

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
    
    func changeBackgroundColor() {
        dragLeft.hidden = true
        dragRight.hidden = true

        let position = messageView.frame.origin.x
        print("position: \(position)")
        
        if (position > 0 && position <= 60) {
            print("left background is grey")
            dragRight.hidden = false
            dragRight.backgroundColor = UIColorFromRGB(0xC0C0C0)
            archiveIcon.hidden = false
            archiveIcon.alpha = 0.5
            deleteIcon.hidden = true
            archiveIcon.frame.origin.x = position - 40
            
        } else if (position > 60 && position <= 230) {
            print("left background is green")
            dragRight.hidden = false
            dragRight.backgroundColor = UIColorFromRGB(0x006400)
            archiveIcon.hidden = false
            archiveIcon.alpha = 1.0
            deleteIcon.hidden = true
            archiveIcon.frame.origin.x = position - 40
            
        } else if (position > 230) {
            print("left background is red")
            dragRight.hidden = false
            dragRight.backgroundColor = UIColorFromRGB(0x8B0000)
            archiveIcon.hidden = true
            deleteIcon.hidden = false
            deleteIcon.frame.origin.x = position - 40
            
        } else if (position < 0 && position > -60) {
            print("right background is grey")
            dragRight.hidden = true
            dragLeft.hidden = false
            dragLeft.backgroundColor = UIColorFromRGB(0xC0C0C0)
            dragLeft.alpha = 1.0
            laterIcon.hidden = false
            laterIcon.alpha = 0.5
            laterIcon.frame.origin.x = currentPoint.x + 40
            listIcon.hidden = true

        } else if (position < -60 && position > -240) {
            print("right background is yellow")
            print("is later")
            dragRight.hidden = true
            dragLeft.hidden = false
            dragLeft.backgroundColor = UIColorFromRGB(0xFFD700)
            dragLeft.alpha = 1.0
            laterIcon.hidden = false
            laterIcon.alpha = 1.0
            laterIcon.frame.origin.x = currentPoint.x + 40
            listIcon.hidden = true
        } else {
            print("right background is yellow")
            print("is list")
            dragRight.hidden = true
            dragLeft.hidden = false
            dragLeft.backgroundColor = UIColorFromRGB(0xFFD700)
            dragLeft.alpha = 0.5
            listIcon.hidden = false
            listIcon.alpha = 1.0
            listIcon.frame.origin.x = currentPoint.x + 40
            laterIcon.hidden = true
        }
    }
    
    func rescheduleOrList() {
        let position = messageView.frame.origin.x
        
        if (position <= -230) {
            listView.alpha = 1
            rescheduleView.alpha = 0
            print("listView is true")
        } else if (position < -50) {
            listView.alpha = 0
            rescheduleView.alpha = 1
            print("rescheduleView is true")
        }

    }

    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        currentPoint = sender.locationInView(view)
        let translation = sender.translationInView(view)

        if panGesture.state == UIGestureRecognizerState.Began {
            print("Gesture point began at: \(currentPoint)")
            initialMessage = messageView.frame.origin
            changeBackgroundColor()

        } else if panGesture.state == UIGestureRecognizerState.Changed {
            print("Gesture point changed at: \(currentPoint)")
            messageView.frame.origin.x = CGFloat(initialMessage.x + translation.x)
            changeBackgroundColor()
        
        } else if panGesture.state == UIGestureRecognizerState.Ended {
            print("Gesture point ended at: \(currentPoint)")
            changeBackgroundColor()
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    self.rescheduleOrList()
                    self.messageView.frame.origin.x = 0
                }, completion: nil)
        }
    }

    @IBAction func onTap(sender: UITapGestureRecognizer) {
        print("onTap")
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.listView.alpha = 0
            self.rescheduleView.alpha = 0
        }, completion: nil)
    }
}
