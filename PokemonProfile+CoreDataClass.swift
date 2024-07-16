//
//  PokemonProfile+CoreDataClass.swift
//  PokemonProfile
//
//  Created by 전성진 on 7/12/24.
//
//

import Foundation
import CoreData

@objc(PokemonProfile)
public class PokemonProfile: NSManagedObject {
  public static let className = "PokemonProfile"
  public enum Key {
    static let key = "key"
    static let name = "name"
    static let phoneNumber = "phoneNumber"
    static let profileImage = "profileImage"
  }
}
