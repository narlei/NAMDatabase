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

        // Retrieve Data
        if let personResult = Person.getObjectWithId(id) as? Person {
            print(personResult.name)
        }
        
        if let array = Person.getAllDataWhere("name like 'Nar%'") as? [Person] {
            print(array)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
