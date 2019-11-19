//
//  NAMObjectModel.h
//  NAMLibrary
//
//  Created by Narlei A Moreira on 7/26/16.
//  Copyright © 2016 Narlei A Moreira. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  This class is a base model based in ORM.
 *  You can create all properties and the class will manage Database.
 */

@interface NAMObjectModel : NSObject

/**
 *  Default Primari Key, can be changed using the method `+ (NSArray *)primaryKeys`
 */
@property(nonatomic, strong) NSString *identifier;

#pragma mark - Database

#pragma mark DDL


/**
 * Generate table based on Class. Exemple: [Person sqlGenerateTable];
 * @return Sql Command
 */
+ (NSString *)sqlGenerateTable;

#pragma mark DML

/**
 *  Save all object data on database
 */
- (void)saveData;

/**
 *  Generate a unique key
 *
 *  @return alphanumeric uniquekey
 */
- (NSString *)getUniqueKey;

/**
 *  Ignored properties ingorated by method saveData, if you use some properties to controll getters and setters, put it in this method
 *
 *  @return Array with properties names
 */
+ (NSArray *)ignoredProperties;

/**
 *  Primary keys of table
 *
 *  @return Array with primary keys names
 */
+ (NSArray *)primaryKeys;


#pragma mark - Retrieve de Dados

+ (id)getObjectWithId:(id)key;

+ (NSArray *)getAllDataWhere:(NSString *)pWhere;

// TODO: Implement Delete Data


@end
