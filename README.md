# NAMDatabase

[![Version](https://img.shields.io/cocoapods/v/NAMDatabase.svg?style=flat)](https://cocoapods.org/pods/NAMDatabase)
[![License](https://img.shields.io/cocoapods/l/NAMDatabase.svg?style=flat)](https://cocoapods.org/pods/NAMDatabase)
[![Platform](https://img.shields.io/cocoapods/p/NAMDatabase.svg?style=flat)](https://cocoapods.org/pods/NAMDatabase)
[![Twitter](https://img.shields.io/badge/twitter-@narleimoreira-blue.svg?style=flat)](https://twitter.com/narleimoreira)

## About

NAMDatabase is a very simple way to use SQLite. Forget parsers, selects, updates! Just `.saveData()` or `.delete()` for example. 

The Core of solution is the **NAMObjectModel** class. It abstract all sql commands.

When you initialize the library for the first time, NAMDatabase creates a .sqlite database and all the tables based in classes that implement **NAMObjectModel**.



## How it works

### First, create a model:
If you need to persist a property, add `@objc`.


````Swift
import NAMDatabase

class Person: NAMObjectModel {
    @objc var name: String!
}
````

### Initialize 

This code will create the Database and all Tables.

In your AppDelegate add:

````Swift
NAMDatabase.shared()?.initialize(true)
````
Send true to log the Database Path.



If you need recreate the tables run:

````Swift
NAMDatabase.shared()?.createAllTables()
````

This code will drop and recreate the database, be carrefully. 

### Saving Data:

````Swift
let person = Person()
person.name = "Narlei"
person.identifier = "MY_ID"
person.saveData()
````
If a register with id == "MY_ID" already exists, will be updated.

To get a unique ID you can use:

````Swift
let person = Person()
let id = person.getUniqueKey()
person.identifier = id
person.saveData()
````

### Retrieving Data:

````Swift
// Get by Identifier:
if let personResult = Person.getObjectWithId("MY_ID") as? Person {
	print(personResult.name)
}

// Get with SQLite where:
if let array = Person.getAllDataWhere("name like 'Nar%'") as? [Person] {
	print(array)
}
````

### Delete Data

Delete by Identifier:

````Swift
Person.deleteObject(withId: "MY_ID")

````

Delete with SQLite where:

````Swift
Person.deleteAllDataWhere("name like 'Nar%'")
````

### Ignored Properties

In Swift classes, if you want to ignore properties, just not add `@objc` or you can use:

````Swift 
override class func ignoredProperties() -> [Any]! {
    return ["name"]
}

````

### Primary Key

A default property `identifier` is the primary key, you can change it using:

````Swift 
override class func primaryKeys() -> [Any]! {
	return ["id"]
}
````


## Installation

NAMDatabase is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NAMDatabase'
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

See the examples [here](https://github.com/narlei/NAMDatabase/blob/master/Example/NAMDatabase/ViewController.swift)

## TODO

- Create template to create Models;
- Database migration Helper;


## Author

narlei, narlei.guitar@gmail.com

## License

NAMDatabase is available under the MIT license. See the LICENSE file for more info.

## Pay me a coffee:

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=NMQM9R9GLZQXC&lc=BR&item_name=Narlei%20Moreira&item_number=development%2fdesign&currency_code=BRL&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)
