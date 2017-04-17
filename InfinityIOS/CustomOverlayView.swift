//
//  CustomOverlayView.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 11/04/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import Foundation

import UIKit
import Koloda

private let overlayRightImageName = "T_like_b"
private let overlayLeftImageName = "T_skip_b"

class CustomOverlayView: OverlayView {
    
    @IBOutlet lazy var like: UIImageView! = {
        [unowned self] in
        let windowWidth = self.window?.frame.size.width;
        var imageView = UIImageView(frame: CGRect.init(x: windowWidth! - 200, y: 50, width: 150, height: 150))
        self.addSubview(imageView)
        
        return imageView
    }()
    
    @IBOutlet lazy var skip: UIImageView! = {
        [unowned self] in
        var imageView = UIImageView(frame: CGRect.init(x:50, y: 50, width: 150, height: 150))
        self.addSubview(imageView)
        
        return imageView
    }()
    
    override var overlayState: SwipeResultDirection?  {
        didSet {
            like.image = nil
            skip.image = nil
            switch overlayState {
                case .left? :
                    like.image = UIImage(named: overlayLeftImageName)
                case .right? :
                     skip.image = UIImage(named: overlayRightImageName)
                default:
                     like.image = nil
                     skip.image = nil
            }
        }
    }
    
}
