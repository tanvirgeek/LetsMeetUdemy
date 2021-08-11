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
