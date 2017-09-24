//
//  Animated_Down.swift
//  Novesta
//
//  Created by Pop Pro on 9/24/17.
//  Copyright © 2017 Brian Lin. All rights reserved.
//

import UIKit

class Animated_Down: UIStoryboardSegue {
    override func perform(){
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: 0, y: -src.view.frame.size.height)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear,animations: {
            
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }, completion: { finished in
            src.present(dst, animated: false, completion: nil)
        })
    }
}
