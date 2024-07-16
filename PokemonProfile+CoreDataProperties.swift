//
//  PokemonProfile+CoreDataProperties.swift
//  PokemonProfile
//
//  Created by 전성진 on 7/12/24.
//
//

import Foundation
import CoreData


extension PokemonProfile {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonProfile> {
    return NSFetchRequest<PokemonProfile>(entityName: "PokemonProfile")
  }
  
  @NSManaged public var key: UUID?
  @NSManaged public var name: String?
  @NSManaged public var phoneNumber: String?
  @NSManaged public var profileImage: Data?
  
}

extension PokemonProfile : Identifiable {
  
}
