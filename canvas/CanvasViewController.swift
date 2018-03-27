//
//  CanvasViewController.swift
//  canvas
//
//  Created by Biswash Adhikari on 3/25/18.
//  Copyright © 2018 Biswash Adhikari. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var trayView: UIView!
    var trayDownOffset: CGFloat! = nil
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var trayOriginalCenter: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        var velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture is changing")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayDown
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayUp
                }
            }
        }
        
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            newlyCreatedFace.isUserInteractionEnabled = true
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanNewFace(sender:)))
            newlyCreatedFace.addGestureRecognizer(panGesture)
            panGesture.delegate = self
            
            let doubletap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(sender:)))
            doubletap.numberOfTapsRequired = 2
            
            newlyCreatedFace.addGestureRecognizer(doubletap)
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
            newlyCreatedFace.addGestureRecognizer(pinchGesture)
            
            
            UIView.animate(withDuration: 0.05, animations: {
                self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: 2, y: 2)
            })
        }
        else if sender.state == .changed {
            let translation = sender.translation(in: view)
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            if (newlyCreatedFace.center.y > 450) {
                newlyCreatedFace.removeFromSuperview()
            }
            UIView.animate(withDuration: 0.05, animations: {
                self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: 0.5, y: 0.5)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 230
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func didPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        sender.scale = 1
    }
    
    @objc func didDoubleTap(sender: UITapGestureRecognizer) {
        let imgView = sender.view as! UIImageView
        imgView.removeFromSuperview()
    }
    
    @objc func didPanNewFace(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
            UIView.animate(withDuration: 0.05, animations: {
                self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: 2, y: 2)
            })
            
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            if (newlyCreatedFace.center.y > 450) {
                newlyCreatedFace.removeFromSuperview()
            }
            UIView.animate(withDuration: 0.05, animations: {
                self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: 0.5, y: 0.5)
            })
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
