//
//  MyCoreDataStore.swift
//  Swift(CoreData)
//
//  Created by KentarOu on 2015/08/09.
//  Copyright (c) 2015年 KentarOu. All rights reserved.
//

import UIKit
import CoreData

@objc(MyCoreDataStore)
class MyCoreDataStore: NSManagedObject {
    
    @NSManaged var statement:String
    @NSManaged var time:NSDate
    
}
