# NAMDatabase

[![Version](https://img.shields.io/cocoapods/v/NAMDatabase.svg?style=flat)](https://cocoapods.org/pods/NAMDatabase)
[![License](https://img.shields.io/cocoapods/l/NAMDatabase.svg?style=flat)](https://cocoapods.org/pods/NAMDatabase)
[![Platform](https://img.shields.io/cocoapods/p/NAMDatabase.svg?style=flat)](https://cocoapods.org/pods/NAMDatabase)
[![Twitter](https://img.shields.io/badge/twitter-@narleimoreira-blue.svg?style=flat)](https://twitter.com/narleimoreira)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How it works

### First, create a model:
If you need to persist a property, add `@objc`.


````Swift
import NAMDatabase

class Person: NAMObjectModel {
    @objc var name: String!
}
````

### Creating tables:

In your AppDelegate add:

````Swift
NAMDatabase.shared()?.createAllTables()
````

This code will drop and create the database, execute only in first execution of app. 

### Saving Data:

````Swift
let person = Person()
person.name = "Narlei"
person.identifier = "MY_ID"
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


## Installation

NAMDatabase is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NAMDatabase'
```

## TODO

- Create Database automatically in first app execution
- Create template to create Models


## Author

narlei, narlei.guitar@gmail.com

## License

NAMDatabase is available under the MIT license. See the LICENSE file for more info.
