//
//  UserCardModel.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 19/8/21.
//

import Foundation
import UIKit

struct UserCardModel:Codable{
    let objectId:String
    let username:String
    let dateOfBirth:Date
    let profession:String?
    let avatarLink:String?
}
