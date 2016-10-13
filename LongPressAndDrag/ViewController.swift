//
//  ViewController.swift
//  LongPressAndDrag
//
//  Created by Avakul Panu on 10/12/16.
//  Copyright © 2016 Avakul Panu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var touchLayer: UIView!
    @IBOutlet weak var longPressMeView: UIView!
    
    enum TouchStates {
        case Initial
        case Draging
    }
    
    private var touchStates:TouchStates = .Initial
    private var focusView: UIView?
    private var previousTouchPoint: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        longPressMeView.center.x = screenSize.width/2
        longPressMeView.center.y = screenSize.height/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func handleLongPress(sender: UILongPressGestureRecognizer) {
    
        switch touchStates {
        case .Initial:
            // Check if the longPress is at the longPressMeView
            let longPressPoint = sender.locationInView(view)
            guard CGRectContainsPoint(longPressMeView.frame, longPressPoint) else{
                return
            }
            
            if sender.state == .Began {
                // Create new view on top of the longPressMeView
                let popUpView = UIView(frame: longPressMeView.frame)
                popUpView.backgroundColor = UIColor.brownColor()
                view.addSubview(popUpView)
                //need to send it behind the touch layer
                view.sendSubviewToBack(popUpView)
                
                // hide the longPressMeView
                longPressMeView.hidden = true
                touchStates = .Draging
                
                // set the focus to the newly created popup view
                focusView = popUpView
            }
        case .Draging:
            let point = sender.locationInView(view)
            // If this is the first time then assign it to point
            
            guard let unwrappedFocusView = focusView else {
                return
            }
            
            switch sender.state {
            case .Changed, .Ended:
                let previousCenter = unwrappedFocusView.center
                
                // Calculating translation distance
                let trans = CGPoint(x: point.x - (previousTouchPoint ?? point).x, y: point.y - (previousTouchPoint ?? point).y)
                
                // Calculating new center
                let newCenter = CGPoint(x: previousCenter.x + trans.x, y: previousCenter.y + trans.y)
                
                unwrappedFocusView.center = newCenter
                
                previousTouchPoint = point
                
                if sender.state == .Ended {
                    longPressMeView.hidden = false
                    longPressMeView.center = newCenter
                    unwrappedFocusView.removeFromSuperview()
                    
                    
                    // Reset touchState
                    touchStates = .Initial
                    // Reset the previousTouchPoint
                    previousTouchPoint = nil
                }
            default:
                break
            }
        }
    }
}

