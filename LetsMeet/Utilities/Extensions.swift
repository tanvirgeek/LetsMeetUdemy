//
//  Extensions.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 11/8/21.
//

import Foundation
import UIKit

extension Date{
    
    func interval(ofComponent comp:Calendar.Component, fromDate date:Date)->Int{
        let currentCalender = Calendar.current
        
        guard let start = currentCalender.ordinality(of: comp, in: .era, for: self) else {
            return 0
        }
        
        guard let end = currentCalender.ordinality(of: comp, in: .era, for: date) else {
            return 0
        }
        return end - start
    }
    
}

extension UIImage{
    var isPortrait : Bool{ return size.height > size.width}
    var isLandscape : Bool{ return size.width > size.height}
    var breadth:CGFloat { return min(size.width,size.height)}
    var breadthSize : CGSize { return CGSize(width: breadth, height: breadth)}
    var breadthRect : CGRect {return CGRect(origin: .zero, size: breadthSize)}
    
    var circlemasked:UIImage?{
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height)/2) : 0, y: isPortrait ? floor((size.height - size.width)/2) : 0), size: breadthSize)) else{
            return nil
        }
        
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
