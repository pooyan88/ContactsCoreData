//
//  ContactModel+CoreDataProperties.swift
//  Contact
//
//  Created by Pooyan J on 12/23/1403 AP.
//
//

import Foundation
import CoreData


extension ContactModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactModel> {
        return NSFetchRequest<ContactModel>(entityName: "ContactModel")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var firstName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?

}

extension ContactModel : Identifiable {

}
