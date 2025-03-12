//
//  ContractModel+CoreDataProperties.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//
//

import Foundation
import CoreData


extension ContractModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContractModel> {
        return NSFetchRequest<ContractModel>(entityName: "ContractModel")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var backgroundImage: String?
    @NSManaged public var id: UUID?

}

extension ContractModel : Identifiable {

}
