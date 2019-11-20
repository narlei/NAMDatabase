//
//  ViewController.swift
//  NAMDatabase
//
//  Created by narlei on 11/19/2019.
//  Copyright (c) 2019 narlei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Save Data
        let person = Person()
        let id = person.getUniqueKey()
        person.name = "Narlei"
        person.identifier = id
        person.saveData()

        // Retrieve Data by ID
        if let personResult = Person.getObjectWithId(id) as? Person {
            print(personResult.name)
        }

        // Retrieve Data by SQLite where
        if let array = Person.getAllDataWhere("name like 'Nar%'") as? [Person] {
            print(array)
        }

        // Delete Data
        Person.deleteObject(withId: id)

        // Verify if is Deleted
        if let personResult = Person.getObjectWithId(id) as? Person {
            print(personResult.name)
        } else {
            print("Deleted")
        }

        // Recreate object
        person.saveData()
        // Verify if is Created
        if let personResult = Person.getObjectWithId(id) as? Person {
            print("Created againt \(String(describing: personResult.name))")
        }

        // Delete Data by SQLite where
        Person.deleteAllDataWhere("name like 'Nar%'")

        // Verify if is Deleted
        if let personResult = Person.getObjectWithId(id) as? Person {
            print(personResult.name)
        } else {
            print("Deleted")
        }

        // Recreate object
        person.saveData()
        // Verify if is Created
        if let personResult = Person.getObjectWithId(id) as? Person {
            print("Created againt \(String(describing: personResult.name))")
        }

        // Delete current object
        person.deleteData()
        // Verify if is Deleted
        if let personResult = Person.getObjectWithId(id) as? Person {
            print(personResult.name)
        } else {
            print("Deleted")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
